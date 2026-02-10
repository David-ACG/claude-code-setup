# GWTH Pipeline V2 - Comprehensive Build Analysis

**Generated:** 2026-01-10
**Gold Standard:** `GWTH_PIPELINE_V2_UI_MOCKUP.html`

---

## 1. Documentation Anomalies (REQUIRES YOUR REVIEW)

### 1.1 CLAUDE.md Inconsistencies

| Issue | Current | Should Be |
|-------|---------|-----------|
| Tab count | "All 10 tabs: Pipeline Overview \| YT-dlp & Transcription \| External Content \| RAG System \| Syllabus Manager \| Lesson Writer \| TTS Intro Video \| TTS Main Text \| Remotion Studio \| Export to GWTH" | Correct (10 tabs) |
| Vector points | "746K points" in multiple places | Should be ~871K (based on actual database) |
| Database size | "8.1GB" in multiple places | Should be ~9.3GB (based on actual copy) |

### 1.2 PROMPT_02_RAG_SYSTEM.md Issues

| Issue | Description |
|-------|-------------|
| Missing features | Doesn't mention Limit dropdown, Min Score filter, Source Type filter from HTML mockup |
| Database Management | Mockup has "Database Management" card with Reindex/Clear/Statistics buttons - not in prompt |
| Recent Queries | Mockup has "Recent Queries" log - not in prompt |
| UI layout | Mockup uses card-grid for stats (4 cards in row), prompt uses simple text display |

### 1.3 design-system.md vs HTML Mockup

| Component | design-system.md | HTML Mockup (Gold Standard) |
|-----------|------------------|----------------------------|
| GPU Status Bar | Mentioned but not fully specified | Complete implementation with model cards |
| Theme Toggle | Mentioned | Shows sun icon, toggleTheme() function |
| Tab styling | `.tabs-custom` classes | Uses `.tabs-container`, `.tab.active` |

---

## 2. Gap Analysis: HTML Mockup vs Current Implementation

### 2.1 Header (Not Implemented)

**Mockup has:**
- Logo: "GWTH.ai Pipeline" with green accent
- Status indicators: "P520 Server" and "P53 Laptop" with status dots
- Theme toggle button with sun/moon icon

**Current has:**
- Basic NiceGUI header
- No status indicators
- No theme toggle

### 2.2 GPU Status Bar (Not Implemented)

**Mockup has:**
- GPU Status: RTX 3060 12GB with memory bar (79% = 9.5GB/12GB)
- Model cards: Kokoro TTS (2.1GB loaded), F5-TTS (unloaded), Whisper (unloaded), Remotion (CPU), Qdrant (CPU)
- Load/Unload buttons per model
- Legend: "● = Loaded, ○ = Unloaded, ◐ = Loading..."

**Current has:**
- Nothing

### 2.3 Tab 1: Pipeline Overview (Placeholder Only)

**Mockup has:**
- Workflow diagram: YouTube → MP4 → MP3 → Whisper → MD → Qdrant → Lessons (45/120)
- Stats cards: Stuck Files (34), Failed Files (5), Ready to Process (20)
- Recent Activity log with success/warning icons
- Buttons: View Stuck Files, Retry Failed, Automation Settings

**Current has:**
- Placeholder text only

### 2.4 Tab 2: YT-dlp & Transcription (Placeholder Only)

**Mockup has:**
- Channels table: Channel name, Videos count, Transcribed count, Progress bar, Actions
- Download Queue: Active download with progress
- Whisper Transcription: Model (large-v3), Device (CUDA GPU), Queue count
- YouTube Cookie Sync section: Last sync, Chrome profile, Cookie age, Scheduled task status

**Current has:**
- Placeholder text only

### 2.5 Tab 3: External Content (Placeholder Only)

**Mockup has:**
- Stats cards: PDFs Processed (342), HTML Pages (89), LinkedIn Posts (6), Extraction Accuracy (97.9%), Processing Queue (12)
- Upload area for PDFs/documents (Docling)
- Monitored URLs table: arXiv, Anthropic Research, OpenAI Research
- Monitored LinkedIn Profiles: Andrew Ng, Andrej Karpathy, Yann LeCun, Sam Altman, Demis Hassabis
- Processing Queue with progress

**Current has:**
- Placeholder text only

### 2.6 Tab 4: RAG System (Partially Implemented)

**Mockup has:**
- Status indicator: "Qdrant: Connected" in header
- 4 stat cards in grid: Vector Points (748K), Documents Indexed (1,182), Database Size (8.1GB), Dimensions (384)
- Semantic Search with: Query input, Limit dropdown (10/20/50/100), Min Score input (0.80), Filter dropdown (All/PDFs/YouTube/HTML)
- Search Results: File name with source type, token count, score badge, content preview, action buttons (View PDF, View MD, Open URL)
- Database Management: Collection name, Embedding model, Distance metric, Last indexed, Reindex/Clear/Statistics buttons
- Recent Queries log

**Current has:**
- Basic connection status
- Simple stats display (not cards)
- Search input + button (no Limit/MinScore/Filter options)
- Results table (basic columns)
- Full transcript modal (works)

### 2.7 Tab 5: Syllabus Manager (Placeholder Only)

**Mockup has:**
- Header buttons: Import JSON, Export CSV, Save Changes, View Backups, Ask Claude for Suggestions
- Stats cards: Total Lessons (136), Backlog Items (56), Month 1 (25), Month 2 (39), Month 3 (72)
- 4-column Kanban board: Month 1 (green), Month 2 (orange), Month 3 (red), Backlog (grey)
- Draggable lesson cards with View button
- Backup Management section
- Claude's Suggestions section with copy/paste workflow

**Current has:**
- Placeholder text only

### 2.8 Tab 6: Lesson Writer (Placeholder Only)

**Mockup has:**
- Lesson Selection dropdown
- Sub-topics list
- RAG Sources section with checkboxes, score badges, View PDF/URL buttons
- Prompt Generation textarea with Generate/Copy/Open Claude Max buttons
- Upload area for completed lessons
- Progress bar: 45/120 lessons (37.5%)

**Current has:**
- Placeholder text only

### 2.9 Tab 7: TTS Intro Video (Placeholder Only)

**Mockup has:**
- Not fully visible in my reading, but should have F5-TTS voice cloning interface

**Current has:**
- Placeholder text only

### 2.10 Tab 8: TTS Main Text (Placeholder Only)

**Mockup has:**
- Text Input textarea with Load from MD / Apply Pronunciation Rules buttons
- Kokoro Settings: Voice dropdown, Speed slider, Timestamps checkbox
- Generate TTS button
- Audio player with Download Audio / Timestamps / Both buttons

**Current has:**
- Placeholder text only

### 2.11 Tab 9: Remotion Studio (Placeholder Only)

**Mockup has:**
- Server Status indicator with Running badge
- Stop/Restart/Open in New Tab buttons
- Embedded Studio iframe placeholder
- Favorite Templates grid (4 template cards)

**Current has:**
- Placeholder text only

### 2.12 Tab 10: Export to GWTH (Placeholder Only)

**Mockup has:**
- Lesson Selection dropdown with Completeness Status (checkmarks/X for each component)
- Export Package: Format radios (Web/Local Archive), Include checkboxes, Export location, Estimated size
- Student Chatbot Vector DB: Target database radios, Index configuration checkboxes, Chunking strategy, Metadata tagging
- Export History with Re-export buttons
- Batch Export section

**Current has:**
- Placeholder text only

---

## 3. Prioritized Build Plan

### Phase 0: Fix Current Websocket Issue (IMMEDIATE)

**Goal:** Get the dashboard accessible

**Tasks:**
1. Verify `core.sio.cors_allowed_origins = '*'` fix is deployed
2. Test websocket connection from browser
3. If still failing, investigate NiceGUI version or Socket.IO configuration

**Acceptance Test:**
- [ ] No "Connection Lost" errors in browser console
- [ ] Tab navigation works
- [ ] Page doesn't auto-reload

### Phase 1: Complete RAG System Tab (Tab 4)

**Goal:** Match mockup exactly

**Tasks:**
1. Add 4 stat cards in grid layout (Vector Points, Documents, DB Size, Dimensions)
2. Add Limit dropdown (10/20/50/100)
3. Add Min Score input (0.80)
4. Add Filter dropdown (All/PDFs/YouTube/HTML)
5. Improve results display with source type badges
6. Add Database Management card with collection info
7. Add Recent Queries log

**Acceptance Tests:**
- [ ] 4 stat cards display correctly on connect
- [ ] Search respects Limit selection
- [ ] Search respects Min Score filter
- [ ] Results show source type (PDF/YouTube/HTML)
- [ ] Database Management shows collection info

### Phase 2: Add GPU Status Bar

**Goal:** Show GPU/model status across all tabs

**Tasks:**
1. Create GPU status bar component below header
2. Add GPU memory bar with percentage
3. Add model cards: Kokoro TTS, F5-TTS, Whisper, Remotion, Qdrant
4. Add Load/Unload buttons (connecting to P520 APIs)
5. Add legend

**Acceptance Tests:**
- [ ] GPU bar shows memory usage from P520
- [ ] Kokoro shows as loaded (green) when connected
- [ ] Load/Unload buttons work (or show disabled)

### Phase 3: Header & Theme Toggle

**Goal:** Match mockup header exactly

**Tasks:**
1. Add GWTH.ai logo with green accent
2. Add P520 Server status indicator
3. Add P53 Laptop status indicator
4. Add theme toggle button with sun/moon icon
5. Implement dark/light theme switching

**Acceptance Tests:**
- [ ] Logo displays correctly
- [ ] Status indicators reflect actual server status
- [ ] Theme toggle switches between dark/light themes
- [ ] Theme preference persists on reload

### Phase 4: Pipeline Overview (Tab 1)

**Goal:** Show workflow status and activity

**Tasks:**
1. Add workflow diagram (YouTube → MP4 → MP3 → Whisper → MD → Qdrant → Lessons)
2. Add stats cards (Stuck Files, Failed Files, Ready to Process)
3. Add Recent Activity log
4. Add action buttons (View Stuck, Retry Failed, Automation Settings)
5. Connect to real data from P520

**Acceptance Tests:**
- [ ] Workflow shows real counts from file system
- [ ] Stats cards reflect actual stuck/failed/ready files
- [ ] Activity log shows recent operations

### Phase 5: Syllabus Manager (Tab 5)

**Goal:** Full syllabus editing with Kanban

**Tasks:**
1. Load syllabus from JSON
2. Implement 4-column Kanban (Month 1/2/3/Backlog)
3. Add draggable lesson cards
4. Implement Import JSON / Export CSV
5. Implement Save Changes with backup
6. Add Claude Suggestions workflow

**Acceptance Tests:**
- [ ] Syllabus loads from JSON file
- [ ] Lessons display in correct month columns
- [ ] Drag-and-drop moves lessons between months
- [ ] Save creates backup and updates JSON
- [ ] Claude prompt generates correctly

### Phase 6: YT-dlp & Transcription (Tab 2)

**Goal:** Video download and transcription monitoring

**Tasks:**
1. Implement Channels table with progress
2. Add Download Queue display
3. Add Whisper status display
4. Add YouTube Cookie Sync section
5. Connect to yt-dlp/Whisper APIs on P520

**Acceptance Tests:**
- [ ] Channels table shows all channels with progress
- [ ] Download queue shows active downloads
- [ ] Whisper status shows GPU/model info
- [ ] Cookie sync shows last sync time and status

### Phase 7: External Content (Tab 3)

**Goal:** PDF/document management with Docling

**Tasks:**
1. Add stats cards
2. Implement upload area (drag-and-drop)
3. Add Monitored URLs table
4. Add Monitored LinkedIn Profiles table
5. Add Processing Queue display
6. Connect to Docling on P520

**Acceptance Tests:**
- [ ] Upload accepts PDFs and triggers Docling
- [ ] Stats reflect actual processed documents
- [ ] URL monitoring shows new documents

### Phase 8: Lesson Writer (Tab 6)

**Goal:** AI-assisted lesson generation

**Tasks:**
1. Implement Lesson Selection from syllabus
2. Show sub-topics for selected lesson
3. Integrate RAG search for relevant sources
4. Generate Claude prompt with sources
5. Implement upload for completed lessons

**Acceptance Tests:**
- [ ] Dropdown populates from syllabus
- [ ] RAG sources auto-populate based on lesson topic
- [ ] Generated prompt includes lesson details and sources
- [ ] Upload saves to correct location

### Phase 9: TTS Tabs (Tab 7 & 8)

**Goal:** Voice generation for intro and main text

**Tasks:**
1. Tab 7: F5-TTS voice cloning interface
2. Tab 8: Kokoro TTS with settings (voice, speed, timestamps)
3. Audio player with download options
4. Connect to Kokoro API (192.168.178.50:8880)

**Acceptance Tests:**
- [ ] Voice selection works
- [ ] TTS generates audio file
- [ ] Audio player works
- [ ] Timestamps export works

### Phase 10: Remotion Studio (Tab 9)

**Goal:** Embedded Remotion control

**Tasks:**
1. Add server status display
2. Add Start/Stop/Restart buttons
3. Add embedded iframe (http://localhost:3000)
4. Add Favorite Templates grid

**Acceptance Tests:**
- [ ] Server status reflects actual Remotion status
- [ ] Start/Stop buttons work
- [ ] Iframe loads Remotion Studio

### Phase 11: Export to GWTH (Tab 10)

**Goal:** Package lessons for production

**Tasks:**
1. Implement lesson selection with completeness check
2. Add export package options
3. Add Student Chatbot Vector DB section
4. Add Export History
5. Add Batch Export

**Acceptance Tests:**
- [ ] Completeness status shows accurate checks
- [ ] Export creates correct package
- [ ] Vector DB indexing works

---

## 4. Immediate Next Steps

1. **Test websocket fix** - Verify the `core.sio.cors_allowed_origins = '*'` fix resolves connection issues
2. **Complete Tab 4 (RAG System)** - Add missing features to match mockup exactly
3. **Add GPU Status Bar** - High visibility, useful across all tabs
4. **Add Header/Theme Toggle** - Complete the chrome to match mockup

---

## 5. Test Commands

```bash
# Check P520 container status
ssh p520 "cd /home/david/gwth-pipeline-v2 && docker compose ps"

# View logs
ssh p520 "cd /home/david/gwth-pipeline-v2 && docker compose logs --tail=50 dashboard"

# Rebuild and restart
ssh p520 "cd /home/david/gwth-pipeline-v2 && docker compose build dashboard && docker compose up -d"

# Test Qdrant connection from inside container
ssh p520 "docker exec gwth-pipeline-v2-dashboard-1 python -c \"
from qdrant_client import QdrantClient
c = QdrantClient(path='/data/qdrant_data')
print(c.get_collection('gwth_lessons'))
\""

# Test Kokoro API
curl http://192.168.178.50:8880/v1/audio/voices
```

---

## 6. Files to Modify

| File | Changes |
|------|---------|
| `app/gwth_dashboard.py` | All UI changes, add components |
| `app/services/qdrant_service.py` | Add min_score filter, source_type filter |
| `app/services/gpu_service.py` | NEW - GPU status monitoring |
| `app/services/kokoro_service.py` | NEW - Kokoro TTS API |
| `requirements.txt` | Add any new dependencies |
| `docker-compose.yml` | Verify volume mounts |
