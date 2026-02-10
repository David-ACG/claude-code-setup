# GWTH Pipeline V2 - PROMPT 03: Pipeline Overview Dashboard

**Phase:** 2C (Tab 1: Pipeline Overview)
**Prerequisites:** Phase 1 (Foundation) and Phase 2 (RAG System) must be completed
**Estimated Time:** 1-2 hours
**Complexity:** Low

---

## 🎯 Goal

Create a visual workflow dashboard showing the content journey from YouTube videos to generated lessons. Display live stats for each pipeline stage and recent activity log.

---

## 📋 What You're Building

### Tab 1: Pipeline Overview

**Features:**
1. Workflow visualization: YouTube → MP4 → MP3 → MD → Qdrant → Lessons
2. Status indicators for each step (✓ done, ⚡ in progress, ⚫ pending)
3. Live stats counters for each stage
4. Recent activity log (last 10 operations)
5. Auto-refresh button (updates stats on demand)

**UI Layout:**
```
┌──────────────────────────────────────────────────────┐
│  PIPELINE OVERVIEW                         [Refresh] │
├──────────────────────────────────────────────────────┤
│                                                       │
│  YouTube → MP4 → MP3 → MD → Qdrant → Lessons        │
│    ✓       ✓     ✓     ✓     ✓         ⚡           │
│   1234    1200   1200  1180  746K        95          │
│                                                       │
│  Stats:                                              │
│  • Videos Downloaded: 1,234 (86GB)                   │
│  • Transcripts Created: 1,180 (234MB)                │
│  • Documents Indexed: 746,183 points                 │
│  • Lessons Generated: 95 / 120 (79%)                 │
│                                                       │
│  Recent Activity:                                    │
│  • 2 min ago: Transcribed "AI Agents Explained.mp4"  │
│  • 5 min ago: Indexed "Docker Tutorial.md"           │
│  • 12 min ago: Generated "Lesson 96: Transformers"   │
│                                                       │
└──────────────────────────────────────────────────────┘
```

---

## 🏗️ Architecture

**Data Sources:**
- Videos: Count `.mp4` files in `/data/GWTH-YT-Vids/`
- MP3s: Count `.mp3` files in `/data/GWTH-YT-Vids/`
- Transcripts: Count `.md` files in `/data/GWTH-YT-Vids/**/*.md`
- Qdrant: Query `qdrant_service.get_stats()` (from Phase 2)
- Lessons: Count `.md` files in `/data/generated_lessons/`

**Activity Log:**
- Read from activity log file: `/data/data/activity_log.json`
- If doesn't exist, show placeholder: "No recent activity"

---

## 🔧 Implementation Steps

### Step 1: Create Pipeline Stats Service

**File:** `app/services/pipeline_service.py`

```python
"""Pipeline statistics and activity tracking service."""
from pathlib import Path
from typing import Dict, List
import json
from datetime import datetime
import logging

logger = logging.getLogger(__name__)


class PipelineService:
    """Service for collecting pipeline statistics."""

    def __init__(self, data_path: Path):
        """
        Initialize pipeline service.

        Args:
            data_path: Base data path (e.g., /data/)
        """
        self.data_path = data_path
        self.vids_path = data_path / "GWTH-YT-Vids"
        self.lessons_path = data_path / "generated_lessons"
        self.activity_log_path = data_path / "data" / "activity_log.json"

    def get_stats(self) -> Dict:
        """
        Collect pipeline statistics from filesystem.

        Returns:
            Dict with video_count, mp3_count, transcript_count, lessons_count, etc.
        """
        try:
            stats = {
                "videos": 0,
                "mp3s": 0,
                "transcripts": 0,
                "lessons": 0,
                "video_size_gb": 0.0,
                "transcript_size_mb": 0.0,
            }

            # Count videos (.mp4 files)
            if self.vids_path.exists():
                mp4_files = list(self.vids_path.glob("**/*.mp4"))
                stats["videos"] = len(mp4_files)

                # Calculate total size
                total_bytes = sum(f.stat().st_size for f in mp4_files if f.exists())
                stats["video_size_gb"] = round(total_bytes / (1024 ** 3), 2)

            # Count MP3s
            if self.vids_path.exists():
                mp3_files = list(self.vids_path.glob("**/*.mp3"))
                stats["mp3s"] = len(mp3_files)

            # Count transcripts (.md files in GWTH-YT-Vids)
            if self.vids_path.exists():
                md_files = list(self.vids_path.glob("**/*.md"))
                stats["transcripts"] = len(md_files)

                # Calculate total size
                total_bytes = sum(f.stat().st_size for f in md_files if f.exists())
                stats["transcript_size_mb"] = round(total_bytes / (1024 ** 2), 2)

            # Count lessons
            if self.lessons_path.exists():
                lesson_files = list(self.lessons_path.glob("lesson_*.md"))
                stats["lessons"] = len(lesson_files)

            logger.info(f"Pipeline stats: {stats}")
            return stats

        except Exception as e:
            logger.error(f"Failed to get pipeline stats: {e}")
            return {}

    def get_recent_activity(self, limit: int = 10) -> List[Dict]:
        """
        Get recent activity log entries.

        Args:
            limit: Maximum number of entries to return (default: 10)

        Returns:
            List of activity dicts with timestamp, action, description
        """
        try:
            if not self.activity_log_path.exists():
                logger.warning("Activity log file does not exist")
                return []

            with open(self.activity_log_path, 'r', encoding='utf-8') as f:
                activity_log = json.load(f)

            # Get last N entries
            recent = activity_log[-limit:] if len(activity_log) > limit else activity_log

            # Reverse so newest is first
            recent.reverse()

            return recent

        except Exception as e:
            logger.error(f"Failed to read activity log: {e}")
            return []

    def log_activity(self, action: str, description: str):
        """
        Add entry to activity log.

        Args:
            action: Action type (e.g., "download", "transcribe", "index", "generate")
            description: Human-readable description
        """
        try:
            # Ensure directory exists
            self.activity_log_path.parent.mkdir(parents=True, exist_ok=True)

            # Load existing log
            if self.activity_log_path.exists():
                with open(self.activity_log_path, 'r', encoding='utf-8') as f:
                    activity_log = json.load(f)
            else:
                activity_log = []

            # Add new entry
            entry = {
                "timestamp": datetime.now().isoformat(),
                "action": action,
                "description": description
            }
            activity_log.append(entry)

            # Keep only last 100 entries
            if len(activity_log) > 100:
                activity_log = activity_log[-100:]

            # Save
            with open(self.activity_log_path, 'w', encoding='utf-8') as f:
                json.dump(activity_log, f, indent=2, ensure_ascii=False)

            logger.info(f"Activity logged: {action} - {description}")

        except Exception as e:
            logger.error(f"Failed to log activity: {e}")
```

**Key Features:**
- Counts files in each pipeline stage
- Calculates sizes (GB for videos, MB for transcripts)
- Reads activity log from JSON file
- Provides `log_activity()` for other tabs to record operations

---

### Step 2: Update Dashboard - Add Tab 1 Content

**File:** `app/gwth_dashboard.py`

Add import:

```python
from app.services.pipeline_service import PipelineService
```

Initialize service in `__init__`:

```python
class GWTHDashboard:
    def __init__(self):
        # ... existing code ...

        # Pipeline service
        self.pipeline_service = PipelineService(Config.DATA_PATH)
        self.pipeline_stats = {}
        self.recent_activity = []
```

Replace Tab 1 placeholder with full implementation:

```python
def create_tab_pipeline(self):
    """Tab 1: Pipeline Overview"""
    with ui.column().classes('w-full gap-4'):
        # Header with refresh button
        with ui.row().classes('w-full justify-between items-center'):
            ui.label('Pipeline Overview').classes('text-xl font-bold')
            ui.button(
                'Refresh',
                on_click=self.refresh_pipeline_stats,
                icon='refresh'
            ).props('outline')

        # Workflow visualization
        with ui.card().classes('w-full'):
            ui.label('Content Pipeline').classes('text-lg font-semibold')

            # Workflow steps
            with ui.row().classes('w-full items-center justify-around text-center'):
                # YouTube
                with ui.column().classes('items-center'):
                    ui.icon('video_library', size='lg').classes('text-primary')
                    ui.label('YouTube').classes('font-semibold')
                    self.pipe_youtube_status = ui.label('✓').classes('text-2xl text-green-600')
                    self.pipe_youtube_count = ui.label('0').classes('text-sm')

                ui.icon('arrow_forward', size='sm').classes('text-gray-400')

                # MP4
                with ui.column().classes('items-center'):
                    ui.icon('movie', size='lg').classes('text-primary')
                    ui.label('MP4').classes('font-semibold')
                    self.pipe_mp4_status = ui.label('✓').classes('text-2xl text-green-600')
                    self.pipe_mp4_count = ui.label('0').classes('text-sm')

                ui.icon('arrow_forward', size='sm').classes('text-gray-400')

                # MP3
                with ui.column().classes('items-center'):
                    ui.icon('audiotrack', size='lg').classes('text-primary')
                    ui.label('MP3').classes('font-semibold')
                    self.pipe_mp3_status = ui.label('✓').classes('text-2xl text-green-600')
                    self.pipe_mp3_count = ui.label('0').classes('text-sm')

                ui.icon('arrow_forward', size='sm').classes('text-gray-400')

                # Transcripts (MD)
                with ui.column().classes('items-center'):
                    ui.icon('description', size='lg').classes('text-primary')
                    ui.label('Transcripts').classes('font-semibold')
                    self.pipe_md_status = ui.label('✓').classes('text-2xl text-green-600')
                    self.pipe_md_count = ui.label('0').classes('text-sm')

                ui.icon('arrow_forward', size='sm').classes('text-gray-400')

                # Qdrant
                with ui.column().classes('items-center'):
                    ui.icon('search', size='lg').classes('text-primary')
                    ui.label('Qdrant').classes('font-semibold')
                    self.pipe_qdrant_status = ui.label('✓').classes('text-2xl text-green-600')
                    self.pipe_qdrant_count = ui.label('0').classes('text-sm')

                ui.icon('arrow_forward', size='sm').classes('text-gray-400')

                # Lessons
                with ui.column().classes('items-center'):
                    ui.icon('school', size='lg').classes('text-primary')
                    ui.label('Lessons').classes('font-semibold')
                    self.pipe_lessons_status = ui.label('⚡').classes('text-2xl text-yellow-600')
                    self.pipe_lessons_count = ui.label('0 / 120').classes('text-sm')

        # Stats card
        with ui.card().classes('w-full'):
            ui.label('Statistics').classes('text-lg font-semibold')

            with ui.column().classes('gap-2'):
                self.pipe_stats_videos = ui.label('• Videos Downloaded: 0 (0 GB)').classes('text-sm')
                self.pipe_stats_transcripts = ui.label('• Transcripts Created: 0 (0 MB)').classes('text-sm')
                self.pipe_stats_indexed = ui.label('• Documents Indexed: 0 points').classes('text-sm')
                self.pipe_stats_lessons = ui.label('• Lessons Generated: 0 / 120 (0%)').classes('text-sm')

        # Recent activity
        with ui.card().classes('w-full'):
            ui.label('Recent Activity').classes('text-lg font-semibold')

            self.pipe_activity_column = ui.column().classes('gap-1')
            with self.pipe_activity_column:
                ui.label('No recent activity').classes('text-sm text-gray-500')

        # Load initial stats
        self.refresh_pipeline_stats()


    async def refresh_pipeline_stats(self):
        """Refresh pipeline statistics."""
        ui.notify('Refreshing stats...', type='info')

        # Get filesystem stats
        self.pipeline_stats = self.pipeline_service.get_stats()

        # Get Qdrant stats (if connected from Phase 2)
        qdrant_stats = {}
        if hasattr(self, 'qdrant_service') and self.qdrant_connected:
            qdrant_stats = self.qdrant_service.get_stats()

        # Update workflow counts
        self.pipe_youtube_count.text = str(self.pipeline_stats.get('videos', 0))
        self.pipe_mp4_count.text = str(self.pipeline_stats.get('videos', 0))
        self.pipe_mp3_count.text = str(self.pipeline_stats.get('mp3s', 0))
        self.pipe_md_count.text = str(self.pipeline_stats.get('transcripts', 0))

        # Qdrant count
        qdrant_points = qdrant_stats.get('points', 0)
        if qdrant_points > 1000:
            self.pipe_qdrant_count.text = f"{qdrant_points // 1000}K"
        else:
            self.pipe_qdrant_count.text = str(qdrant_points)

        # Lessons count
        lessons_count = self.pipeline_stats.get('lessons', 0)
        lessons_pct = int((lessons_count / 120) * 100) if lessons_count > 0 else 0
        self.pipe_lessons_count.text = f"{lessons_count} / 120"

        # Update status indicators
        # YouTube: ✓ if any videos exist
        if self.pipeline_stats.get('videos', 0) > 0:
            self.pipe_youtube_status.text = '✓'
            self.pipe_youtube_status.classes('text-green-600', remove='text-gray-400')
        else:
            self.pipe_youtube_status.text = '⚫'
            self.pipe_youtube_status.classes('text-gray-400', remove='text-green-600')

        # Lessons: ⚡ (in progress) if < 120, ✓ if complete
        if lessons_count >= 120:
            self.pipe_lessons_status.text = '✓'
            self.pipe_lessons_status.classes('text-green-600', remove='text-yellow-600')
        else:
            self.pipe_lessons_status.text = '⚡'
            self.pipe_lessons_status.classes('text-yellow-600', remove='text-green-600')

        # Update stats text
        self.pipe_stats_videos.text = f"• Videos Downloaded: {self.pipeline_stats.get('videos', 0):,} ({self.pipeline_stats.get('video_size_gb', 0)} GB)"
        self.pipe_stats_transcripts.text = f"• Transcripts Created: {self.pipeline_stats.get('transcripts', 0):,} ({self.pipeline_stats.get('transcript_size_mb', 0)} MB)"
        self.pipe_stats_indexed.text = f"• Documents Indexed: {qdrant_points:,} points"
        self.pipe_stats_lessons.text = f"• Lessons Generated: {lessons_count} / 120 ({lessons_pct}%)"

        # Update recent activity
        self.recent_activity = self.pipeline_service.get_recent_activity(limit=10)

        self.pipe_activity_column.clear()
        with self.pipe_activity_column:
            if self.recent_activity:
                for activity in self.recent_activity:
                    # Parse timestamp
                    ts = datetime.fromisoformat(activity['timestamp'])
                    now = datetime.now()
                    diff = now - ts

                    # Format time ago
                    if diff.total_seconds() < 60:
                        time_ago = "just now"
                    elif diff.total_seconds() < 3600:
                        time_ago = f"{int(diff.total_seconds() / 60)} min ago"
                    elif diff.total_seconds() < 86400:
                        time_ago = f"{int(diff.total_seconds() / 3600)} hr ago"
                    else:
                        time_ago = f"{int(diff.total_seconds() / 86400)} days ago"

                    ui.label(f"• {time_ago}: {activity['description']}").classes('text-sm')
            else:
                ui.label('No recent activity').classes('text-sm text-gray-500')

        ui.notify('Stats refreshed', type='positive')
```

**Add import for datetime at top:**

```python
from datetime import datetime
```

---

## 🧪 Acceptance Criteria

### 1. Workflow Visualization
- [ ] All 6 stages display: YouTube → MP4 → MP3 → MD → Qdrant → Lessons
- [ ] Each stage has icon, label, status, count
- [ ] Status indicators: ✓ (green) if has data, ⚫ (gray) if empty
- [ ] Lessons stage shows ⚡ (yellow) until 120 complete

### 2. Stats Display
- [ ] Videos count and size (GB) match actual files
- [ ] Transcripts count and size (MB) match actual files
- [ ] Qdrant points match database (746K on P520)
- [ ] Lessons show X / 120 with percentage

### 3. Recent Activity
- [ ] Shows last 10 activity entries
- [ ] Displays "X min ago" / "X hr ago" / "X days ago"
- [ ] If no activity log file → shows "No recent activity"

### 4. Refresh Button
- [ ] Click "Refresh" → stats update
- [ ] Shows notification "Refreshing stats..." then "Stats refreshed"
- [ ] Counts match filesystem state

### 5. Integration with Phase 2
- [ ] Qdrant count pulls from `qdrant_service.get_stats()`
- [ ] If Qdrant not connected → shows 0 points

---

## 🚀 Testing Locally (P53)

```bash
# Build and run
docker build -t gwth-dashboard:test .
docker run -p 8088:8088 \
  -v /c/Projects/gwthpipeline520:/data \
  gwth-dashboard:test

# Open browser
start http://localhost:8088

# Navigate to Tab 1: Pipeline Overview
# Click "Refresh" button
# Verify counts match your local data
```

**Expected on P53:**
- Videos: Count of MP4 files (if any)
- Transcripts: Count of MD files
- Lessons: Count in `generated_lessons/` folder
- Activity: Empty or previous entries

---

## 📦 Deployment to P520

```bash
# Commit changes
git add app/services/pipeline_service.py app/gwth_dashboard.py
git commit -m "Phase 2C: Add Pipeline Overview tab (Tab 1)

- PipelineService for stats collection
- Tab 1 UI with workflow visualization
- Live stats counters for each stage
- Recent activity log (last 10 entries)
- Auto-refresh button

Acceptance tests:
✓ Workflow displays all 6 stages
✓ Stats match filesystem (videos, transcripts, lessons)
✓ Qdrant count from database (746K points)
✓ Recent activity shows last 10 operations
✓ Refresh button updates stats
"
git push

# Deploy to P520
ssh p520
cd /home/david/gwth-pipeline-v2
git pull
coolify deploy --app gwth-dashboard

# Check logs
docker logs gwth-dashboard
```

---

## 🐛 Troubleshooting

### "Stats show 0 for everything"
```bash
# Check volume mounts
docker inspect gwth-dashboard | grep Mounts -A 20

# Should see: /home/david/gwth-dashboard/ → /data/
```

**Fix:** Verify docker-compose.yml has correct volume mount.

### "Qdrant count is 0"
- Tab 4 (RAG System) must be connected first
- Click "Connect to Qdrant" in Tab 4
- Then refresh Tab 1

### "Activity log doesn't display"
- Activity log file: `/data/data/activity_log.json`
- If doesn't exist → shows "No recent activity" (expected)
- Future tabs will populate this log

---

## 📝 Next Steps

After Phase 2C is complete:

**Next:** Phase 3 (PROMPT_04) - YT-dlp & Transcription (Tab 2)

**Then:** Phase 5 (PROMPT_05) - Syllabus Manager (Tab 5) - CRITICAL

---

## 🎯 Success Checklist

- [ ] PipelineService created with get_stats(), get_recent_activity(), log_activity()
- [ ] Tab 1 displays workflow with 6 stages
- [ ] Stats show accurate counts from filesystem
- [ ] Qdrant count integrates with Phase 2
- [ ] Recent activity displays (or "No recent activity")
- [ ] Refresh button works
- [ ] Tested locally
- [ ] Committed to git
- [ ] Deployed to P520
- [ ] Verified stats on P520 match actual data

**Ready for Phase 3!** 🚀
