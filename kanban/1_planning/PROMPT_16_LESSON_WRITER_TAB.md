# Prompt: Rebuild Lesson Writer Tab (Tab 6) to Work with Skills Pipeline

## Objective

Rebuild the Lesson Writer tab from a static mockup into a functional dashboard that:
1. Loads real lesson data from the Syllabus Manager backend
2. Shows all enhanced metadata (sub-topics, milestones, objectives, source transcripts, prerequisites)
3. Provides a RAG search that actually queries the vector database
4. Displays and manages all generated content files (lesson, project, intro, slides, Q&A)
5. Provides one-click commands to invoke each Claude Code skill
6. Tracks lesson generation progress through the pipeline stages

The tab is the **control centre** for the lesson generation pipeline. The actual content generation happens in Claude Code skills (`/write-lesson`, `/write-project`, `/write-intro`, `/write-slides`, `/write-qna`). This tab provides the data, shows the results, and gives the user the commands to run.

**Critically, this tab must work with the other dashboard tabs**, not in isolation. The lesson moves through the full pipeline: Syllabus Manager → Lesson Writer → TTS Intro Video → TTS Main Text → Remotion Studio → Export to GWTH. The Lesson Writer tab sits in the middle and must hand off data cleanly to subsequent tabs.

---

## Context: Integration with Other Dashboard Tabs

The Lesson Writer tab does not exist in isolation. It consumes data from earlier tabs and feeds data into later tabs. All tabs share the same backend APIs and data paths.

### Tab-by-Tab Integration

| Tab | Direction | Integration |
|-----|-----------|-------------|
| **Tab 4: RAG System** | ← Input | Lesson Writer calls the same `/api/search` endpoint. RAG search results in the Lesson Writer should behave identically to Tab 4's search. |
| **Tab 5: Syllabus Manager** | ← Input | Lesson Writer reads lesson metadata from the syllabus API (`/api/syllabus/lessons`). When a lesson's `source_transcripts`, `status`, or other fields are updated in the Lesson Writer, those changes must persist and be visible when the user switches back to the Syllabus Manager tab. Both tabs share the same `SyllabusService` backend. |
| **Tab 7: TTS Intro Video (F5-TTS)** | → Output | After `/write-intro` generates the narration script, the user goes to Tab 7 to generate the audio. The Lesson Writer should show the intro script content and offer a "Send to TTS Intro" button or at minimum display the file path so the user can load it in Tab 7. Tab 7's "Audio File" selector should be able to find the generated WAV. |
| **Tab 8: TTS Main Text (Kokoro)** | → Output | The lesson's main text content could be sent to Kokoro TTS for full lesson narration. The Lesson Writer should offer a "Send to TTS Main" button or display the content path. Word timestamps from Kokoro feed into the slides/video pipeline. |
| **Tab 9: Remotion Studio** | → Output | After `/write-slides` generates the `slides.json`, the user goes to Tab 9 to load it, sync audio timing, and render the video. The Lesson Writer should show the slides JSON status and link to the Remotion Studio tab. The slides JSON path must match what Tab 9's "Load Slides JSON" dropdown expects. |
| **Tab 10: Export to GWTH** | → Output | When all lesson components are complete (lesson, project, intro, Q&A, slides, video), the lesson is ready for export. The Lesson Writer's status tracking (draft → in_review → final) signals readiness to Tab 10. Tab 10 should be able to query which lessons are marked `final`. |

### Shared Data Paths

All tabs read/write to the same filesystem locations on P520:

| Data | Path (in container) | Used by tabs |
|------|-------------------|--------------|
| Syllabus JSON | `/data/syllabus.json` | Tab 5 (Syllabus Manager), Tab 6 (Lesson Writer), Tab 10 (Export) |
| Generated lessons | `/data/generated_lessons/month{N}/` | Tab 6 (Lesson Writer), Tab 9 (Remotion Studio), Tab 10 (Export) |
| TTS sessions | `/home/david/gwth-dashboard/tts_sessions/` | Tab 7 (TTS Intro), Tab 8 (TTS Main), Tab 9 (Remotion Studio) |
| RAG vector database | Qdrant (in-memory) | Tab 4 (RAG System), Tab 6 (Lesson Writer) |

### Cross-Tab Consistency Rules

1. **Syllabus is the single source of truth** for lesson metadata. The Lesson Writer READS from it and can UPDATE specific fields (`status`, `source_transcripts`) but does not duplicate or cache lesson data separately.
2. **File naming convention must be consistent** across all tabs. The lesson file at `month1/lesson_01_welcome_to_gwth.md` must be findable by Tab 9 (Remotion Studio) and Tab 10 (Export) using the same naming logic.
3. **Status field is shared.** When the Lesson Writer marks a lesson as `final`, Tab 10 (Export) should see it as ready. When the Syllabus Manager changes a lesson's column/order, the Lesson Writer should reflect this on next load.
4. **Generated file paths are predictable.** The Lesson Writer, TTS tabs, and Remotion Studio all derive file paths from the same formula: `month{N}/lesson_{NN}_{slug}_{type}.{ext}`. This must be implemented as a shared utility, not duplicated per tab.

---

## Context: Skill vs Tab Responsibilities

The architecture doc (`kanban/1_planning/LESSON_PIPELINE_ARCHITECTURE.md`) defines 6 skills. The Lesson Writer tab is the UI counterpart for skills 2-5 (not skill 1 which operates on the full syllabus, and not skill 6 which feeds into the Remotion Studio tab).

### What the SKILLS do (in Claude Code, outside this tab)
| Skill | What it produces | Triggered how |
|-------|-----------------|---------------|
| `/write-lesson` | `lesson_{NN}_{slug}.md` — full lesson markdown | User runs skill in Claude Code with lesson title + CSV path |
| `/write-project` | `lesson_{NN}_project.md` — lab/project exercise | User runs skill with lesson title + lesson file path |
| `/write-intro` | `lesson_{NN}_intro.md` — 60-90s narration script | User runs skill with lesson title + lesson file path |
| `/write-qna` | `lesson_{NN}_qna.md` — questions + answer key | User runs skill with lesson title + lesson file path |
| `/write-slides` | `lesson_{NN}_slides.json` + `_storyboard.md` | User runs skill with lesson title + intro file path |

### What THIS TAB does (in the pipeline dashboard)
| Responsibility | Detail |
|----------------|--------|
| Load lesson list from syllabus backend | `GET /api/syllabus/lessons` — populate lesson selector dropdown |
| Display lesson metadata | Title, description, month, difficulty, sub-topics, milestones, objectives, prerequisites, source_transcripts |
| RAG search | `GET /api/search?q={query}&limit={n}` — real search, display results with scores, allow selecting transcripts |
| Show generated files | Scan `generated_lessons/month{N}/` for existing files for the selected lesson |
| Display file content | Read and show markdown/JSON content of generated files |
| Copy skill commands | One-click copy to clipboard: the exact `/write-lesson "Title" path/to/csv` command to paste into Claude Code |
| Track pipeline progress | Show which steps are complete (lesson ✅, project ❌, intro ❌, Q&A ❌, slides ❌) |
| Save/edit lesson content | Allow manual edits to generated markdown and save back to file |
| Update lesson status | Mark lesson as `draft` → `in_review` → `final` in syllabus backend |

---

## Current State

The Lesson Writer tab (Tab 6, lines 4838-4908 in `gwth_dashboard.py`) is a static mockup with:
- Hardcoded lesson dropdown (5 items)
- Static metadata fields (title, duration, difficulty, objectives)
- Non-functional RAG search with hardcoded results
- Empty markdown editor
- Non-functional buttons (Load from Syllabus, Save Draft, Generate with Claude, Copy Prompt, Preview, Save Lesson)

**None of it connects to any backend.** Every element needs replacing.

---

## Design: Rebuilt Tab Layout

### Top-to-bottom flow (following UI Workflow Direction Principle from CLAUDE.md):

```
┌─────────────────────────────────────────────────────────────────┐
│ Header: "Lesson Writer"    [Status: Draft/Review/Final]         │
├─────────────────────────────────────────────────────────────────┤
│ Lesson Selector: dropdown (all lessons from syllabus API)       │
│ Pipeline Progress: ● Lesson  ○ Project  ○ Intro  ○ Q&A  ○ Slides│
├────────────────────────────┬────────────────────────────────────┤
│ LEFT COLUMN                │ RIGHT COLUMN                       │
│                            │                                    │
│ ┌────────────────────────┐ │ ┌──────────────────────────────┐  │
│ │ Lesson Metadata        │ │ │ Generated Content Viewer     │  │
│ │ Title, Month, Diff     │ │ │ [Tabs: Lesson|Project|Intro| │  │
│ │ Description            │ │ │  Q&A|Slides|Storyboard]     │  │
│ │ Sub-topics (chips)     │ │ │                              │  │
│ │ Milestones (list)      │ │ │ Markdown content display     │  │
│ │ Objectives (list)      │ │ │ with edit capability         │  │
│ │ Prerequisites (links)  │ │ │                              │  │
│ └────────────────────────┘ │ │                              │  │
│ ┌────────────────────────┐ │ │                              │  │
│ │ Source Transcripts     │ │ └──────────────────────────────┘  │
│ │ From enhanced CSV      │ │ ┌──────────────────────────────┐  │
│ │ + RAG search for more  │ │ │ Skill Commands               │  │
│ │ [Search] [Results]     │ │ │ Copy-to-clipboard buttons    │  │
│ └────────────────────────┘ │ │ for each pipeline step       │  │
│ ┌────────────────────────┐ │ └──────────────────────────────┘  │
│ │ RAG Content Preview    │ │ ┌──────────────────────────────┐  │
│ │ Selected transcript    │ │ │ Actions                      │  │
│ │ content chunks         │ │ │ [Save] [Mark as Review]      │  │
│ └────────────────────────┘ │ │ [Mark as Final]              │  │
│                            │ └──────────────────────────────┘  │
├────────────────────────────┴────────────────────────────────────┤
```

---

## Section Details

### 1. Header Row
- Title: "Lesson Writer"
- Status badge: Draft (grey), In Review (yellow), Final (green) — reads from syllabus `status` field
- No "Generate with Claude" button here — that's replaced by the Skill Commands section

### 2. Lesson Selector + Pipeline Progress

**Lesson dropdown:**
- Populated from `GET /api/syllabus/lessons`
- Format: "M1-01: Welcome to GWTH" (month-order: title)
- Grouped by month: Month 1, Month 2, Month 3, Backlog
- On selection change: load all metadata + scan for generated files

**Pipeline progress indicator:**
A horizontal row of dots/icons showing which steps are complete for the selected lesson:
- ● Lesson (green if `lesson_{NN}_{slug}.md` exists)
- ● Project (green if `lesson_{NN}_project.md` exists)
- ● Intro (green if `lesson_{NN}_intro.md` exists)
- ● Q&A (green if `lesson_{NN}_qna.md` exists)
- ● Slides (green if `lesson_{NN}_slides.json` exists)

Check by scanning the filesystem: `GET /api/lessons/{id}/files` (new endpoint — see below).

### 3. Left Column: Lesson Metadata

**Lesson Metadata card** (read-only display, data from syllabus API):
- Title (large text)
- Month + Lesson number + Difficulty badge
- Description (full text)
- Sub-topics: displayed as chips/tags (from enhanced CSV `sub_topics` field)
- Milestones: numbered list (from `milestones` field)
- Objectives: bullet list (from `objectives` field)
- Prerequisites: clickable links to other lessons (from `prerequisites` field)
- Tags: displayed as small badges

This is all READ-ONLY in this tab. Editing happens in the Syllabus Manager tab.

**Source Transcripts card:**
- Top section: transcripts already assigned (from `source_transcripts` field in enhanced CSV)
  - Each shown as a row: filename, source type (YouTube/PDF/HTML), relevance score if available
  - Click to preview content in RAG Content Preview card below
- Bottom section: RAG search to find additional transcripts
  - Search input + Search button
  - Calls `GET /api/search?q={query}&limit=10`
  - Results shown as checkboxes with filename + score
  - "Add Selected" button to append to the lesson's `source_transcripts` field

**RAG Content Preview card:**
- When a transcript is clicked (from either assigned or search results), show the RAG content chunks
- Call `GET /api/search?q={lesson_title}&limit=5` filtered by that filename (or a new endpoint)
- Display the actual text content so the user can verify quality before generating

### 4. Right Column: Generated Content Viewer

**Content sub-tabs** (inner tabs within this card):
| Sub-tab | File | Content type |
|---------|------|-------------|
| Lesson | `lesson_{NN}_{slug}.md` | Markdown |
| Project | `lesson_{NN}_project.md` | Markdown |
| Intro | `lesson_{NN}_intro.md` | Markdown |
| Q&A | `lesson_{NN}_qna.md` | Markdown |
| Slides | `lesson_{NN}_slides.json` | JSON (formatted) |
| Storyboard | `lesson_{NN}_storyboard.md` | Markdown |

Each sub-tab:
- If file exists: display content in a large text area (editable)
- If file doesn't exist: show "Not yet generated" with the skill command to run
- "Save" button per sub-tab to write edits back to file

**Markdown rendering:** Use a simple markdown preview toggle (edit mode / preview mode). NiceGUI has `ui.markdown()` for rendering.

### 5. Skill Commands Card

A card with copy-to-clipboard buttons for each pipeline step. Each button copies the exact command the user pastes into Claude Code:

| Button | Copies to clipboard |
|--------|-------------------|
| "Copy /write-lesson command" | `/write-lesson "Welcome to GWTH" C:/yt-dlp/syllabus_enhanced.csv` |
| "Copy /write-project command" | `/write-project "Welcome to GWTH" C:/yt-dlp/generated_lessons/month1/lesson_01_welcome_to_gwth.md` |
| "Copy /write-intro command" | `/write-intro "Welcome to GWTH" C:/yt-dlp/generated_lessons/month1/lesson_01_welcome_to_gwth.md` |
| "Copy /write-qna command" | `/write-qna "Welcome to GWTH" C:/yt-dlp/generated_lessons/month1/lesson_01_welcome_to_gwth.md` |
| "Copy /write-slides command" | `/write-slides "Welcome to GWTH" C:/yt-dlp/generated_lessons/month1/lesson_01_intro.md` |

Each button:
- Builds the command dynamically from the selected lesson's title and expected file paths
- Copies to clipboard using JavaScript `navigator.clipboard.writeText()`
- Shows a brief "Copied!" notification
- Is greyed out if the prerequisite file doesn't exist (e.g., can't copy /write-project if lesson file doesn't exist yet)

### 6. Cross-Tab Navigation Card

Quick-link buttons to send the selected lesson's data to downstream tabs:

| Button | Action |
|--------|--------|
| "Open in Syllabus Manager" | Switches to Tab 5, scrolls to / highlights this lesson's card in the Kanban board |
| "Send Intro to TTS" | Switches to Tab 7, pre-fills the text area with the intro script content (if `lesson_{NN}_intro.md` exists). Greyed out if intro not generated. |
| "Send Lesson to TTS Main" | Switches to Tab 8, pre-fills the text area with the lesson's main content. Greyed out if lesson not generated. |
| "Open in Remotion Studio" | Switches to Tab 9. If `slides.json` exists, pre-selects it in the slides JSON dropdown. Greyed out if slides not generated. |
| "View in Export" | Switches to Tab 10, highlights this lesson. Greyed out if status is not `final`. |

Implementation: Use NiceGUI's `tabs.set_value(tab_name)` to switch tabs programmatically. Pass data via shared state (e.g., a global `selected_lesson_id` variable that downstream tabs read on activation).

### 7. Actions Card

- **Save Changes** — saves any edits made in the content viewer
- **Mark as In Review** — updates lesson `status` to `in_review` via `PATCH /api/syllabus/lessons/{id}`
- **Mark as Final** — updates lesson `status` to `final`
- **Refresh Files** — re-scans filesystem for generated files

---

## New API Endpoints Needed

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/api/lessons/{id}/files` | List generated files for a lesson (scans `generated_lessons/month{N}/` for matching files) |
| GET | `/api/lessons/{id}/file/{type}` | Read content of a specific generated file (type: lesson, project, intro, qna, slides, storyboard) |
| PUT | `/api/lessons/{id}/file/{type}` | Write/update content of a generated file |
| PATCH | `/api/syllabus/lessons/{id}` | Update lesson fields (status, source_transcripts) — may already exist |

### File scanning logic for `/api/lessons/{id}/files`

Given a lesson ID, look up the lesson in the syllabus to get its month and order number. Then scan:
```
generated_lessons/month{N}/lesson_{NN}_*.md
generated_lessons/month{N}/lesson_{NN}_*.json
```

Return a dict:
```json
{
  "lesson": {"exists": true, "path": "month1/lesson_01_welcome_to_gwth.md", "size": 12340, "modified": "2026-01-30T18:00:00"},
  "project": {"exists": false},
  "intro": {"exists": false},
  "qna": {"exists": false},
  "slides": {"exists": false},
  "storyboard": {"exists": false}
}
```

The file naming convention uses the lesson's order number (zero-padded) and a slug derived from the title:
- `lesson_01_welcome_to_gwth.md` (main lesson)
- `lesson_01_project.md` (project)
- `lesson_01_intro.md` (intro script)
- `lesson_01_qna.md` (Q&A)
- `lesson_01_slides.json` (slides)
- `lesson_01_storyboard.md` (storyboard)

---

## Reference: Existing API Endpoints

These already exist and should be used:

| Endpoint | Purpose |
|----------|---------|
| `GET /api/syllabus/lessons` | List all lessons with metadata |
| `GET /api/syllabus/lessons/{id}` | Get single lesson detail |
| `PUT /api/syllabus/lessons/{id}` | Update lesson |
| `GET /api/search?q={query}&limit={n}` | RAG semantic search |
| `GET /api/syllabus/export-csv` | Export syllabus as CSV |

---

## Important Implementation Notes

### JavaScript Escaping in Python Templates
The dashboard uses `HTML_TEMPLATE = """..."""` triple-quoted Python strings. Inside these:
- Use `\\n` not `\n` for JavaScript newlines
- Use `\\x27` not `\'` for single quotes in JS onclick handlers
- This has broken the dashboard multiple times

### NiceGUI 3.x Patterns
- Use `ui.html(content, sanitize=False)` for raw HTML
- Use `ui.add_body_html('''<script>...</script>''')` for JavaScript
- Tab panels are lazy-rendered — use MutationObserver or retry patterns
- Use `asyncio.to_thread()` for long-running synchronous calls

### Clipboard Copy Pattern
```javascript
function copyToClipboard(text) {
    navigator.clipboard.writeText(text).then(function() {
        // Show brief notification
    });
}
```

### File Paths
- Dashboard runs on P520 in Docker
- Generated lessons: `/data/generated_lessons/` (mapped from host)
- Syllabus data: `/data/` directory
- The skill commands copied to clipboard use Windows paths (`C:/yt-dlp/...`) since they'll be pasted into Claude Code on the Windows machine

---

## Files to Modify

| File | Action | Lines |
|------|--------|-------|
| `app/gwth_dashboard.py` | REPLACE Tab 6 (lines 4838-4908) | ~70 lines → ~300 lines |
| `app/gwth_dashboard.py` | ADD new API endpoints | After existing syllabus endpoints (~line 200) |

---

## Acceptance Criteria

1. **Lesson selector populated from API** — dropdown shows all lessons grouped by month, loading from syllabus backend
2. **Metadata displays correctly** — selecting a lesson shows its title, description, sub-topics, milestones, objectives, prerequisites, and source transcripts from the enhanced syllabus
3. **RAG search works** — entering a query and clicking Search calls the real API and shows results with scores
4. **Pipeline progress shows** — green/grey dots indicating which generated files exist for the selected lesson
5. **Generated content displays** — if a lesson file exists, its markdown content appears in the viewer and is editable
6. **Skill commands copy correctly** — clicking "Copy /write-lesson command" puts the correct command on the clipboard with the right lesson title and file paths
7. **Skill command buttons are contextually greyed out** — e.g., /write-project button is disabled until the lesson file exists
8. **Save works** — editing content in the viewer and clicking Save writes it back to the file
9. **Status updates** — Mark as Review / Mark as Final buttons update the lesson status in the syllabus
10. **Cross-tab navigation works** — "Send Intro to TTS" switches to Tab 7 and pre-fills the text area. "Open in Remotion Studio" switches to Tab 9.
11. **Syllabus consistency** — changes made in Lesson Writer (status, source_transcripts) are visible when switching to Syllabus Manager tab without page reload
12. **File path consistency** — generated file paths match what Remotion Studio (Tab 9) and Export (Tab 10) expect

---

## Design Reference

The current mockup screenshot shows the basic two-column layout. Keep this layout but:
- Replace the static lesson dropdown with a real one
- Replace the static metadata with dynamic fields showing sub-topics, milestones, objectives
- Replace the static RAG results with a real search
- Replace the markdown text area with a tabbed content viewer (lesson/project/intro/Q&A/slides/storyboard)
- Replace "Generate with Claude" and "Copy Prompt" buttons with the Skill Commands card
- Add the pipeline progress indicator
- Add status tracking

Use the same styling patterns as the Syllabus Manager tab (dark cards, stat badges, cyan accent).
