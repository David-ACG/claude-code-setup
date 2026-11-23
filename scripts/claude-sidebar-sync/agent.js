#!/usr/bin/env node
// Claude desktop sidebar sync: the part that runs ON a Windows laptop.
// Driven from hlab by sync.py. Node only, no packages.
//
//   node agent.js export              -> JSON on stdout: where the app keeps its
//                                        sidebar, every session record (metadata
//                                        only), deleted markers, archive index,
//                                        the three sidebar prefs, the newest
//                                        working sshConfig.
//   node agent.js apply <stageDir>    -> copies stageDir/records/** into the
//                                        sessions folder and merges
//                                        stageDir/plan.json into the config.
//                                        MUST run with the desktop app closed
//                                        (the app rewrites its config on quit).
//
// Never deletes or overwrites an existing record, and never brings back a
// session that has a deleted_ marker on this laptop.
'use strict';
const fs = require('fs');
const path = require('path');

const PREF_KEYS = ['dframe-group-scopes', 'dframe-code-sections', 'starred-local-code-sessions'];

function findBase() {
  const cands = [];
  const la = process.env.LOCALAPPDATA;
  const ra = process.env.APPDATA;
  if (la) {
    const cd = path.join(la, 'Claude-Data');            // Microsoft Store build
    if (fs.existsSync(cd)) {
      for (const d of fs.readdirSync(cd)) cands.push(path.join(cd, d));
    }
  }
  if (ra) cands.push(path.join(ra, 'Claude'));            // standard installer build
  for (const c of cands) {
    if (fs.existsSync(path.join(c, 'claude-code-sessions')) &&
        fs.existsSync(path.join(c, 'claude_desktop_config.json'))) return c;
  }
  throw new Error('no Claude desktop data folder found in ' + JSON.stringify(cands));
}

// claude-code-sessions/<account>/<org>/ ; returns ["<account>/<org>", ...]
function scopeDirs(sessRoot) {
  const out = [];
  for (const a of fs.readdirSync(sessRoot, { withFileTypes: true })) {
    if (!a.isDirectory()) continue;
    for (const o of fs.readdirSync(path.join(sessRoot, a.name), { withFileTypes: true })) {
      if (o.isDirectory()) out.push(a.name + '/' + o.name);
    }
  }
  return out;
}

function readJson(p) { return JSON.parse(fs.readFileSync(p, 'utf8')); }

function readIdx(p) {
  try { const j = readJson(p); return Array.isArray(j.archived) ? j.archived : []; } catch { return []; }
}

function doExport() {
  const base = findBase();
  const sessRoot = path.join(base, 'claude-code-sessions');
  const configPath = path.join(base, 'claude_desktop_config.json');
  const scopes = {};
  let newestSsh = null;
  for (const scope of scopeDirs(sessRoot)) {
    const dir = path.join(sessRoot, ...scope.split('/'));
    const records = {};
    const deleted = [];
    for (const f of fs.readdirSync(dir)) {
      const full = path.join(dir, f);
      if (f.startsWith('deleted_')) { deleted.push(f.slice('deleted_'.length)); continue; }
      if (!/^local_.*\.json$/.test(f)) continue;
      const st = fs.statSync(full);
      let j;
      try { j = readJson(full); } catch (e) { records[f.slice(0, -5)] = { parseError: String(e) }; continue; }
      const ssh = j.sshConfig && j.sshConfig.sshHost ? j.sshConfig : null;
      records[f.slice(0, -5)] = {
        createdAt: j.createdAt, lastActivityAt: j.lastActivityAt, title: j.title,
        cwd: j.cwd, isArchived: !!j.isArchived, sshHost: ssh ? ssh.sshHost : null,
        mtime: st.mtimeMs, size: st.size,
      };
      if (ssh && (!newestSsh || (j.createdAt || 0) > newestSsh.createdAt)) {
        newestSsh = { createdAt: j.createdAt || 0, sshConfig: ssh, from: f };
      }
    }
    scopes[scope] = { records, deleted, archivedIdx: readIdx(path.join(dir, 'archived-sessions.idx')) };
  }
  const cfg = readJson(configPath);
  const ep = (cfg.preferences && cfg.preferences.epitaxyPrefs) || {};
  const prefs = {};
  for (const k of PREF_KEYS) prefs[k] = ep[k] === undefined ? null : ep[k];
  process.stdout.write(JSON.stringify({
    computer: process.env.COMPUTERNAME, base, sessRoot, configPath, scopes, prefs,
    newestSsh, exportedAt: Date.now(),
  }));
}

// ---- apply -------------------------------------------------------------------

function writeAtomic(p, text) {
  const tmp = p + '.sync-tmp';
  fs.writeFileSync(tmp, text);
  fs.renameSync(tmp, p);
}

function doApply(stage) {
  const plan = readJson(path.join(stage, 'plan.json'));
  const log = [];
  const result = { ok: false, at: new Date().toISOString(), copied: [], skipped: [], log };
  const stamp = new Date().toISOString().replace(/[:.]/g, '-');

  // 1. session records
  for (const [scope, s] of Object.entries(plan.scopes)) {
    const dir = path.join(plan.sessRoot, ...scope.split('/'));
    fs.mkdirSync(dir, { recursive: true });
    for (const id of s.records) {
      const dest = path.join(dir, id + '.json');
      const uuid = id.replace(/^local_/, '');
      if (fs.existsSync(dest)) { result.skipped.push(id + ' (already there)'); continue; }
      if (fs.existsSync(path.join(dir, 'deleted_' + uuid))) { result.skipped.push(id + ' (deleted here)'); continue; }
      const src = path.join(stage, 'records', scope.replace('/', '__'), id + '.json');
      JSON.parse(fs.readFileSync(src, 'utf8'));          // refuse to copy a broken file
      fs.copyFileSync(src, dest);
      result.copied.push(id);
    }
    if (s.archived && s.archived.length) {
      const idxPath = path.join(dir, 'archived-sessions.idx');
      let idx = { v: 1, archived: [] };
      if (fs.existsSync(idxPath)) {
        try { idx = readJson(idxPath); } catch { log.push('archived-sessions.idx unreadable, left alone'); idx = null; }
      }
      if (idx) {
        if (!Array.isArray(idx.archived)) idx.archived = [];
        for (const id of s.archived) if (!idx.archived.includes(id)) idx.archived.push(id);
        writeAtomic(idxPath, JSON.stringify(idx));
      }
    }
  }

  // 2. sidebar prefs (sections, which section each session sits in, pins)
  const cfgText = fs.readFileSync(plan.configPath, 'utf8');
  fs.writeFileSync(plan.configPath + '.bak-sidebar-sync-' + stamp, cfgText);
  const cfg = JSON.parse(cfgText);
  cfg.preferences = cfg.preferences || {};
  const ep = cfg.preferences.epitaxyPrefs = cfg.preferences.epitaxyPrefs || {};
  const m = plan.prefs || {};

  // dframe-group-scopes: { "<acct>/<org>": {
  //   groups: [{id,name,mode}],
  //   assignments: { "code:local_<uuid>": "cg-..." },     which section a session sits in
  //   order: { "cg-...": ["code:local_<uuid>", ...] } } }  order inside a section
  if (m.groupScopes) {
    const gs = ep['dframe-group-scopes'] = ep['dframe-group-scopes'] || {};
    for (const [scope, add] of Object.entries(m.groupScopes)) {
      const cur = gs[scope] = gs[scope] || {};
      cur.groups = cur.groups || [];
      cur.assignments = cur.assignments || {};
      cur.order = cur.order || {};
      for (const g of add.groups || []) {
        if (!cur.groups.some((x) => x.id === g.id)) { cur.groups.push(g); log.push('added group ' + g.name); }
      }
      for (const [key, gid] of Object.entries(add.assignments || {})) {
        if (cur.assignments[key] === undefined) cur.assignments[key] = gid;
      }
      for (const [gid, keys] of Object.entries(add.order || {})) {
        const list = cur.order[gid] = cur.order[gid] || [];
        for (const key of keys.slice().reverse()) {
          if (!list.includes(key)) list.unshift(key);          // newest first
        }
      }
    }
  }
  // dframe-code-sections: { "<acct>/<org>": { sections: [...] } } -> add missing sections only
  if (m.codeSections) {
    const cs = ep['dframe-code-sections'] = ep['dframe-code-sections'] || {};
    for (const [scope, secs] of Object.entries(m.codeSections)) {
      const cur = cs[scope] = cs[scope] || { sections: [] };
      cur.sections = cur.sections || [];
      for (const sec of secs) {
        if (!cur.sections.some((x) => x.id === sec.id)) { cur.sections.push(sec); log.push('added section ' + (sec.name || sec.id)); }
      }
    }
  }
  // starred-local-code-sessions: [ids] -> add pins for copied sessions
  if (m.stars && m.stars.length) {
    const st = ep['starred-local-code-sessions'] = ep['starred-local-code-sessions'] || [];
    for (const id of m.stars) if (!st.includes(id)) st.push(id);
  }
  writeAtomic(plan.configPath, JSON.stringify(cfg, null, 2));
  JSON.parse(fs.readFileSync(plan.configPath, 'utf8'));   // must still parse
  result.ok = true;
  fs.writeFileSync(path.join(stage, 'result.json'), JSON.stringify(result, null, 2));
  process.stdout.write(JSON.stringify(result));
}

const [cmd, arg] = process.argv.slice(2);
try {
  if (cmd === 'export') doExport();
  else if (cmd === 'apply') doApply(arg);
  else { console.error('usage: node agent.js export | apply <stageDir>'); process.exit(2); }
} catch (e) {
  if (cmd === 'apply' && arg) {
    try { fs.writeFileSync(path.join(arg, 'result.json'), JSON.stringify({ ok: false, error: String(e.stack || e) }, null, 2)); } catch {}
  }
  console.error(String(e.stack || e));
  process.exit(1);
}
