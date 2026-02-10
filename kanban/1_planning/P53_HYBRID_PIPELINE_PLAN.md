# P53 Hybrid Pipeline + Folder Cleanup Plan

## Status Tracker

| # | Step | Status |
|---|------|--------|
| 1 | Look up YouTube handles for Dylan Davis, academind, AI Advantage | DONE |
| 2 | Update daily-download.bat — add missing channels + fix process_new_videos.py bug | DONE |
| 3 | Update channel-config.json — add mappings for new channels | DONE |
| 4 | Fix _SLUG_TO_DISPLAY in gwth_dashboard.py — proper display names | DONE |
| 5 | Create backfill-download.bat — 6-month dateafter, all channels | DONE |
| 6 | Tidy C:\yt-dlp — archive obsolete files, move scripts to scripts/ | DONE |
| 7 | Update 3 scheduled tasks — point to new scripts/ paths | TODO |
| 8 | Move download_log_*.txt to logs/ | DONE |
| 9 | rsync P53 → P520 — sync all transcripts and MP3s | TODO |
| 10 | Add P53 pipeline docs to LESSON_PIPELINE_ARCHITECTURE.md | TODO |
| 11 | Deploy dashboard to P520 (for _SLUG_TO_DISPLAY fix) | TODO |
| 12 | Verify via Playwright MCP — check Tab 2 channel count, no duplicates | TODO |

---

## Overview

Three workstreams: (A) Document P53 pipeline in architecture doc, (B) Sync channels + fill gaps, (C) Tidy C:\yt-dlp folder.

---

## A. Document P53 Pipeline in Architecture Doc

File: `kanban/1_planning/LESSON_PIPELINE_ARCHITECTURE.md`

Add new section "P53 Pipeline — Scripts, Schedules, and File Locations" covering:

### Current Scheduled Tasks (confirmed from Task Scheduler)

| Task | Script | Schedule | Status |
|------|--------|----------|--------|
| YouTube Daily Download | C:\yt-dlp\scripts\daily-download.bat | Daily 9:00 AM | Running (confirmed) |
| Daily Video Processor | C:\yt-dlp\scripts\run_daily_processor.bat | Daily 12:00 PM | Ready (confirmed) |
| GWTH Cookie Sync | C:\yt-dlp\scripts\sync_cookies_to_p520.bat | Daily 6:00 AM | Ready (confirmed) |

### Pipeline Flow on P53

```
9:00 AM  daily-download.bat
  → extracts cookies from Edge
  → yt-dlp downloads last 7 days from 33 channels
  → saves MP4s to C:\yt-dlp\NEW_VIDEOS\
  → calls daily_video_processor.py

12:00 PM run_daily_processor.bat
  → runs daily_video_processor.py --execute
  → Step 1: Find MP4s in NEW_VIDEOS
  → Step 2: ffmpeg MP4→MP3
  → Step 3: Whisper transcribe (small model, GPU)
  → Step 4: Organize to channel folders in GWTH-YT-Vids
  → Step 5: Archive MP4/MP3 to E:\yt-dlp\NEW_VIDEOS
  → Step 6: Index to Qdrant
  → Step 7: Verify indexing

6:00 AM  sync_cookies_to_p520.bat
  → SCP youtube_cookies.txt to P520
```

### File Locations on P53

| Path | Purpose |
|------|---------|
| C:\yt-dlp\NEW_VIDEOS\ | Queue for newly downloaded MP4s |
| C:\yt-dlp\GWTH-YT-Vids\ | Organized transcripts by channel folder (33 folders) |
| C:\yt-dlp\downloaded.txt | yt-dlp archive (prevents re-downloads) |
| C:\yt-dlp\youtube_cookies.txt | Fresh cookies from Edge |
| C:\yt-dlp\scripts\channel-config.json | Channel name → folder mapping |
| C:\yt-dlp\logs\ | Processing and download logs |
| E:\yt-dlp\NEW_VIDEOS\ | Archive of processed MP4/MP3 files |

### What's Missing: P53 → P520 Transcript Sync

No automatic sync of .md/.txt transcripts from P53 to P520. This is the key gap in the hybrid architecture. Need to add a sync step (rsync/SCP) after processing completes.

---

## B. Sync Channels + Fill Gaps

### B1. Update daily-download.bat — DONE
All 33 channels now in bat file including Dylan Davis (@dylandavisAI), academind (@academind), AI Advantage (@aiadvantage).

### B2. Fix channel name duplicates on dashboard — DONE
_SLUG_TO_DISPLAY updated with proper display names for all slug variations.

### B3. Compare P53 vs P520 files and fill gaps — TODO
P53 channel folders: 30+
P520 channel folders: 14
Action: rsync all .md, .txt, .mp3 files from P53 GWTH-YT-Vids to P520.

### B4. Download missing videos (6 months minimum) — DONE
backfill-download.bat created in scripts/ with --dateafter 20250801. User runs manually.

---

## C. Tidy C:\yt-dlp Folder — DONE

Root reduced from 361 items to 44 (11 files + 33 directories).

Archive totals:
| Directory | Files |
|---|---|
| archive/old_scripts/ | 149 |
| archive/old_dashboards/ | 47 |
| archive/old_docs/ | 35 |
| archive/old_batch_files/ | 25 |
| archive/old_tests/ | 21 |
| archive/old_screenshots/ | 16 |

Active scripts moved to C:\yt-dlp\scripts\.
Download logs moved to C:\yt-dlp\logs\.

---

## Remaining Steps (7, 9, 10, 11, 12)

### Step 7: Update Scheduled Tasks
Update Windows Task Scheduler to point to new scripts/ paths:
- YouTube Daily Download → C:\yt-dlp\scripts\daily-download.bat
- Daily Video Processor → C:\yt-dlp\scripts\run_daily_processor.bat
- GWTH Cookie Sync → C:\yt-dlp\scripts\sync_cookies_to_p520.bat

### Step 9: rsync P53 → P520
```bash
rsync -avz --include="*/" --include="*.md" --include="*.txt" --include="*.mp3" --exclude="*" \
  /cygdrive/c/yt-dlp/GWTH-YT-Vids/ p520:/home/david/gwth-dashboard/GWTH-YT-Vids/
```

### Step 10: Architecture Doc
Add P53 pipeline section to LESSON_PIPELINE_ARCHITECTURE.md.

### Step 11: Deploy Dashboard
Copy updated gwth_dashboard.py to P520 and restart service.

### Step 12: Verify
- Dashboard Tab 2 shows ~33 unique channels (no duplicates)
- All scheduled tasks point to scripts/ paths
- P520 has all transcripts from P53

---

## Verification Checklist

- [ ] Dashboard Tab 2 shows ~33-35 unique channels (no duplicates)
- [ ] daily-download.bat has all channels with correct YouTube handles
- [ ] C:\yt-dlp\ root has <15 files/folders (clean)
- [ ] C:\yt-dlp\scripts\ has all active scripts
- [ ] P520 has all transcripts from P53
- [ ] All 3 scheduled tasks point to scripts/ paths
- [ ] backfill-download.bat exists and is ready for manual run
