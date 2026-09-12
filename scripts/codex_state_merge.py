#!/usr/bin/env python3
"""Import thread metadata rows for rollouts recovered from another machine.

Bead: gwth-launch-jfw9

Copying rollout JSONL files across is not enough. Codex keeps a `threads` row
per session in ~/.codex/state_5.sqlite (title, cwd, model, archived flag, git
context), and `codex migrate-rollouts` refuses to project a rollout whose row
is absent, with "missing its SQLite metadata". This brings those rows over.

Only rows whose rollout file already exists locally are imported, the
rollout_path is rewritten to where the file actually landed here, and an
existing local row is never overwritten. state_5.sqlite is backed up first.

    codex_state_merge.py <their-state_5.sqlite>            # report only
    codex_state_merge.py <their-state_5.sqlite> --apply    # do it
"""

from __future__ import annotations

import argparse
import re
import shutil
import sqlite3
import subprocess
import sys
from datetime import datetime
from pathlib import Path

CODEX = Path.home() / ".codex"
STATE = CODEX / "state_5.sqlite"
BACKUPS = CODEX / "history-merge-backups"
ROLLOUT = re.compile(r"^rollout-[\d\-T]+-(?P<thread>[0-9a-f-]{36})\.jsonl$")


def local_rollouts() -> dict[str, Path]:
    found: dict[str, Path] = {}
    for path in CODEX.rglob("rollout-*.jsonl"):
        m = ROLLOUT.match(path.name)
        if m:
            found[m.group("thread")] = path
    return found


def columns(conn: sqlite3.Connection) -> list[str]:
    return [r[1] for r in conn.execute("pragma table_info(threads)")]


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("source", type=Path, help="the other machine's state_5.sqlite")
    ap.add_argument("--apply", action="store_true", help="write (default: report only)")
    args = ap.parse_args()

    if not args.source.exists():
        raise SystemExit(f"Missing: {args.source}")
    if not STATE.exists():
        raise SystemExit(f"No local state database at {STATE}")

    on_disk = local_rollouts()
    src = sqlite3.connect(f"file:{args.source}?mode=ro", uri=True)
    src.row_factory = sqlite3.Row
    dst = sqlite3.connect(STATE)

    have = {r[0] for r in dst.execute("select id from threads")}
    src_cols, dst_cols = columns(src), columns(dst)
    shared = [c for c in src_cols if c in dst_cols]
    dropped = [c for c in src_cols if c not in dst_cols]
    missing_here = [c for c in dst_cols if c not in src_cols]

    print(f"Local threads rows        : {len(have)}")
    print(f"Rollout files on disk     : {len(on_disk)}")
    print(f"Columns shared            : {len(shared)}")
    if dropped:
        print(f"  columns only on source  : {', '.join(dropped)}")
    if missing_here:
        print(f"  columns only here       : {', '.join(missing_here)}")

    candidates = []
    no_file = 0
    for row in src.execute("select * from threads"):
        tid = row["id"]
        if tid in have:
            continue
        if tid not in on_disk:
            no_file += 1
            continue
        candidates.append(row)

    print(f"\nRows to import            : {len(candidates)}")
    print(f"Skipped, no rollout here  : {no_file}")

    if candidates:
        archived = sum(1 for r in candidates if ("archived" in r.keys() and r["archived"]))
        print(f"  of which archived       : {archived}")
        print("\nSample of what comes back:")
        for row in candidates[:6]:
            title = (row["title"] if "title" in row.keys() else "") or "(untitled)"
            cwd = (row["cwd"] if "cwd" in row.keys() else "") or ""
            print(f"  {row['id'][:8]}  {title[:58]}")
            if cwd:
                print(f"            {cwd}")

    if not args.apply:
        print("\nReport only. Re-run with --apply to import.")
        return 0
    if not candidates:
        print("\nNothing to import.")
        return 0

    BACKUPS.mkdir(parents=True, exist_ok=True)
    stamp = datetime.now().strftime("%Y%m%d-%H%M%S")
    backup = BACKUPS / f"state_5.sqlite.{stamp}"
    shutil.copy2(STATE, backup)
    print(f"\nBacked up {STATE.name} to {backup}")

    placeholders = ",".join("?" for _ in shared)
    collist = ",".join(f'"{c}"' for c in shared)
    inserted = 0
    for row in candidates:
        values = []
        for col in shared:
            if col == "rollout_path":
                values.append(str(on_disk[row["id"]]))
            else:
                values.append(row[col])
        dst.execute(
            f"insert or ignore into threads ({collist}) values ({placeholders})",
            values,
        )
        inserted += 1
    dst.commit()
    print(f"Inserted {inserted} threads rows (rollout_path rewritten to local paths)")
    print(f"Local threads rows now    : {dst.execute('select count(*) from threads').fetchone()[0]}")

    print("\nProjecting into paginated thread history...")
    proc = subprocess.run(["codex", "migrate-rollouts", "--apply"],
                          capture_output=True, text=True, timeout=3600)
    tail = (proc.stdout or "").strip().splitlines()[-3:]
    for line in tail:
        print("  " + line)
    if proc.returncode != 0:
        print("  " + (proc.stderr or "").strip()[-600:], file=sys.stderr)
        print("\nMigration reported a problem. The backup above restores the previous state:")
        print(f"  cp {backup} {STATE}")
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
