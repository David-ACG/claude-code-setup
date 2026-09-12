#!/usr/bin/env python3
"""Merge Codex rollout history exported from another machine into this one.

Bead: gwth-launch-jfw9

Codex keeps interactive history as rollout JSONL files under
~/.codex/sessions/YYYY/MM/DD/, and separately projects them into a paginated
thread history database that the picker and the desktop app actually read.
Copying files in is therefore only half the job: `codex migrate-rollouts
--apply` is what makes them visible.

This script is safe by default. It reports and changes nothing until --apply
is passed, it never overwrites an existing rollout, and it backs up the thread
history database before touching anything.

    codex_history_merge.py <zip-or-dir> [<zip-or-dir> ...]     # report only
    codex_history_merge.py <zip-or-dir> --apply                # do it
"""

from __future__ import annotations

import argparse
import json
import re
import shutil
import subprocess
import sys
import tempfile
import zipfile
from datetime import datetime
from pathlib import Path

CODEX = Path.home() / ".codex"
SESSIONS = CODEX / "sessions"
BACKUPS = CODEX / "history-merge-backups"

# rollout-2026-05-11T16-55-46-019e17f7-58d0-73b0-96d6-f19be9e5d6f1.jsonl
ROLLOUT = re.compile(
    r"^rollout-(?P<ts>\d{4}-\d{2}-\d{2})T(?P<clock>[\d-]+)-(?P<thread>[0-9a-f-]{36})\.jsonl$"
)


def existing_thread_ids() -> set[str]:
    ids = set()
    for path in CODEX.rglob("rollout-*.jsonl"):
        m = ROLLOUT.match(path.name)
        if m:
            ids.add(m.group("thread"))
    return ids


def describe(path: Path) -> tuple[str | None, str | None]:
    """Return (originator, cwd) from a rollout's first line, best effort."""
    try:
        with path.open(encoding="utf-8", errors="replace") as fh:
            head = json.loads(fh.readline())
    except Exception:
        return None, None
    payload = head.get("payload", head)
    return payload.get("originator"), payload.get("cwd")


def collect(source: Path, workdir: Path) -> Path:
    """Return a directory holding the source's contents, unzipping if needed."""
    if source.is_dir():
        return source
    if source.suffix.lower() == ".zip":
        out = workdir / source.stem
        out.mkdir(parents=True, exist_ok=True)
        with zipfile.ZipFile(source) as zf:
            zf.extractall(out)
        return out
    raise SystemExit(f"Not a directory or .zip: {source}")


def backup_state(stamp: str) -> Path:
    BACKUPS.mkdir(parents=True, exist_ok=True)
    dest = BACKUPS / stamp
    dest.mkdir(parents=True, exist_ok=True)
    for name in (
        "thread_history_1.sqlite",
        "thread_history_1.sqlite-wal",
        "thread_history_1.sqlite-shm",
        "session_index.jsonl",
    ):
        src = CODEX / name
        if src.exists():
            shutil.copy2(src, dest / name)
    return dest


def migrate(apply: bool) -> dict:
    cmd = ["codex", "migrate-rollouts", "--json"]
    if apply:
        cmd.append("--apply")
    proc = subprocess.run(cmd, capture_output=True, text=True, timeout=1800)
    if proc.returncode != 0:
        print(proc.stderr[-2000:], file=sys.stderr)
        raise SystemExit(f"codex migrate-rollouts failed (rc={proc.returncode})")
    try:
        return json.loads(proc.stdout)
    except json.JSONDecodeError:
        return {"raw": proc.stdout[-2000:]}


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("sources", nargs="+", type=Path,
                    help="exported .zip files or unpacked directories")
    ap.add_argument("--apply", action="store_true",
                    help="actually copy and migrate (default: report only)")
    args = ap.parse_args()

    if not SESSIONS.is_dir():
        raise SystemExit(f"No Codex sessions directory at {SESSIONS}")

    known = existing_thread_ids()
    print(f"This machine already holds {len(known)} rollout threads.\n")

    stamp = datetime.now().strftime("%Y%m%d-%H%M%S")
    incoming: dict[str, Path] = {}
    skipped = 0
    unparsed = 0

    with tempfile.TemporaryDirectory(prefix="codex-merge-") as tmp:
        workdir = Path(tmp)
        for source in args.sources:
            if not source.exists():
                raise SystemExit(f"Missing: {source}")
            root = collect(source, workdir)
            found = 0
            for path in root.rglob("rollout-*.jsonl"):
                m = ROLLOUT.match(path.name)
                if not m:
                    unparsed += 1
                    continue
                found += 1
                thread = m.group("thread")
                if thread in known or thread in incoming:
                    skipped += 1
                    continue
                incoming[thread] = path
            print(f"  {source.name}: {found} rollouts")

        print(f"\nAlready present, skipped : {skipped}")
        print(f"Unrecognised filenames   : {unparsed}")
        print(f"New threads to import    : {len(incoming)}")

        if incoming:
            origins: dict[str, int] = {}
            for path in incoming.values():
                origin, _ = describe(path)
                origins[origin or "unknown"] = origins.get(origin or "unknown", 0) + 1
            print("\nNew threads by originator:")
            for origin, count in sorted(origins.items(), key=lambda kv: -kv[1]):
                print(f"  {count:5d}  {origin}")

            dates = sorted(ROLLOUT.match(p.name).group("ts") for p in incoming.values())
            print(f"\nDate range: {dates[0]} to {dates[-1]}")

        if not args.apply:
            print("\nReport only. Re-run with --apply to import.")
            return 0

        if not incoming:
            print("\nNothing new to import.")
            return 0

        backup = backup_state(stamp)
        print(f"\nBacked up thread history to {backup}")

        copied = 0
        for thread, path in incoming.items():
            day = ROLLOUT.match(path.name).group("ts")
            year, month, dayn = day.split("-")
            dest_dir = SESSIONS / year / month / dayn
            dest_dir.mkdir(parents=True, exist_ok=True)
            dest = dest_dir / path.name
            if dest.exists():          # belt and braces: never overwrite
                continue
            shutil.copy2(path, dest)
            copied += 1
        print(f"Copied {copied} rollout files into {SESSIONS}")

    print("\nProjecting into paginated thread history...")
    report = migrate(apply=True)
    # The report key has been "outcomes" since codex-cli 0.15x; older builds
    # used "threads". Accept either rather than silently printing nothing.
    entries = report.get("outcomes") or report.get("threads") or []
    if entries:
        states: dict[str, int] = {}
        for t in entries:
            states[t.get("status", "?")] = states.get(t.get("status", "?"), 0) + 1
        for state, count in sorted(states.items(), key=lambda kv: -kv[1]):
            print(f"  {count:5d}  {state}")
    else:
        print("  (migrate-rollouts reported nothing to project)")

    print(f"\nNow holding {len(existing_thread_ids())} rollout threads.")
    print("Check with: codex resume")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
