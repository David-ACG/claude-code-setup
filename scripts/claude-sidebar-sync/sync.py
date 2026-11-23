#!/usr/bin/env python3
"""Copy Claude desktop Code-tab sidebar entries between David's Windows laptops.

Every Code-tab session runs on hlab, but each laptop keeps its OWN sidebar list
(one small record per session + which section it sits in + pins). The app does
not sync that list, so sessions started on one laptop are missing on the other.
This copies the missing entries both ways. It never deletes or overwrites an
entry, and never brings back a session deleted on the destination.

    sync.py                         dry run: what is missing on each laptop
    sync.py --apply                 stage the copy on each laptop that needs it
    sync.py --apply --relaunch here   ...and reopen Claude on the laptop this
                                      session runs from once the copy lands
    sync.py status                  did a staged copy land? (per laptop)
    sync.py where                   which laptop is this session running from?

The copy lands the moment Claude is fully quit on that laptop (tray -> Quit):
a one-shot SYSTEM scheduled task (ClaudeSidebarSync) waits for the desktop app
to close, merges, optionally reopens it, then removes itself. If the laptop
restarts first, it lands at startup instead.

Laptop side: agent.js (export / apply) and waiter.ps1, copied over each run.
Nothing runs without SSH from hlab: `ssh x1eg3` / `ssh t14s` (see memory notes).
"""
import argparse
import base64
import copy
import json
import os
import subprocess
import sys
import time
from pathlib import Path

HERE = Path(__file__).resolve().parent
HOSTS = {
    # ssh alias: addresses the laptop connects to hlab from (Tailscale, LAN)
    'x1eg3': {'addrs': ['100.114.161.65'], 'label': 'X1EG3'},
    't14s': {'addrs': ['100.84.18.101', '192.168.178.32'], 'label': 'T14s'},
}
STATE = Path.home() / '.local/state/claude-sidebar-sync'
STRIP = ('sshReattach', 'sshRemoteProcessId', 'bridgeSessionIds')
TASK = 'ClaudeSidebarSync'
SSH = ['ssh', '-o', 'BatchMode=yes', '-o', 'ConnectTimeout=15']
SCP = ['scp', '-o', 'BatchMode=yes', '-o', 'ConnectTimeout=15', '-q']


def die(msg):
    print('ERROR: ' + msg, file=sys.stderr)
    sys.exit(1)


def ps(host, script, timeout=120):
    """Run a PowerShell script on a laptop; return stdout."""
    enc = base64.b64encode(("$ProgressPreference='SilentlyContinue'\n" + script)
                           .encode('utf-16le')).decode()
    r = subprocess.run(SSH + [host, 'powershell -NoProfile -EncodedCommand ' + enc],
                       capture_output=True, text=True, timeout=timeout)
    if r.returncode != 0:
        die(f'{host}: PowerShell failed ({r.returncode}): {r.stderr.strip()[:800]}')
    return r.stdout.replace('\r', '')


def fwd(winpath):
    return winpath.replace('\\', '/')


def agent_dir(host):
    out = ps(host, "(New-Item -ItemType Directory -Force "
                   "(Join-Path $env:LOCALAPPDATA 'claude-sidebar-sync')).FullName")
    return out.strip().splitlines()[-1]


def push(host, local, remote_dir):
    r = subprocess.run(SCP + ['-r', str(local), f'{host}:{fwd(remote_dir)}/'],
                       capture_output=True, text=True, timeout=300)
    if r.returncode != 0:
        die(f'{host}: copy of {local} failed: {r.stderr.strip()}')


def pull(host, remote, local):
    r = subprocess.run(SCP + [f'{host}:{fwd(remote)}', str(local)],
                       capture_output=True, text=True, timeout=300)
    if r.returncode != 0:
        die(f'{host}: fetch of {remote} failed: {r.stderr.strip()}')


def export(host):
    adir = agent_dir(host)
    push(host, HERE / 'agent.js', adir)
    r = subprocess.run(SSH + [host, f"& 'C:\\Program Files\\nodejs\\node.exe' '{adir}\\agent.js' export"],
                       capture_output=True, text=True, timeout=180)
    if r.returncode != 0:
        die(f'{host}: export failed: {r.stderr.strip()[:800]}')
    e = json.loads(r.stdout)
    e['host'] = host
    e['agentDir'] = adir
    return e


def where():
    """Which laptop does this session run from (via SSH_CONNECTION)?"""
    conn = os.environ.get('SSH_CONNECTION', '') or os.environ.get('SSH_CLIENT', '')
    ip = conn.split()[0] if conn else ''
    for h, v in HOSTS.items():
        if ip in v['addrs']:
            return h
    return None


def fmt_ms(ms):
    if not ms:
        return '?'
    return time.strftime('%d %b %H:%M', time.localtime(ms / 1000))


def diff(src, dst):
    """Records on src that dst lacks, plus why others were skipped."""
    copy_ids, skipped = [], []
    for scope, s in src['scopes'].items():
        d = dst['scopes'].get(scope, {'records': {}, 'deleted': []})
        for rid, meta in s['records'].items():
            if rid in d['records']:
                continue
            title = meta.get('title') or '(untitled)'
            if meta.get('parseError'):
                skipped.append((rid, title, 'record unreadable on ' + HOSTS[src['host']]['label']))
            elif rid.replace('local_', '', 1) in d.get('deleted', []):
                skipped.append((rid, title, 'deleted on ' + HOSTS[dst['host']]['label']))
            elif not meta.get('sshHost'):
                skipped.append((rid, title, 'runs on the laptop itself, not on hlab'))
            else:
                copy_ids.append((scope, rid, meta))
    copy_ids.sort(key=lambda x: -(x[2].get('lastActivityAt') or x[2].get('createdAt') or 0))
    return copy_ids, skipped


def build_stage(src, dst, items, stage):
    """Fetch, adjust and package the records + sidebar placement for dst."""
    if not dst.get('newestSsh'):
        die(f"{dst['host']} has no SSH session yet, so there is no working hlab connection to copy onto")
    ssh_cfg = dst['newestSsh']['sshConfig']
    plan = {'source': src['host'], 'dest': dst['host'], 'createdAt': time.strftime('%Y-%m-%dT%H:%M:%S'),
            'sessRoot': dst['sessRoot'], 'configPath': dst['configPath'], 'scopes': {},
            'prefs': {'groupScopes': {}, 'codeSections': {}, 'stars': []}}
    sgs = src['prefs'].get('dframe-group-scopes') or {}
    dgs = dst['prefs'].get('dframe-group-scopes') or {}
    scs = src['prefs'].get('dframe-code-sections') or {}
    dcs = dst['prefs'].get('dframe-code-sections') or {}
    sstars = src['prefs'].get('starred-local-code-sessions') or []
    for scope, rid, _meta in items:
        rdir = stage / 'records' / scope.replace('/', '__')
        rdir.mkdir(parents=True, exist_ok=True)
        raw = rdir / (rid + '.raw')
        pull(src['host'], src['sessRoot'] + '\\' + scope.replace('/', '\\') + '\\' + rid + '.json', raw)
        rec = json.loads(raw.read_text(encoding='utf-8'))
        rec['sshConfig'] = copy.deepcopy(ssh_cfg)     # this laptop's own working hlab connection
        for k in STRIP:                                 # let it start its own remote process
            rec.pop(k, None)
        (rdir / (rid + '.json')).write_text(json.dumps(rec, ensure_ascii=False, separators=(',', ':')),
                                           encoding='utf-8')
        raw.unlink()
        sc = plan['scopes'].setdefault(scope, {'records': [], 'archived': []})
        sc['records'].append(rid)
        if rid in src['scopes'][scope].get('archivedIdx', []):
            sc['archived'].append(rid)
        if rid in sstars:
            plan['prefs']['stars'].append(rid)
        # which section it sits in, and where inside that section
        key = 'code:' + rid
        g_src = sgs.get(scope, {})
        gid = (g_src.get('assignments') or {}).get(key)
        if gid:
            add = plan['prefs']['groupScopes'].setdefault(scope, {'groups': [], 'assignments': {}, 'order': {}})
            add['assignments'][key] = gid
            if key in (g_src.get('order') or {}).get(gid, []):
                add['order'].setdefault(gid, []).append(key)
            have = {g['id'] for g in (dgs.get(scope, {}).get('groups') or [])}
            for g in g_src.get('groups') or []:
                if g['id'] == gid and gid not in have and g not in add['groups']:
                    add['groups'].append(g)
            dsec = {x['id'] for x in (dcs.get(scope, {}).get('sections') or [])}
            for sec in (scs.get(scope, {}).get('sections') or []):
                if sec['id'] == gid and gid not in dsec:
                    lst = plan['prefs']['codeSections'].setdefault(scope, [])
                    if sec not in lst:
                        lst.append(sec)
    (stage / 'plan.json').write_text(json.dumps(plan, ensure_ascii=False, indent=1), encoding='utf-8')
    return plan


REGISTER = r"""
$adir = '__ADIR__'; $stage = '__STAGE__'; $relaunch = __RELAUNCH__
$old = Get-ScheduledTask -TaskName '__TASK__' -ErrorAction SilentlyContinue
if ($old) { Stop-ScheduledTask -TaskName '__TASK__' -ErrorAction SilentlyContinue; Unregister-ScheduledTask -TaskName '__TASK__' -Confirm:$false }
$arg = "-NoProfile -ExecutionPolicy Bypass -File `"$adir\waiter.ps1`" -Stage `"$stage`" -AgentDir `"$adir`""
if ($relaunch) {
  $exe = Join-Path $env:LOCALAPPDATA 'AnthropicClaude\claude.exe'
  if (Test-Path $exe) { $ra = New-ScheduledTaskAction -Execute $exe }
  else {
    $pkg = Get-AppxPackage -Name 'Claude' | Select-Object -First 1
    if (-not $pkg) { throw 'Claude desktop app not found for relaunch' }
    $appId = (Get-AppxPackageManifest $pkg).Package.Applications.Application | Select-Object -First 1 -ExpandProperty Id
    $ra = New-ScheduledTaskAction -Execute 'explorer.exe' -Argument "shell:AppsFolder\$($pkg.PackageFamilyName)!$appId"
  }
  $rp = New-ScheduledTaskPrincipal -UserId "$env:COMPUTERNAME\$env:USERNAME" -LogonType Interactive
  Register-ScheduledTask -TaskName '__TASK__-Relaunch' -Action $ra -Principal $rp -Force | Out-Null
  $arg += ' -Relaunch'
}
$action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument $arg
$t1 = New-ScheduledTaskTrigger -Once -At (Get-Date).AddSeconds(10)
$t2 = New-ScheduledTaskTrigger -AtStartup
$pr = New-ScheduledTaskPrincipal -UserId 'SYSTEM' -LogonType ServiceAccount -RunLevel Highest
$st = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -ExecutionTimeLimit (New-TimeSpan -Days 3) -MultipleInstances IgnoreNew
Register-ScheduledTask -TaskName '__TASK__' -Action $action -Trigger $t1,$t2 -Principal $pr -Settings $st -Force | Out-Null
"registered $((Get-ScheduledTask -TaskName '__TASK__').State)"
"""

STATUS = r"""
$adir = Join-Path $env:LOCALAPPDATA 'claude-sidebar-sync'
$t = Get-ScheduledTask -TaskName '__TASK__' -ErrorAction SilentlyContinue
"task: " + $(if ($t) { $t.State } else { 'none (nothing waiting)' })
$s = Get-ChildItem -Path $adir -Directory -Filter 'stage-*' -ErrorAction SilentlyContinue | Sort-Object Name -Descending | Select-Object -First 1
if (-not $s) { 'stage: none'; return }
"stage: $($s.Name)"
$r = Join-Path $s.FullName 'result.json'
if (Test-Path $r) { 'result: ' + (Get-Content -Raw $r) } else { 'result: not applied yet' }
$l = Join-Path $s.FullName 'waiter.log'
if (Test-Path $l) { 'log:'; Get-Content $l -Tail 8 }
"""


def stage_on(dst, plan, stage, relaunch):
    adir = dst['agentDir']
    push(dst['host'], HERE / 'waiter.ps1', adir)
    push(dst['host'], HERE / 'agent.js', adir)
    push(dst['host'], stage, adir)
    remote_stage = adir + '\\' + stage.name
    script = (REGISTER.replace('__ADIR__', adir).replace('__STAGE__', remote_stage)
              .replace('__RELAUNCH__', '$true' if relaunch else '$false').replace('__TASK__', TASK))
    print('   ' + ps(dst['host'], script).strip().splitlines()[-1])


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('cmd', nargs='?', default='sync', choices=['sync', 'status', 'where'])
    ap.add_argument('--apply', action='store_true', help='stage the copy (default is a dry run)')
    ap.add_argument('--relaunch', metavar='HOST', help="reopen Claude after the copy on HOST ('here' = this laptop)")
    ap.add_argument('--hosts', nargs=2, default=['x1eg3', 't14s'], metavar=('A', 'B'))
    ap.add_argument('--stage-only', action='store_true', help='build the packages on hlab but send nothing (testing)')
    a = ap.parse_args()

    if a.cmd == 'where':
        h = where()
        print(h or 'unknown (SSH_CONNECTION does not match a known laptop)')
        return
    if a.cmd == 'status':
        for h in a.hosts:
            print(f'== {HOSTS[h]["label"]}')
            print(ps(h, STATUS.replace('__TASK__', TASK)).rstrip())
        return

    relaunch = a.relaunch
    if relaunch == 'here':
        relaunch = where()
        if not relaunch:
            die("--relaunch here: can't tell which laptop this session runs from")
    here = where()
    ex = {}
    for h in a.hosts:
        print(f'Reading the sidebar on {HOSTS[h]["label"]}...', flush=True)
        ex[h] = export(h)
    ts = time.strftime('%Y%m%d-%H%M%S')
    pairs = [(a.hosts[0], a.hosts[1]), (a.hosts[1], a.hosts[0])]
    plans = []
    print()
    for s, d in pairs:
        items, skipped = diff(ex[s], ex[d])
        L = HOSTS
        print(f'{L[s]["label"]} -> {L[d]["label"]}: {len(items)} to copy'
              + (' (you are on ' + L[d]['label'] + ')' if here == d else ''))
        recent = time.time() * 1000 - 6 * 3600 * 1000
        for _scope, rid, m in items:
            busy = '  [active in the last 6 hours]' if (m.get('lastActivityAt') or 0) > recent else ''
            arch = '  [archived]' if m.get('isArchived') else ''
            print(f'   + {m.get("title") or "(untitled)"}  ({fmt_ms(m.get("lastActivityAt") or m.get("createdAt"))}){arch}{busy}')
        for rid, title, why in skipped:
            print(f'   - skipped: {title}  ({why})')
        plans.append((s, d, items))
    print()
    if not (a.apply or a.stage_only):
        print('Dry run: nothing changed. Run with --apply to copy.')
        return
    for s, d, items in plans:
        if not items:
            continue
        stage = STATE / f'stage-{ts}-from-{s}'
        stage.mkdir(parents=True, exist_ok=True)
        print(f'Staging {len(items)} on {HOSTS[d]["label"]}...', flush=True)
        plan = build_stage(ex[s], ex[d], items, stage)
        if a.stage_only:
            print(f'   built {stage} (not sent)')
            continue
        stage_on(ex[d], plan, stage, relaunch == d)
    if all(not p[2] for p in plans):
        print('Both laptops already have every session. Nothing to do.')
        return
    if a.stage_only:
        return
    print('\nStaged. Each copy lands when Claude is fully quit on that laptop (tray icon -> Quit),'
          ' or at its next restart.' + (f' Claude reopens by itself on the {HOSTS[relaunch]["label"]}.' if relaunch else ''))


if __name__ == '__main__':
    main()
