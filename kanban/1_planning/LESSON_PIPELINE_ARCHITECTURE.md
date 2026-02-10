# GWTH Lesson Pipeline Architecture

## Goal
Produce 120 high-quality, RAG-informed lessons with intro video scripts, Q&A sections, and practical projects — using Claude Code skills for each stage, with human review between steps.

---

## Pipeline Overview

```
CSV Syllabus ──► /enhance-syllabus ──► Review ──► /write-lesson ──► Review
                                                        │
                                              ┌─────────┼──────────┐
                                              ▼         ▼          ▼
                                        /write-project  /write-qna  /write-intro ──► Review
                                              │         │                │
                                              ▼         ▼                ▼
                                           Review    Review        /write-slides ──► Review
                                                                         │
                                                                         ▼
                                                                   Remotion Render
```

Each arrow is a **separate Claude Code session** (fresh context). Each box is a **skill invocation**. Human reviews between steps.

---

## Why Skills (Not Agents or Scripts)

| Approach | Pros | Cons |
|----------|------|------|
| **Claude Code Skills** | Full 200k context, Opus quality, you see everything, iterative refinement, can call RAG API mid-generation | Manual invocation per step |
| **Custom Python orchestrator** | Full automation, fire-and-forget | Black box, harder to debug, lower quality without Opus |
| **n8n / Make.com** | Visual workflow | API-only (no Claude Code), token limits, can't use RAG easily |
| **Claude Agent SDK** | Programmatic agents | Overkill for sequential content generation, harder to review |

**Recommendation: Skills are the right choice.** The quality ceiling is highest when Opus has full context and you can review/redirect. Once you trust the output, you can chain skills with a simple wrapper script for batch mode. We use 6 skills total.

---

## Skill Definitions

### Skill 1: `/enhance-syllabus`

**Purpose:** Take the raw CSV syllabus and enrich every lesson with sub-topics, milestones, source transcript recommendations, better ordering, and gap analysis.

**Input:** CSV file path (the export from the Syllabus Manager)

**Process:**
1. Parse CSV into structured lesson list
2. For each lesson, call RAG API (`http://192.168.178.50:8088/api/search?q={lesson_title}&limit=10`) to find relevant transcripts
3. Analyze the full syllabus for:
   - Logical ordering (prerequisites before dependents)
   - Gaps in coverage (topics mentioned in transcripts but not in syllabus)
   - Difficulty progression (beginner → intermediate → advanced)
   - Project groupings (which lessons form multi-lesson projects)
4. For each lesson, generate:
   - 5-8 sub-topics
   - 3-5 milestones (measurable outcomes)
   - `source_transcripts` list (top 5-10 relevant transcript filenames from RAG)
   - Refined description
   - Suggested prerequisites (references to other lesson IDs)

**Output:** Enhanced CSV file + a markdown summary of changes made and gaps identified.

**Key design choice:** Process the entire syllabus in ONE call (not per-lesson). The skill needs to see all 120 lessons to identify gaps, ordering issues, and cross-lesson dependencies. The CSV + RAG results for 120 lessons fits within 200k context.

#### Skill vs Pipeline App

| What | Owner | Detail |
|------|-------|--------|
| Parse CSV, call RAG, generate enhancements | **Skill** | Creative + analytical work needing Opus |
| RAG search API (`/api/search`) | **Pipeline app** | Already exists, skill calls it via `curl` |
| CSV export from Syllabus Manager | **Pipeline app** | Already exists (`/api/syllabus/export-csv`) |
| CSV re-import after enhancement | **Pipeline app** | Already exists (`/api/syllabus/import-csv`) |
| Add `project_type` and `project_group` fields to syllabus schema | **Pipeline app** | New — add to `syllabus_service.py` lesson schema and CSV export/import |
| Validate enhanced CSV can round-trip through Syllabus Manager | **Pipeline app** | New fields must survive export → enhance → import without data loss |

---

### Skill 2: `/write-lesson`

**Purpose:** Write a single complete lesson using RAG context.

**Input:** Lesson ID or title + path to the enhanced CSV

**Process:**
1. Read the enhanced CSV, extract target lesson metadata (sub-topics, milestones, source_transcripts)
2. For each source transcript listed, call RAG API to retrieve relevant chunks
3. Also run 2-3 broader RAG queries based on the lesson's sub-topics to find additional relevant content
4. **Report sources:** Output a "Sources Used" section listing every transcript/document referenced, so you can verify RAG quality
5. Write the full lesson following the structure in CLAUDE.md:
   - Front matter (number, title, duration, prerequisites, sources)
   - Learning objectives (3-5, aligned with milestones)
   - Core concepts (drawn from RAG content)
   - Practical examples (real-world cases from transcripts)
   - Summary & resources

**Output:** Single markdown file at `C:/yt-dlp/generated_lessons/month{N}/lesson_{NN}_{slug}.md`

**Context management:** Each lesson is a fresh `/write-lesson` invocation. No context bleed between lessons. The skill prompt itself provides all the structure; the RAG results provide the content.

#### Skill vs Pipeline App

| What | Owner | Detail |
|------|-------|--------|
| Read enhanced CSV, call RAG, write lesson markdown | **Skill** | Core creative work |
| RAG search API (`/api/search`) | **Pipeline app** | Already exists |
| Lesson file storage directory structure | **Pipeline app** | `generated_lessons/month{N}/` — create dirs if missing |
| Lesson status tracking (draft → review → final) | **Pipeline app** | New — update lesson `status` field in syllabus after generation |
| Lesson Writer tab integration | **Pipeline app** | Optional — Tab 6 could show a "Generate with Skill" button that copies the `/write-lesson` command to clipboard |

---

### Skill 3: `/write-project`

**Purpose:** Write the practical/lab section for a lesson (or multi-lesson project).

**Input:** Lesson ID + path to the generated lesson markdown + project scope (single-lesson, multi-lesson, or month capstone)

**Process:**
1. Read the lesson content to understand what was taught
2. Read related lessons if this is a multi-lesson project (the enhanced CSV has project groupings)
3. Call RAG API for practical examples, code samples, and real-world implementations mentioned in transcripts
4. Generate:
   - Project brief (what students will build)
   - Step-by-step instructions
   - Starter code / templates (where applicable)
   - Expected outcomes / acceptance criteria
   - Stretch goals

**Project types:**
- **Single-lesson labs** (20-30 min): Focused exercises reinforcing that lesson's concepts
- **Multi-lesson projects** (2-5 lessons): Larger builds that span lessons, with each lesson adding a component
- **Month capstone** (lessons 25, 61, 101): Comprehensive projects tying together the month's learning

**Output:** Project markdown saved alongside the lesson file.

#### Skill vs Pipeline App

| What | Owner | Detail |
|------|-------|--------|
| Read lesson + CSV, call RAG, write project markdown | **Skill** | Core creative work |
| RAG search API | **Pipeline app** | Already exists |
| Project group metadata in syllabus | **Pipeline app** | New `project_type` and `project_group` fields (same as Skill 1 requirement) |
| Listing which lessons share a project group | **Pipeline app** | New — API endpoint `GET /api/syllabus/project-group/{group_id}` returning all lessons in a group |
| Starter code templates storage | **Pipeline app** | New — `generated_lessons/templates/` directory for reusable code scaffolds that projects reference |

---

### Skill 4: `/write-intro`

**Purpose:** Write a short video intro script for a lesson (for F5-TTS voice-cloned narration).

**Input:** Lesson ID + path to the generated lesson markdown

**Process:**
1. Read the lesson content
2. Write a 60-90 second intro script that:
   - Hooks the viewer (why this topic matters)
   - Previews what they'll learn
   - Sets expectations for difficulty/prerequisites
   - Matches the tone of GWTH (professional but approachable)
3. Include `[VISUAL: ...]` markers for Remotion video segments
4. Include Remotion notes section with suggested compositions and text overlays

**Output:** Intro script markdown file.

#### Skill vs Pipeline App

| What | Owner | Detail |
|------|-------|--------|
| Read lesson content, write narration script with visual cues | **Skill** | Creative writing |
| Nothing currently required | **Pipeline app** | This skill is self-contained — it reads a file and writes a file |
| F5-TTS narration generation from the script | **Pipeline app** | Existing TTS Intro Video tab (Tab 7) — user pastes script text, selects voice, generates WAV |
| Auto-load intro script into TTS tab | **Pipeline app** | Nice-to-have — Tab 7 could have a "Load from lesson" dropdown that reads `lesson_*_intro.md` files |

---

### Skill 5: `/write-qna`

**Purpose:** Generate a Q&A / quiz section for a lesson.

**Input:** Lesson ID + path to the generated lesson markdown

**Process:**
1. Read the lesson content
2. Generate 10-15 questions:
   - 4-5 multiple choice (testing recall)
   - 3-4 short answer (testing understanding)
   - 2-3 scenario-based (testing application)
   - 1-2 discussion prompts (testing synthesis)
3. Include answer key with explanations
4. Reference specific lesson sections for each question

**Output:** Q&A markdown file.

#### Skill vs Pipeline App

| What | Owner | Detail |
|------|-------|--------|
| Read lesson + project, write questions and answer key | **Skill** | Creative + pedagogical work |
| Nothing currently required | **Pipeline app** | This skill is self-contained |
| Q&A import into GWTH platform | **Pipeline app** | Future — Export to GWTH tab (Tab 10) would need to parse Q&A markdown into the platform's quiz format |
| Q&A preview in dashboard | **Pipeline app** | Nice-to-have — a "Preview Q&A" section in the Lesson Writer tab showing formatted questions |

---

### Skill 6: `/write-slides`

**Purpose:** Create a Remotion slide composition sequence for the intro video. Outputs a JSON file defining which Remotion templates to use, in what order, with what text/props and estimated timings.

**Input:** Lesson ID or title + path to the intro script markdown (from `/write-intro`)

**Process:**
1. Read the intro script and the lesson content
2. Map each narration section to an existing Remotion composition template:
   - `LessonTitle-GradientAccent` for title cards
   - `BulletPoints-Numbered` for learning points
   - `Highlighter` for key definitions
   - `Timeline-Modern` for progressions
   - `Chart-Horizontal-Gradient` for statistics
   - `CodeBlock-Terminal` for code (Month 2-3 only)
   - `GWTHIntro*` / `GWTHOutro` for branding
3. Calculate estimated frame timings based on word count (~150 words/min, 30fps)
4. Output valid JSON with props matching the Zod schemas in `Root.tsx`

**Output:**
- `lesson_{NN}_slides.json` — Machine-readable slide sequence with compositions, props, and frame timings
- `lesson_{NN}_storyboard.md` — Human-readable storyboard for review

**Key constraint:** Only uses existing Remotion compositions from `C:/yt-dlp/remotion-project/`. No new templates invented. Props must pass Zod validation.

**Scope boundary:** This skill produces the creative decisions (which slides, what text, what order) and estimated timings. It does NOT render video, sync to actual audio, or join clips. Those are pipeline app responsibilities (see table below).

#### Skill vs Pipeline App

| What | Owner | Detail |
|------|-------|--------|
| Choose compositions, write slide text/props, estimate timings | **Skill** | Creative decisions needing Opus |
| Output `slides.json` + `storyboard.md` | **Skill** | Files written to `generated_lessons/month{N}/` |
| **Remotion `SequencePlayer` composition** | **Pipeline app (TypeScript)** | New — renders `slides.json` as a single video using `<Sequence>` + `<Audio>`. Dynamically maps composition name strings to React components. See `PROMPT_15_REMOTION_TAB_REBUILD.md`. |
| **Audio timing sync endpoint** | **Pipeline app (Python)** | New — `POST /api/remotion/sync-timing` reads actual WAV duration, proportionally adjusts `startFrame`/`durationFrames` in the JSON to match real audio |
| **Remotion Studio tab rebuild** | **Pipeline app (Python)** | New — Tab 9 rebuilt to: load `slides.json`, preview slide table, sync audio timing, trigger Remotion render, list rendered MP4s |
| F5-TTS audio generation | **Pipeline app** | Existing Tab 7 — generates the WAV file referenced by `audioFile` in slides.json |
| Word-level timestamp sync | **Pipeline app (Python)** | Future enhancement — use Kokoro/F5 word timestamps to align slide transitions precisely to spoken phrases instead of proportional scaling |
| Render to MP4 | **Pipeline app** | Calls `npx remotion render` via SSH to P520 host or from within container |

---

## RAG Integration Pattern

All skills call the RAG API the same way:

```
GET http://192.168.178.50:8088/api/search?q={query}&limit={n}
```

**The skill should:**
1. Make the RAG call via `curl` or `fetch` (Claude Code can run bash commands)
2. Parse the JSON response
3. Include the relevant content in its working context
4. **Always list the sources used** in the output so you can audit RAG quality

**Example in a skill prompt:**
```
Before writing, search the RAG database for relevant content:
- Run: curl -s "http://192.168.178.50:8088/api/search?q=<LESSON_TITLE>&limit=10"
- Run: curl -s "http://192.168.178.50:8088/api/search?q=<SUB_TOPIC_1>&limit=5"
- Include the top results as source material
- List all sources used in a "## Sources Used" section at the end
```

---

## CSV Schema (Enhanced)

The current CSV works with these additions:

| Field | Current | Enhanced |
|-------|---------|----------|
| `sub_topics` | empty | Semicolon-separated list (5-8 items) |
| `milestones` | empty | Semicolon-separated list (3-5 items) |
| `source_transcripts` | empty | Semicolon-separated filenames from RAG |
| `prerequisites` | empty | Semicolon-separated lesson IDs |
| `objectives` | empty | Semicolon-separated learning objectives |
| `project_type` | *new field* | `single`, `multi`, or `capstone` |
| `project_group` | *new field* | Group ID linking multi-lesson projects |

**Action needed:** Add `project_type` and `project_group` columns to the Syllabus Manager export. This is a small change to `syllabus_service.py`.

---

## Workflow: Step by Step

### Phase 1: Enhance Syllabus (one-time)

```
1. Export CSV from Syllabus Manager
2. Run:  /enhance-syllabus path/to/syllabus_export.csv
3. Review the enhanced CSV + gap analysis
4. Make manual adjustments in Syllabus Manager if needed
5. Re-export if changes were made
```

### Phase 2: Write Lessons (per lesson or small batch)

```
For each lesson:
1. Run:  /write-lesson "Lesson Title" path/to/enhanced_syllabus.csv
2. Review the generated lesson markdown
3. Edit if needed
4. Run:  /write-project "Lesson Title" path/to/lesson_file.md
5. Review the project section
6. Run:  /write-intro "Lesson Title" path/to/lesson_file.md
7. Review the intro script
8. Run:  /write-slides "Lesson Title" path/to/lesson_NN_intro.md
9. Review the storyboard + JSON
10. Render video in Remotion Studio or via CLI
11. Run:  /write-qna "Lesson Title" path/to/lesson_file.md
12. Review the Q&A
```

### Phase 3: Batch Mode (once confident)

Once you're happy with the quality from Phase 2 (after 5-10 lessons), create a batch wrapper:

```bash
# batch_lessons.sh - processes a range of lessons
for lesson_num in $(seq $1 $2); do
    claude --skill write-lesson --args "lesson_$lesson_num enhanced_syllabus.csv"
    claude --skill write-project --args "lesson_$lesson_num"
    claude --skill write-intro --args "lesson_$lesson_num"
    claude --skill write-slides --args "lesson_$lesson_num"
    claude --skill write-qna --args "lesson_$lesson_num"
done
```

This gives you fire-and-forget while maintaining per-lesson context isolation.

---

## File Structure

```
C:/yt-dlp/
├── generated_lessons/
│   ├── month1/
│   │   ├── lesson_01_welcome_to_gwth.md
│   │   ├── lesson_01_project.md
│   │   ├── lesson_01_intro_script.md
│   │   ├── lesson_01_slides.json
│   │   ├── lesson_01_storyboard.md
│   │   ├── lesson_01_qna.md
│   │   └── ...
│   ├── month2/
│   └── month3/
├── skills/
│   ├── enhance-syllabus/SKILL.md
│   ├── write-lesson/SKILL.md
│   ├── write-project/SKILL.md
│   ├── write-intro/SKILL.md
│   ├── write-qna/SKILL.md
│   └── write-slides/SKILL.md
└── syllabus/
    ├── syllabus_export_raw.csv
    └── syllabus_enhanced.csv
```

---

## Video Rendering Pipeline (Remotion + TTS)

### The Problem
The `/write-slides` skill outputs a JSON sequence of slide compositions with estimated timings. But slides need to be joined into one video and synced to the actual F5-TTS narration audio. The skill can't do this — it's a text generator.

### Architecture: What Goes Where

| Responsibility | Owner | Why |
|----------------|-------|-----|
| Decide which slides to show and in what order | `/write-slides` skill | Creative decision, needs Opus quality |
| Estimate frame timings from word count | `/write-slides` skill | Simple maths, good enough for storyboard review |
| Generate narration audio | F5-TTS (TTS Intro Video tab) | Existing pipeline step |
| Produce word-level timestamps | Kokoro TTS / F5-TTS | TTS engine capability |
| Adjust slide timings to match actual audio | Pipeline app (Python) | Reads audio duration + word timestamps, remaps frames |
| Render all slides as one video with audio | Remotion `SequencePlayer` composition | Remotion's native `<Sequence>` + `<Audio>` API |
| Final MP4 output | Remotion CLI or dashboard render button | `npx remotion render` |

### What Needs Building

#### 1. Remotion `SequencePlayer` Composition (TypeScript)
A new Remotion composition at `C:/yt-dlp/remotion-project/src/compositions/SequencePlayer.tsx` that:
- Accepts `slides.json` as input props (the `/write-slides` output)
- Renders each slide as a `<Sequence from={startFrame} durationInFrames={durationFrames}>` containing the specified composition with its props
- Loads the F5-TTS audio as an `<Audio src={audioFile}>` track
- Handles transitions between slides (cross-fade or cut)
- Total duration = sum of all slide durations

This is the key piece — it turns a JSON file into a rendered video.

#### 2. Audio Timing Sync (Python, in pipeline app)
A new endpoint or utility in `gwth_dashboard.py`:

```
POST /api/remotion/sync-timing
Body: { slides_json_path, audio_file_path }
```

This:
1. Reads the audio file to get actual duration (using `ffprobe` or Python `wave` module)
2. Optionally reads word-level timestamps from the TTS output
3. Proportionally adjusts `startFrame`/`durationFrames` in the JSON so total duration matches actual audio
4. Writes the adjusted JSON back (or returns it)

#### 3. Remotion Studio Tab Enhancement (Python, in pipeline app)
The existing Remotion Studio tab (Tab 9) needs:
- A "Load Slides JSON" button that reads a `slides.json` file and populates the composition
- A render button that calls `npx remotion render` with the SequencePlayer composition
- Display of render progress and output MP4

### End-to-End Flow

```
1. /write-intro        → lesson_03_intro.md (narration script)
2. /write-slides       → lesson_03_slides.json (estimated timings)
                       → lesson_03_storyboard.md (human review)
3. Human reviews storyboard, adjusts if needed
4. F5-TTS generates    → lesson_03_intro.wav (actual audio)
5. Pipeline sync-timing → lesson_03_slides.json (real timings)
6. Remotion renders    → lesson_03_intro.mp4 (final video)
```

Steps 4-6 can be triggered from the Remotion Studio tab with one button click once implemented.

---

## Quality Controls

1. **RAG source transparency:** Every skill outputs a "Sources Used" section listing filenames and relevance scores. You can spot-check whether the right transcripts are being used.

2. **Per-lesson context isolation:** Each `/write-lesson` call starts fresh. No context contamination between lessons.

3. **Human review gates:** Initially review after every skill. Reduce gates as confidence grows.

4. **Consistency checks:** The `/enhance-syllabus` skill checks for:
   - Duplicate coverage across lessons
   - Missing prerequisites
   - Difficulty jumps (beginner lesson requiring advanced knowledge)
   - Orphaned project references

5. **Iterative refinement:** If a lesson isn't good enough, just re-run `/write-lesson` with additional instructions. The skill is idempotent.

---

## Content Guidelines

1. **Lesson length:** Advertised as 1 hour (reading + lab), but actual target is up to 2 hours. People work at different speeds — the content should be comprehensive enough to fill 2 hours for a slower learner while being completable in ~1 hour by someone comfortable with the material.

2. **Voice/tone:** Friendly yet efficient. The audience is 16-60 year olds who have used ChatGPT for questions and light research but want to go deeper. British sense of humour. Genuinely helpful — not patronising, not overly academic. Think "knowledgeable colleague" not "professor." Style examples will be refined after the first few lessons.

3. **Code language by month:**
   - **Month 1 (Beginner):** No code. All tools are GUI/browser-based.
   - **Month 2 (Intermediate):** Mostly no-code, with some Python and JavaScript where needed (APIs, automation scripts).
   - **Month 3 (Advanced):** More Python and JavaScript, but mostly generated/scaffolded — students aren't expected to write from scratch.

4. **Test lesson deleted** from syllabus. Starting count: 120 lessons (25 Month 1 + 36 Month 2 + 40 Month 3 + 19 Backlog). More lessons will be added over time (e.g., optional Python coding track). The pipeline is designed to handle an expanding syllabus.

---

## Pipeline App Build Requirements Summary

This table collects all pipeline app work identified across the 6 skills — i.e., everything that needs to be coded on the P520 server (Python dashboard or Remotion TypeScript) rather than handled by skills.

### Already Exists (no work needed)
| Capability | Location |
|------------|----------|
| RAG search API | `GET /api/search` in `gwth_dashboard.py` |
| Syllabus CSV export | `GET /api/syllabus/export-csv` |
| Syllabus CSV import | `POST /api/syllabus/import-csv` |
| F5-TTS audio generation | Tab 7 (TTS Intro Video) |
| Kokoro TTS with word timestamps | Tab 8 (TTS Main Text) |
| Remotion project with compositions | `C:/yt-dlp/remotion-project/` |

### Needs Building (new code)
| Capability | Type | Used By | Priority |
|------------|------|---------|----------|
| Add `project_type` + `project_group` fields to syllabus schema | Python (`syllabus_service.py`) | `/enhance-syllabus`, `/write-project` | High — needed before first syllabus enhancement |
| `GET /api/syllabus/project-group/{id}` endpoint | Python (`gwth_dashboard.py`) | `/write-project` | Medium — only needed for multi-lesson projects |
| Lesson status tracking (update status after generation) | Python (`syllabus_service.py`) | `/write-lesson` | Low — nice-to-have for dashboard visibility |
| `SequencePlayer.tsx` Remotion composition | TypeScript (`remotion-project/`) | `/write-slides` | High — required for video rendering |
| Register SequencePlayer in `Root.tsx` | TypeScript (`remotion-project/`) | `/write-slides` | High — goes with SequencePlayer |
| `POST /api/remotion/sync-timing` endpoint | Python (`gwth_dashboard.py`) | `/write-slides` | High — required for audio-synced videos |
| Remotion Studio tab rebuild (Tab 9) | Python (`gwth_dashboard.py`) | `/write-slides` | High — user interface for rendering |
| Auto-load intro script into TTS tab | Python (`gwth_dashboard.py`) | `/write-intro` | Low — convenience feature |
| Q&A preview in Lesson Writer tab | Python (`gwth_dashboard.py`) | `/write-qna` | Low — convenience feature |
| Q&A export to GWTH platform quiz format | Python (`gwth_dashboard.py`) | `/write-qna` | Future — when platform integration is built |
| Word-level timestamp sync for slides | Python (`gwth_dashboard.py`) | `/write-slides` | Future — replaces proportional scaling with precise sync |
| Starter code templates directory | File system | `/write-project` | Low — just `mkdir generated_lessons/templates/` |

### Build Order
1. **`project_type` + `project_group` fields** → unblocks `/enhance-syllabus`
2. **SequencePlayer + sync-timing + Tab 9 rebuild** → unblocks video pipeline (see `PROMPT_15_REMOTION_TAB_REBUILD.md`)
3. **Everything else** → convenience features, build as needed

---

## Video to Transcript Tab — Hybrid Data Flow (P53 ↔ P520)

### Why We Changed: The P520 Monolithic Approach Was Unreliable

The original architecture ran the entire pipeline inside the Docker container on P520 — yt-dlp downloads, ffmpeg conversion, Whisper transcription, and Qdrant indexing all in one place. This looked clean on paper but was fragile in practice. Here's what kept breaking:

**1. Cookie Sync Was a 3-Hop Chain of Failure**

YouTube requires authenticated cookies for age-restricted content and to avoid rate limiting. The old flow was: Edge browser on P53 → extract to `fresh_cookies.txt` → SCP to P520 → Docker container reads from volume mount. Three handoff points, each with its own failure mode. The scheduled 6AM sync meant cookies could be up to 24 hours stale. If P53 was asleep, the sync silently failed. If the Edge profile wasn't signed in, the extracted cookies were useless. If the Docker volume mount changed (which it did — see #2), the container couldn't find the cookie file at all. The `ytdlp_service.py` error handling has 8+ different failure patterns (`age-restricted`, `http error 403`, `http error 429`, `sign in to confirm your age`) — every one traceable to stale or missing cookies.

**2. Docker Volume Mount Kept Breaking**

The data was migrated from `/home/david/gwth-pipeline/` to `/home/david/gwth-dashboard/` but the Docker volume mount wasn't always updated to match. This caused the container to see 0 channels, 0 transcripts — an empty directory. The `docker-compose.yml` currently mounts `./test-data:/data:ro` for local dev, but production required manual override to the correct path. Every container rebuild risked the mount pointing to the wrong directory. This is why the dashboard "worked sometimes and broke other times."

**3. GPU Contention — 4 Services Fighting Over 12GB VRAM**

The RTX 3060 has 12GB VRAM. The Docker container ran:
- Whisper large-v3 INT8: **3.1 GB** (loaded on demand for transcription)
- F5-TTS: **~6 GB** (always loaded for voice cloning)
- Kokoro-FastAPI: **~2.1 GB** (always loaded for main TTS)
- Docling: **variable** (spikes during PDF processing)

Total baseline without Whisper: ~8.1 GB. Add Whisper: ~11.2 GB. Add a Docling spike: over 12 GB → CUDA out-of-memory errors. The `whisper_service.py` has a CPU fallback for exactly this reason — but CPU transcription of a 60-minute video takes hours instead of minutes, making it effectively unusable.

**4. Memory Pressure — OOM Kills**

The container has a 32GB memory limit. Qdrant embedded DB alone takes 8.1GB RAM. During startup, memory spikes to ~28GB (model loading). At runtime it settles to ~14GB, but Whisper transcription of long videos can push it over, triggering the Linux OOM killer. This was documented in `docs/fix-rag-search-oom-crash.md` — even a simple RAG search (`model.encode(query)`) could push past the cgroup limit and kill the Python process.

**5. Container Restarts Lost In-Flight Work**

The download manager tracks active jobs in memory (`self.active_job`, `self.recent_jobs`). When the container restarts — due to OOM kills, health check failures, or Docker updates — all in-flight downloads and transcription queue state is lost. The `restart: unless-stopped` policy means the container comes back, but any partially downloaded video or mid-transcription job is gone. Only the persistent `download_history.json` survives (capped at 500 entries).

**6. Health Checks Conflicted With Long Transcriptions**

Health checks run every 30 seconds with a 30-second timeout and 5 retries (2.5 minutes total). Whisper transcription of a 60-minute video takes 10-15 minutes on GPU. During heavy transcription, the Python process can become unresponsive to health check HTTP requests → Docker declares the container unhealthy → restart → state loss (see #5). A vicious cycle.

**7. P520 Has the Wrong Network Fingerprint for YouTube**

YouTube tracks browser fingerprints (IP, user agent, session patterns) to detect automation. P53 is the machine that regularly browses YouTube — it has a trusted fingerprint. P520 is a headless Linux server making yt-dlp requests with cookies extracted from a different machine. YouTube sees a mismatch: cookies from a Windows Edge session being used from a Linux IP with no browser session. This triggers more aggressive rate limiting (HTTP 429) and cookie validation failures than the same downloads would on P53.

**8. ffmpeg Timeouts on Large Files**

The `ytdlp_service.py` sets a 10-minute timeout on ffmpeg conversion (`subprocess.run(..., timeout=600)`). Large video files (2+ hours) can exceed this, causing `TimeoutExpired` errors and leaving partial MP3 files on disk. Another failure point that doesn't exist when P53 handles conversion at its own pace.

### The Hybrid Fix: Each Machine Does What It's Best At

- **P53 (Windows)** has the browser with authenticated YouTube session — it downloads and transcribes. Native cookies, no sync needed, proven reliable for months.
- **P520 (Linux)** has the always-on Docker stack — it indexes, serves the dashboard, and runs the RAG/TTS pipeline. No yt-dlp, no cookie management, no Whisper GPU contention.

No cookie syncing needed. No yt-dlp in Docker. Each machine owns its part cleanly.

```
┌─────────────────────────────────────────────────────────────────┐
│  P53 (Windows - 192.168.178.88)                                 │
│  Role: DOWNLOAD + TRANSCRIBE                                    │
│                                                                 │
│  Edge Browser (duccelli@gmail.com)                              │
│       │                                                         │
│       │  Native cookies — no extraction or sync needed          │
│       ▼                                                         │
│                                                                 │
│  1. DOWNLOAD (yt-dlp with native browser cookies)               │
│     yt-dlp --cookies-from-browser edge <url>                    │
│     Output: C:\yt-dlp\GWTH-YT-Vids\[slug] Title.mp4            │
│       │                                                         │
│       ▼                                                         │
│  2. EXTRACT AUDIO                                               │
│     ffmpeg MP4 → MP3 (libmp3lame, q=2)                          │
│     Output: C:\yt-dlp\GWTH-YT-Vids\[slug] Title.mp3            │
│       │                                                         │
│       ▼                                                         │
│  3. TRANSCRIBE (faster-whisper, local GPU)                      │
│     Model: large-v3, int8, VAD enabled                          │
│     Output: C:\yt-dlp\GWTH-YT-Vids\[slug] Title.md             │
│       │                                                         │
│       ▼                                                         │
│  4. SYNC TO P520                                                │
│     rsync or robocopy → SCP                                     │
│     Only new/changed .md + .mp3 files                           │
│     (MP4s stay on P53 — too large, not needed on P520)          │
│       │                                                         │
│  C:\yt-dlp\GWTH-YT-Vids\                                       │
│    [slug] Title.mp4  ← stays on P53 (86GB+)                    │
│    [slug] Title.mp3  ← synced to P520                           │
│    [slug] Title.md   ← synced to P520                           │
└───────┼─────────────────────────────────────────────────────────┘
        │
        │  rsync/SCP (scheduled or on-demand)
        │  .md + .mp3 only (no MP4s)
        ▼
┌─────────────────────────────────────────────────────────────────┐
│  P520 (Linux - 192.168.178.50)                                  │
│  Role: INDEX + SERVE DASHBOARD + RAG                            │
│                                                                 │
│  /home/david/gwth-dashboard/GWTH-YT-Vids/                       │
│    [slug] Title.mp3   ← from P53                                │
│    [slug] Title.md    ← from P53                                │
│       │                                                         │
│  ┌────┼───────────────────────────────────────────────────────┐ │
│  │  Docker Container (port 8088)                              │ │
│  │  Volume: /home/david/gwth-dashboard → /data                │ │
│  │  GPU: RTX 3060 12GB (for TTS + Docling, not Whisper)       │ │
│  │       │                                                    │ │
│  │       ▼                                                    │ │
│  │  5. DETECT NEW FILES                                       │ │
│  │     Watch /data/GWTH-YT-Vids/ for new .md files            │ │
│  │     Compare against Qdrant (already indexed?)              │ │
│  │       │                                                    │ │
│  │       ▼                                                    │ │
│  │  6. INDEX TO QDRANT                                        │ │
│  │     Chunk transcript → embed (all-MiniLM-L6-v2)           │ │
│  │     Store in collection: gwth_lessons                      │ │
│  │     Currently: 746K points, 8.1GB                          │ │
│  │       │                                                    │ │
│  │       ▼                                                    │ │
│  │  7. SERVE DASHBOARD (Tab 2: Video to Transcript)           │ │
│  │     ┌──────────────────────────────────────────────────┐   │ │
│  │     │ Channel Discovery: scan filesystem, parse names  │   │ │
│  │     │ Stat Cards: Channels | Transcripts | MP3s        │   │ │
│  │     │ Channel Table: per-channel file counts           │   │ │
│  │     │ "Check New" → yt-dlp --flat-playlist (metadata   │   │ │
│  │     │   only, no download — just lists what's new)     │   │ │
│  │     │ Transcription queue for any unprocessed MP3s     │   │ │
│  │     └──────────────────────────────────────────────────┘   │ │
│  │                                                            │ │
│  │  Data files (/data/data/):                                 │ │
│  │    channel-config.json   (display name mappings)           │ │
│  │    download_history.json (dedup tracking)                  │ │
│  │                                                            │ │
│  │  Vector DB (/data/qdrant_data/):                           │ │
│  │    8.1GB, 746K points, ~3 min startup                      │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                 │
│  Downstream consumers (other tabs):                             │
│    Tab 4 (RAG System)    ◄── GET /api/search?q=...             │
│    Tab 5 (Syllabus)      ◄── source_transcripts field           │
│    Tab 6 (Lesson Writer) ◄── RAG context for lesson generation  │
│    Tab 7 (TTS Intro)     ◄── F5-TTS voice cloning (GPU)        │
│    Tab 8 (TTS Main)      ◄── Kokoro TTS (GPU)                  │
└─────────────────────────────────────────────────────────────────┘
```

### What Changed From the Old Architecture

| Aspect | Old (monolithic P520) | New (hybrid P53 + P520) |
|--------|----------------------|------------------------|
| **yt-dlp downloads** | Inside Docker on P520 | On P53 natively |
| **Cookie handling** | Extract on P53, SCP to P520, load in Docker | Native browser cookies on P53 — no sync |
| **Whisper transcription** | Docker GPU on P520 | P53 local GPU |
| **MP4 storage** | On P520 (86GB+) | Stays on P53 — not needed on P520 |
| **What gets synced** | Cookies (daily) | .md + .mp3 files (after processing) |
| **Docker complexity** | Needs yt-dlp, cookies, ffmpeg, Whisper, Qdrant | Only Qdrant + dashboard + TTS + Docling |
| **P520 GPU usage** | Whisper + TTS + Docling | TTS + Docling only (lighter load) |

### Key Design Decisions

1. **No cookie sync.** P53 has the authenticated browser session natively. yt-dlp reads cookies directly from Edge (`--cookies-from-browser edge`). This eliminates the most fragile part of the old architecture.

2. **P53 owns the full download-to-transcript pipeline.** Download → extract audio → transcribe is a single workflow on one machine. No cross-machine handoffs mid-pipeline.

3. **Only transcripts and MP3s sync to P520.** MP4 source videos (86GB+) stay on P53. P520 only needs the .md transcripts (for Qdrant indexing) and .mp3 files (for the dashboard's file counts and potential re-transcription).

4. **P520 Docker container gets simpler.** No yt-dlp, no cookie file management, no ffmpeg for video processing. It focuses on what it does best: serving the dashboard, running Qdrant, TTS generation, and Docling document processing.

5. **Tab 2 "Check New" still works on P520.** yt-dlp's `--flat-playlist` mode (metadata only, no download) can still run in the container to list new videos on a channel. The actual download is triggered on P53.

6. **P520 auto-indexes new transcripts.** When new .md files appear in GWTH-YT-Vids/ (after sync from P53), the dashboard detects them and queues them for Qdrant indexing. No manual step needed.

### Sync Methods (P53 → P520)

**Option A: Scheduled rsync (recommended)**
```bash
# Windows Task Scheduler runs daily or on-demand
rsync -avz --include="*.md" --include="*.mp3" --exclude="*" \
  /cygdrive/c/yt-dlp/GWTH-YT-Vids/ p520:/home/david/gwth-dashboard/GWTH-YT-Vids/
```

**Option B: Dashboard trigger**
Tab 2 could have a "Sync from P53" button that SSHs to P53 and pulls new files.

**Option C: Filesystem watch (future)**
inotify/watchdog on P53 auto-syncs new files as they're created.

### UI Impact: What Changes in Tab 2

The hybrid architecture changes Tab 2 from a "do everything" control panel to a **monitoring + indexing** dashboard. Here's what stays, what goes, and what's new:

**REMOVED from Tab 2 (moved to P53):**

| Old UI Element | Why Removed |
|----------------|-------------|
| "Download" button per video | Downloads happen on P53, not in Docker |
| Download progress bar | No downloads happening on P520 |
| yt-dlp download queue | P53 manages its own queue |
| Cookie status / sync indicator | No cookies on P520 — not needed |
| ffmpeg conversion progress | Conversion happens on P53 |
| Whisper transcription queue | Transcription happens on P53 |
| Whisper progress indicator | Not running Whisper on P520 |

**KEPT in Tab 2 (still relevant):**

| UI Element | Why Kept |
|------------|----------|
| Stat cards (Channels, Transcripts, MP3s) | Still scanning the filesystem on P520 |
| Channel table with per-channel counts | Same — reads synced files |
| "Check New" (metadata only) | yt-dlp `--flat-playlist` still useful for seeing what's available |
| Channel config / display name mapping | Still needed for the channel table |

**NEW in Tab 2 (hybrid-specific):**

| New UI Element | Purpose |
|----------------|---------|
| **"Sync from P53" button** | Triggers rsync/SCP pull of new .md + .mp3 files from P53 |
| **Last sync timestamp** | Shows when files were last synced from P53 |
| **Sync status indicator** | Green (recent sync), yellow (>24h), red (P53 unreachable) |
| **"Unindexed" count in stat cards** | New .md files on disk not yet in Qdrant |
| **"Index New Transcripts" button** | Queues unindexed .md files for Qdrant embedding |
| **Indexing progress** | Shows chunk/embed progress for new transcripts |
| **P53 connection status** | SSH connectivity check to P53 |

**Tab 2 layout (new):**

```
┌─────────────────────────────────────────────────────────────┐
│  Stat Cards:                                                │
│  [Channels: 43] [Transcripts: 1593] [MP3s: 858]            │
│  [Unindexed: 12] [Last Sync: 2h ago ●]                     │
├─────────────────────────────────────────────────────────────┤
│  Toolbar:                                                   │
│  [Sync from P53 ↓] [Index New Transcripts ▶] [Refresh ↻]   │
├─────────────────────────────────────────────────────────────┤
│  Channel Table:                                             │
│  Channel          │ Videos │ MP3s │ Transcripts │ Indexed   │
│  Matthew Berman   │   85   │  85  │     85      │  85 ✓    │
│  Dave Shapiro     │   72   │  72  │     70      │  68 ⚠    │
│  ...              │        │      │             │           │
├─────────────────────────────────────────────────────────────┤
│  Indexing Queue (when active):                              │
│  ████████████░░░░░░░░ 15/23 transcripts indexed             │
│  Current: [dave_shapiro] AI Agents Overview.md              │
└─────────────────────────────────────────────────────────────┘
```

**What moves to P53 (outside the dashboard):**

The download + transcribe workflow runs on P53 via batch scripts or a lightweight local UI. The dashboard doesn't need to orchestrate it — it just consumes the results. P53's workflow:

1. User runs yt-dlp batch script (or a simple local tool) on P53
2. Videos download with native Edge cookies — no failures
3. ffmpeg converts to MP3 — no timeout issues (no container limits)
4. Whisper transcribes on P53's GPU — no VRAM contention with TTS
5. rsync pushes .md + .mp3 to P520
6. Dashboard Tab 2 detects new files, indexes to Qdrant

---

## P53 Pipeline — Scripts, Schedules, and File Locations

### Scheduled Tasks (Windows Task Scheduler)

| Task | Script | Schedule | Status |
|------|--------|----------|--------|
| YouTube Daily Download | `C:\yt-dlp\scripts\daily-download.bat` | Daily 9:00 AM | Running |
| Daily Video Processor | `C:\yt-dlp\scripts\run_daily_processor.bat` | Daily 12:00 PM | Ready |
| GWTH Cookie Sync | `C:\yt-dlp\scripts\sync_cookies_to_p520.bat` | Daily 6:00 AM | Ready |

### Pipeline Flow on P53

```
6:00 AM  sync_cookies_to_p520.bat
           → SCP youtube_cookies.txt to P520

9:00 AM  daily-download.bat
           → yt-dlp downloads last 7 days from 33 channels
           → saves MP4s to C:\yt-dlp\NEW_VIDEOS\
           → calls daily_video_processor.py --execute

12:00 PM run_daily_processor.bat (backup run)
           → runs daily_video_processor.py --execute
           → Step 1: Find MP4s in NEW_VIDEOS
           → Step 2: ffmpeg MP4→MP3
           → Step 3: Whisper transcribe (small model, GPU)
           → Step 4: Organize to channel folders in GWTH-YT-Vids
           → Step 5: Archive MP4/MP3 to E:\yt-dlp\NEW_VIDEOS
           → Step 6: Index to Qdrant
           → Step 7: Verify indexing
```

### File Locations on P53

| Path | Purpose |
|------|---------|
| `C:\yt-dlp\NEW_VIDEOS\` | Queue for newly downloaded MP4s |
| `C:\yt-dlp\GWTH-YT-Vids\` | Organized transcripts by channel folder (33 folders) |
| `C:\yt-dlp\downloaded.txt` | yt-dlp archive (1518+ entries, prevents re-downloads) |
| `C:\yt-dlp\youtube_cookies.txt` | Fresh cookies from Edge |
| `C:\yt-dlp\scripts\channel-config.json` | Channel name → folder mapping |
| `C:\yt-dlp\logs\` | Processing and download logs |
| `E:\yt-dlp\NEW_VIDEOS\` | Archive of processed MP4/MP3 files |

### What's Missing: P53 → P520 Transcript Sync

No automatic sync of `.md`/`.txt` transcripts from P53 to P520. This is the key gap in the hybrid architecture. Sync manually with:

```bash
rsync -avz --include="*/" --include="*.md" --include="*.txt" --include="*.mp3" --exclude="*" \
  /cygdrive/c/yt-dlp/GWTH-YT-Vids/ p520:/home/david/gwth-dashboard/GWTH-YT-Vids/
```

### Backfill Script

`C:\yt-dlp\backfill-download.bat` — downloads last 6 months (`--dateafter 20250801`) from all 33 channels. Run manually when ready. Uses `downloaded.txt` to skip already-downloaded videos.

---

## Next Steps

1. ~~Architecture doc~~ ✅ Complete
2. ~~Build 6 skill files~~ ✅ Complete
3. Add `project_type` + `project_group` to syllabus schema
4. Fix RAG API `source_filter` bug (redeploy `qdrant_service.py`)
5. Test `/enhance-syllabus` on the full CSV
6. Review the enhanced syllabus
7. Test `/write-lesson` on 2-3 lessons across different difficulty levels
8. Iterate on quality
9. Build Remotion `SequencePlayer` + Tab 9 rebuild (use `PROMPT_15`)
10. Test full video pipeline: `/write-intro` → `/write-slides` → TTS → render
11. Scale up to batch mode
