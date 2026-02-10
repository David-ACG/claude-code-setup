# Prompt: Rebuild Export to GWTH Tab (Tab 10) — Simplified

## Objective

Rebuild the Export to GWTH tab (Tab 10) from an overcomplicated static mockup into a **simple, functional** export dashboard with two clear sections:

1. **Export Lesson Package** (Priority — must work) — Exports a lesson's complete asset bundle to the live GWTH.ai site and creates a local ZIP backup on P520
2. **Student Chatbot Vector DB** (Future — dummy placeholder) — Will index lesson content for a student chatbot. Keep the UI section but make it non-functional with a "Coming Soon" label

The current mockup is far too complicated. Simplify it. The export tab is the **final step** in the pipeline — it collects everything produced by earlier tabs and packages it.

---

## Context: What Gets Exported

A complete lesson package consists of files produced across the entire pipeline:

| Asset | Source Tab/Skill | Path Pattern | Required? |
|-------|-----------------|--------------|-----------|
| Lesson markdown | Tab 6 / `/write-lesson` | `generated_lessons/month{N}/lesson_{NN}_{slug}.md` | Yes |
| Project markdown | Tab 6 / `/write-project` | `generated_lessons/month{N}/lesson_{NN}_project.md` | Yes |
| Q&A markdown | Tab 6 / `/write-qna` | `generated_lessons/month{N}/lesson_{NN}_qna.md` | Yes |
| Intro script | Tab 6 / `/write-intro` | `generated_lessons/month{N}/lesson_{NN}_intro.md` | Yes |
| Intro audio (WAV) | Tab 7 (F5-TTS) | `tts_sessions/f5_intro_lesson_{NN}.wav` | Yes |
| Intro video (MP4) | Tab 9 (Remotion) | Output from Remotion render | Optional |
| Slides JSON | Tab 6 / `/write-slides` | `generated_lessons/month{N}/lesson_{NN}_slides.json` | Optional |
| Storyboard | Tab 6 / `/write-slides` | `generated_lessons/month{N}/lesson_{NN}_storyboard.md` | Optional |
| Main lesson audio (WAV) | Tab 8 (Kokoro) | `tts_sessions/kokoro_lesson_{NN}_final.wav` | Optional |
| Word timestamps | Tab 8 (Kokoro) | `tts_sessions/kokoro_lesson_{NN}_timestamps.json` | Optional |

### Integration with Other Tabs

| Tab | Direction | Integration |
|-----|-----------|-------------|
| **Tab 5: Syllabus Manager** | ← Input | Lesson metadata (title, month, number, status). Export should update lesson status to "exported". |
| **Tab 6: Lesson Writer** | ← Input | All generated content files (lesson, project, Q&A, intro script, slides JSON). |
| **Tab 7: TTS Intro Video** | ← Input | F5-TTS intro audio WAV. |
| **Tab 8: TTS Main Text** | ← Input | Kokoro main audio WAV + word timestamps JSON. |
| **Tab 9: Remotion Studio** | ← Input | Rendered intro video MP4 (if available). |

---

## Current State

The Export to GWTH tab (lines 5223-5381 in `gwth_dashboard.py`) is an overcomplicated static mockup with:
- Lesson selector with hardcoded options and a fake "Status: Incomplete" block
- Export Package card with checkboxes and a fake asset checklist (green/red icons)
- Student Chatbot Vector DB card with chunking strategy options, index options, target database radio buttons
- Export History with hardcoded entries
- Batch Export and Sync to Vector DB buttons — none functional

**Problems with current design:**
- Too many options and checkboxes for what is essentially "package and export"
- The asset checklist is hardcoded, not derived from actual file existence
- The Vector DB section is premature and adds clutter
- Export History is fake

---

## What to Build

### Part 1: New API Endpoints

#### `GET /api/export/lesson/{lesson_id}/status`
Checks which assets exist for a lesson. Scans the filesystem for all expected files.

```json
{
  "lesson_number": 3,
  "month": 1,
  "title": "Intro to Large Language Models",
  "assets": {
    "lesson_md": {"exists": true, "path": "...", "size_mb": 0.05, "modified": "2026-01-30T..."},
    "project_md": {"exists": true, "path": "...", "size_mb": 0.03, "modified": "..."},
    "qna_md": {"exists": true, "path": "...", "size_mb": 0.02, "modified": "..."},
    "intro_script": {"exists": true, "path": "...", "size_mb": 0.01, "modified": "..."},
    "intro_audio": {"exists": false, "path": null},
    "intro_video": {"exists": false, "path": null},
    "slides_json": {"exists": true, "path": "...", "size_mb": 0.01, "modified": "..."},
    "main_audio": {"exists": false, "path": null},
    "word_timestamps": {"exists": false, "path": null}
  },
  "ready_to_export": false,
  "missing_required": ["intro_audio"],
  "missing_optional": ["intro_video", "main_audio", "word_timestamps"],
  "total_size_mb": 0.12
}
```

#### `POST /api/export/lesson/{lesson_id}`
Packages and exports a lesson. Creates:
1. A structured export directory: `/home/david/gwth-exports/month_{N}/lesson_{NN}/`
2. Copies all existing assets into the export directory
3. Creates a `manifest.json` with metadata (lesson info, included assets, export date)
4. Creates a ZIP backup: `/home/david/gwth-exports/backups/lesson_{NN}_export_{date}.zip`
5. Optionally updates lesson status to "exported" in syllabus

```json
Request: {
  "include_optional": true,
  "create_backup": true
}
Response: {
  "status": "success",
  "export_path": "/home/david/gwth-exports/month_01/lesson_03/",
  "backup_path": "/home/david/gwth-exports/backups/lesson_03_export_20260130.zip",
  "assets_exported": 6,
  "total_size_mb": 142.5
}
```

This endpoint should use `asyncio.to_thread()` for the file copy/ZIP operations.

#### `GET /api/export/history`
Lists previous exports.

```json
{
  "exports": [
    {
      "lesson_number": 3,
      "month": 1,
      "title": "Intro to Large Language Models",
      "export_date": "2026-01-30T14:22:00Z",
      "export_path": "/home/david/gwth-exports/month_01/lesson_03/",
      "backup_path": "/home/david/gwth-exports/backups/lesson_03_export_20260130.zip",
      "assets_count": 6,
      "total_size_mb": 142.5
    }
  ]
}
```

#### `POST /api/export/batch`
Exports multiple lessons at once. Accepts a list of lesson IDs. Runs sequentially to avoid overwhelming the filesystem.

---

### Part 2: Tab 10 UI Rebuild

Replace lines 5223-5381 with a clean, simple tab.

#### Header Row
- Title: "Export to GWTH"
- "Batch Export" button (opens a dialog to select multiple lessons)

#### Select Lesson & Asset Status (top section)

**Lesson selector:** Dropdown populated from the syllabus API. Shows: "Month {N}, Lesson {NN}: {title}"

**Asset checklist:** When a lesson is selected, calls `GET /api/export/lesson/{id}/status` and displays a simple checklist:

| Asset | Status |
|-------|--------|
| Lesson content (.md) | ✅ Ready |
| Project (.md) | ✅ Ready |
| Q&A (.md) | ✅ Ready |
| Intro script (.md) | ✅ Ready |
| Intro audio (.wav) | ❌ Missing — generate in Tab 7 |
| Intro video (.mp4) | ⚪ Optional — not generated |
| Slides JSON | ✅ Ready |
| Main audio (.wav) | ⚪ Optional — not generated |
| Word timestamps (.json) | ⚪ Optional — not generated |

Use three states:
- ✅ Green check: file exists (required or optional)
- ❌ Red cross: **required** file missing — cannot export
- ⚪ Grey circle: **optional** file missing — can export without it

Show a clear summary line: "Ready to export" (green) or "Missing {N} required assets" (yellow/red).

**"Export Lesson Package" button:**
- Disabled if required assets are missing
- On click: calls `POST /api/export/lesson/{id}`
- Shows progress during export
- On success: shows export path and backup path

#### Export History (below)

**Table of previous exports**, populated from `GET /api/export/history`:
- Lesson (month + number + title)
- Date exported
- Assets count
- Total size
- "Open Folder" button (if accessible)
- "Re-export" button

#### Student Chatbot Vector DB (bottom section — placeholder)

A single card with:
- Title: "Student Chatbot Vector DB"
- Grey "Coming Soon" badge
- Brief description: "Index lesson content for student Q&A chatbot. This feature will be implemented in a future update."
- No functional controls — just the placeholder text

---

## Important Implementation Notes

### JavaScript Escaping
Use `\\n` not `\n`, `\\x27` not `\'` in JS strings inside Python triple-quoted templates.

### NiceGUI 3.x Patterns
- Use `asyncio.to_thread()` for file copy/ZIP operations
- Tab panels are lazy-rendered

### Export Directory Structure

```
/home/david/gwth-exports/
├── month_01/
│   ├── lesson_01/
│   │   ├── manifest.json
│   │   ├── lesson_01_welcome_to_gwth.md
│   │   ├── lesson_01_project.md
│   │   ├── lesson_01_qna.md
│   │   ├── lesson_01_intro.md
│   │   ├── lesson_01_intro.wav
│   │   ├── lesson_01_intro.mp4  (if exists)
│   │   ├── lesson_01_slides.json
│   │   ├── lesson_01_main_audio.wav  (if exists)
│   │   └── lesson_01_timestamps.json  (if exists)
│   ├── lesson_02/
│   │   └── ...
├── month_02/
├── month_03/
└── backups/
    ├── lesson_01_export_20260130.zip
    └── ...
```

### Manifest JSON

Each export includes a `manifest.json`:

```json
{
  "lesson_number": 3,
  "month": 1,
  "title": "Intro to Large Language Models",
  "export_date": "2026-01-30T14:22:00Z",
  "pipeline_version": "1.0",
  "assets": [
    {"type": "lesson_md", "filename": "lesson_03_intro_to_llms.md", "size_bytes": 52400},
    {"type": "intro_audio", "filename": "lesson_03_intro.wav", "size_bytes": 8600000}
  ],
  "missing_optional": ["intro_video", "main_audio", "word_timestamps"]
}
```

### Required vs Optional Assets
- **Required:** lesson_md, project_md, qna_md, intro_script, intro_audio
- **Optional:** intro_video, slides_json, storyboard, main_audio, word_timestamps

The export should proceed if all required assets exist, even if optional ones are missing. The manifest records what was and wasn't included.

---

## Files to Modify

| File | Action | Purpose |
|------|--------|---------|
| `app/gwth_dashboard.py` lines 5223-5381 | REPLACE | Rebuild Export to GWTH tab |
| `app/gwth_dashboard.py` (new endpoint section) | ADD | `/api/export/*` endpoints |

---

## Acceptance Criteria

1. **Asset status is real** — Selecting a lesson shows which files actually exist on the filesystem with green/red/grey indicators.

2. **Export works** — Clicking "Export Lesson Package" copies all assets to the export directory and creates a ZIP backup. Progress is shown. UI does not freeze.

3. **Required/optional distinction is clear** — User can see at a glance what's missing and whether it blocks export.

4. **Export history is real** — Previously exported lessons are listed from actual export directory contents.

5. **Batch export works** — Multiple lessons can be exported at once.

6. **Student Chatbot section is a clean placeholder** — "Coming Soon" label, no functional controls, no clutter.

7. **Cross-tab integration** — Asset paths match the naming conventions used by Tabs 6-9. Lesson status can be updated to "exported" in the syllabus.

8. **Tab is simple** — No unnecessary checkboxes, chunking strategy options, or database configuration. Just: select lesson → see what's ready → export.

---

## Testing Approach

1. Create test lesson files in `generated_lessons/month1/` (lesson md, project, qna, intro script)
2. Test asset status detection — verify it correctly identifies present/missing files
3. Test export — verify files are copied to export directory with correct structure
4. Test ZIP backup creation
5. Test manifest.json contents
6. Test export history listing
7. Test batch export with 2-3 lessons
