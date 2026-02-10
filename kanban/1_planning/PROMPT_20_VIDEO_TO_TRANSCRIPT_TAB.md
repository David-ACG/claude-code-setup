# Prompt: Rebuild Video to Transcript Tab (Tab 2) — Simplified & Reliable

## Root Cause of Current Failure

**The channels show 0 because the data is in the wrong place.**

The Docker container mounts `/home/david/gwth-pipeline:/data`. Inside the container, the code looks at `/data/GWTH-YT-Vids/` (= `/home/david/gwth-pipeline/GWTH-YT-Vids/` on host). This directory is **empty** (0 files).

The actual transcript files (3,379 files) are in `/home/david/gwth-dashboard/GWTH-YT-Vids/`. The channel config file is in `/home/david/gwth-dashboard/data/channel-config.json` — also not visible to the container.

**This is a volume mount mismatch — the data was migrated to `gwth-dashboard/` but the Docker volume still points to `gwth-pipeline/`.** This is why it "works sometimes and breaks other times" — any time the container restarts or the data paths change, the mount becomes stale.

### Immediate Fix (before any tab rebuild)

**Option A: Fix the volume mount** in `docker-compose.yml`:
```yaml
volumes:
  - /home/david/gwth-dashboard:/data
```
This maps the container's `/data` to where the files actually live. After changing, run `docker compose up -d` to restart.

**Option B: Symlink on the host:**
```bash
ln -sf /home/david/gwth-dashboard/GWTH-YT-Vids /home/david/gwth-pipeline/GWTH-YT-Vids
cp /home/david/gwth-dashboard/data/channel-config.json /home/david/gwth-pipeline/channel-config.json
```
Less clean but works without container restart.

**Recommended: Option A.** It fixes the root cause. All the Python code is fine — it's just looking at an empty directory.

---

## Analysis: P53 Batch Files vs P520 Python Scripts

### Option 1: Go back to P53 batch files

| Pro | Con |
|-----|-----|
| Already working, never stopped | Requires P53 to be running |
| Simple batch files, easy to understand | No dashboard integration |
| Uses local Chrome cookies directly | Files need manual transfer to P520 |
| yt-dlp + ffmpeg, proven pipeline | No Whisper transcription (or separate step) |
| No Docker complexity | Can't trigger from dashboard |

### Option 2: Fix P520 Python scripts (again)

| Pro | Con |
|-----|-----|
| Integrated with dashboard | Has been unreliable — volume mount issues, cookie sync issues |
| Whisper transcription automatic | Complex architecture (Docker + services + JSON state) |
| Qdrant indexing automatic | Debugging requires SSH + Docker exec |
| All in one place | Cookie sync from P53 adds failure point |

### Option 3 (Recommended): Hybrid — P53 downloads, P520 processes

| Pro | Con |
|-----|-----|
| P53 does what it's good at (downloading with fresh cookies) | Needs a simple sync mechanism |
| P520 does what it's good at (Whisper + Qdrant indexing) | Two machines involved |
| No cookie sync headaches | — |
| Dashboard shows status of what P53 has downloaded | — |
| Batch files keep working as they always have | — |
| Whisper transcription runs on GPU automatically | — |

**How it works:**
1. P53 batch files download videos → convert to MP3 → save to `C:\yt-dlp\GWTH-YT-Vids\`
2. A scheduled `robocopy` or `rsync` syncs new files from P53 to P520 (one-way, incremental)
3. P520 dashboard watches for new MP3 files without transcripts
4. Dashboard auto-transcribes new MP3s using Whisper
5. Dashboard auto-indexes new transcripts into Qdrant
6. Tab 2 shows channel stats, recent downloads, and transcription progress

**This eliminates:**
- Cookie sync issues (P53 has the browser)
- yt-dlp reliability issues on P520 (no yt-dlp needed on P520)
- Docker volume mount complexity for downloads
- The need for yt-dlp or ffmpeg in the Docker container

### Option 4: Start Tab 2 from scratch on P520

| Pro | Con |
|-----|-----|
| Clean code, no legacy bugs | Same Docker/cookie problems will recur |
| Can redesign properly | Still needs cookie sync |
| — | yt-dlp in Docker is fragile |

### Recommendation

**Option 3 (Hybrid)** is the most robust. The persistent bugs stem from trying to make P520's Docker container do something P53 already does reliably. Stop fighting it — let each machine do what it does best.

If you want to keep it simpler and don't want two machines involved, **Option 1 + manual rsync** is the fallback. But Option 3 automates the rsync and adds Whisper.

---

## What to Build (Assuming Option 3: Hybrid)

### Architecture

```
P53 (Windows)                           P520 (Linux/Docker)
┌─────────────────────┐                ┌──────────────────────────┐
│ Existing batch files │                │ Dashboard Tab 2          │
│ yt-dlp + ffmpeg      │    rsync      │                          │
│ Download → MP3       │ ──────────►   │ Watch for new MP3s       │
│ Fresh browser cookies│   (scheduled) │ Whisper transcribe       │
│                      │               │ Index to Qdrant          │
│ C:\yt-dlp\           │               │ Show channel stats       │
│   GWTH-YT-Vids\     │               │ /data/GWTH-YT-Vids/     │
└─────────────────────┘                └──────────────────────────┘
```

### Part 0: Fix the Volume Mount (Prerequisite)

Before any code changes, fix the Docker volume so the container can see the transcript files:

```yaml
# docker-compose.yml on P520
volumes:
  - /home/david/gwth-dashboard:/data
```

Or if you prefer to keep the `gwth-pipeline` path, symlink the data:
```bash
rm -rf /home/david/gwth-pipeline/GWTH-YT-Vids
ln -s /home/david/gwth-dashboard/GWTH-YT-Vids /home/david/gwth-pipeline/GWTH-YT-Vids
```

### Part 1: P53 → P520 File Sync

**On P53, create a sync script:** `C:\yt-dlp\sync_to_p520.bat`

```batch
@echo off
REM Sync GWTH-YT-Vids from P53 to P520 (one-way, incremental)
REM Only syncs .mp3 and .txt/.md files (not raw .mp4 videos — too large)
echo Syncing transcripts and audio to P520...
rsync -avz --include="*/" --include="*.mp3" --include="*.txt" --include="*.md" --exclude="*" ^
  /cygpath/c/yt-dlp/GWTH-YT-Vids/ p520:/home/david/gwth-dashboard/GWTH-YT-Vids/
echo Sync complete at %DATE% %TIME%
```

Or using `scp` if rsync isn't available on P53:
```batch
scp -r C:\yt-dlp\GWTH-YT-Vids\*.mp3 p520:/home/david/gwth-dashboard/GWTH-YT-Vids/
scp -r C:\yt-dlp\GWTH-YT-Vids\*.txt p520:/home/david/gwth-dashboard/GWTH-YT-Vids/
```

Schedule this in Windows Task Scheduler to run hourly or daily.

### Part 2: New API Endpoints

#### `GET /api/channels`
Returns all discovered channels with stats. Replaces the inline discovery logic.

```json
{
  "channels": [
    {
      "name": "9x",
      "folder": "Go9x",
      "handle": "@Go9x",
      "videos": 42,
      "mp3s": 42,
      "transcripts": 38,
      "progress_pct": 90,
      "untranscribed": 4,
      "last_download": "2026-01-28T14:00:00Z"
    }
  ],
  "total_channels": 31,
  "total_videos": 1200,
  "total_transcripts": 3379,
  "sync_status": {
    "last_sync": "2026-01-30T06:00:00Z",
    "files_synced_last": 12
  }
}
```

This endpoint should cache results for 60 seconds (filesystem scan of 3,379 files is slow).

#### `GET /api/channels/{name}/files`
Returns files for a specific channel, grouped by type.

#### `POST /api/channels/{name}/transcribe`
Triggers Whisper transcription for all untranscribed MP3s in a channel. Returns immediately, runs in background.

#### `POST /api/transcribe/all-pending`
Finds all MP3 files without corresponding transcripts across all channels and queues them for Whisper transcription.

#### `GET /api/transcribe/status`
Returns current transcription queue status (processing, queued, completed, errors).

#### `GET /api/sync/status`
Returns P53 → P520 sync status (last sync time, files count, any errors).

### Part 3: Tab 2 UI Rebuild

Replace the entire tab content (lines 2512-3288) with a simpler, more reliable UI.

#### Header Row
- Title: "Video to Transcript"
- Sync status: "Last P53 sync: 2h ago" with green/yellow/red indicator
- "Transcribe All Pending" button — runs Whisper on all untranscribed MP3s

#### Stats Cards (dynamic, from `/api/channels` response)
- **Channels:** count
- **Videos/MP3s:** total count
- **Transcripts:** total count
- **Untranscribed:** count of MP3s without matching transcripts (the actionable number)

#### Channels Table

Simple table with one row per channel:

| Channel | Videos | MP3 | Transcripts | Progress | Actions |
|---------|--------|-----|-------------|----------|---------|
| 9x | 42 | 42 | 38 | 90% ████░ | [Transcribe 4] |
| Matthew Berman | 85 | 85 | 85 | 100% █████ | ✅ Complete |

- **Progress bar** — visual indicator of transcription completeness
- **"Transcribe N" button** — only shows when there are untranscribed MP3s, triggers Whisper for that channel
- **No "Check New" button** — P53 handles downloading. The tab just shows what's been synced.
- **No "Edit Channel" or "Add Channel"** — channels are discovered from the filesystem. The channel-config.json provides display name mappings but channels appear automatically when files are synced.

#### Whisper Transcription Section

- **Model:** large-v3 (display only)
- **Device:** CUDA (RTX 3060) — from GPU status bar
- **Status:** Idle / Transcribing / Error
- **Current:** "Transcribing: [filename] (3 of 12)"
- **Progress bar** for current batch
- **"Transcribe Stuck Files" button** — retries any files that failed previously

#### P53 Sync Section

- **Last sync:** timestamp
- **Files synced:** count from last sync
- **Schedule:** "Hourly" or "Daily at 6:00 AM" (configurable)
- **"Sync Now" button** — triggers manual rsync from P53 (if P53 is accessible)

**Note:** If the user prefers to keep using the P53 batch files without automatic sync, this section can simply show the age of the newest file in `GWTH-YT-Vids/` as a proxy for "last sync."

#### Recent Activity (bottom)

A simple log showing:
- Recently synced files (newest first)
- Recently transcribed files
- Any errors

**No Download Queue section** — downloading happens on P53, not P520.

**No Cookie Sync section** — cookies stay on P53 where the browser is. Not needed on P520 if P520 doesn't run yt-dlp.

---

## Fallback: If User Wants to Keep P520 Downloads

If the hybrid approach is rejected and downloads must happen on P520, the tab rebuild should still follow the simplified design above, but add back:

1. **Download Queue** — URL input + Download button (existing pattern)
2. **Cookie Sync** — P53 → P520 cookie transfer (existing pattern)

But the **first priority** is still fixing the volume mount. Without that, nothing works.

---

## Important Implementation Notes

### JavaScript Escaping
Use `\\n` not `\n`, `\\x27` not `\'` in JS strings inside Python triple-quoted templates.

### NiceGUI 3.x Patterns
- Use `asyncio.to_thread()` for filesystem scans and Whisper transcription
- Cache channel stats (filesystem scan of 3,379 files should not run on every page load)
- Tab panels are lazy-rendered

### Channel Discovery — Simplify
The current `discover_channels_from_files()` function (lines 2657-2730) plus all the slug mappings, normalizations, and mojibake handling (lines 2543-2600) is over 180 lines of fragile code. Much of this complexity exists because filenames have inconsistent formats.

**Simplify by requiring a folder-per-channel structure:**
```
GWTH-YT-Vids/
├── 9x/
│   ├── video1.mp3
│   ├── video1.txt
│   └── ...
├── matthew-berman/
├── openai/
└── ...
```

If files are already organised this way (they mostly are — there are 17 subdirectories), the discovery becomes:
1. List directories in `GWTH-YT-Vids/`
2. For each directory, count `.mp3`, `.mp4`, `.txt`, `.md` files
3. Look up display name from `channel-config.json`

This eliminates all the filename parsing, slug mapping, mojibake handling, and regex patterns.

For root-level files (not in a subdirectory), either move them into channel folders during a one-time migration, or put them in an "Uncategorised" bucket.

### Caching
Channel stats should be cached for 60 seconds. The filesystem scan iterates 3,379+ files and shouldn't run on every API call. Use a simple timestamp-based cache:

```python
_channel_stats_cache = None
_channel_stats_cache_time = 0

async def get_channel_stats():
    global _channel_stats_cache, _channel_stats_cache_time
    if time.time() - _channel_stats_cache_time < 60:
        return _channel_stats_cache
    stats = await asyncio.to_thread(_scan_channels)
    _channel_stats_cache = stats
    _channel_stats_cache_time = time.time()
    return stats
```

### Whisper Integration
The existing `WhisperService` (in `app/services/whisper_service.py`) works fine. The key methods:
- `is_available()` — checks if faster-whisper is installed
- `transcribe(audio_path, output_md_path)` — transcribes a single file

For batch transcription, create a queue that processes files one at a time via `asyncio.to_thread()`.

---

## Files to Modify

| File | Action | Purpose |
|------|--------|---------|
| P520: `docker-compose.yml` | MODIFY | Fix volume mount to point to actual data |
| `app/gwth_dashboard.py` lines 2512-3288 | REPLACE | Rebuild Tab 2 (much simpler) |
| `app/gwth_dashboard.py` (new endpoint section) | ADD | `/api/channels/*` and `/api/transcribe/*` endpoints |
| P53: `C:\yt-dlp\sync_to_p520.bat` | CREATE | File sync script (if hybrid approach) |

---

## Acceptance Criteria

1. **Channels appear with correct counts** — All 31+ channels show with accurate video/MP3/transcript counts derived from actual filesystem contents.

2. **Volume mount is correct** — Container can see the 3,379 transcript files.

3. **Transcription works** — Clicking "Transcribe" on a channel with untranscribed MP3s triggers Whisper and produces `.md` transcripts.

4. **Stats are cached** — Page loads don't trigger a full filesystem scan every time.

5. **Tab is simple** — No 800-line inline discovery functions. No mojibake handling. No filename regex parsing. Folder-per-channel structure with config-based display names.

6. **No UI freeze** — Transcription and filesystem scans run via `asyncio.to_thread()`.

---

## Testing Approach

1. Fix volume mount and verify: `docker exec ... ls /data/GWTH-YT-Vids/ | wc -l` should show files
2. Verify channel-config.json is accessible from container
3. Test `/api/channels` endpoint — should return all channels with stats
4. Test Whisper transcription on a single MP3
5. Test batch transcription for a channel with untranscribed files
6. Verify the tab loads and shows data
