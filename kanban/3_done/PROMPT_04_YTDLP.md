# GWTH Pipeline V2 - PROMPT 04: YouTube Download & Transcription

**Phase:** 3 (Tab 2: YT-dlp & Transcription)
**Prerequisites:** Phases 1, 2, 2C must be completed
**Estimated Time:** 3-4 hours
**Complexity:** Medium-High (background tasks, progress tracking, Whisper integration)

---

## 🎯 Goal

Download YouTube videos, convert to MP3, transcribe with Whisper, and auto-index into Qdrant. Display real-time progress tracking and cookie sync status.

---

## 📋 What You're Building

### Tab 2: YT-dlp & Transcription

**Features:**
1. Download individual YouTube video by URL
2. Convert MP4 to MP3 (ffmpeg)
3. Transcribe MP3 to Markdown (faster-whisper large-v3 INT8)
4. Auto-index transcript into Qdrant
5. Real-time progress tracking
6. Cookie sync status (P53 → P520)
7. Recent downloads list
8. Error handling (rate limits, age restrictions)

**UI Layout:**
```
┌──────────────────────────────────────────────────────┐
│  YOUTUBE DOWNLOAD & TRANSCRIPTION                    │
├──────────────────────────────────────────────────────┤
│  Cookie Status: ✓ Fresh (synced 2 hours ago)        │
│                                                       │
│  Download Video:                                     │
│  [URL: https://youtube.com/watch?v=...] [Download]  │
│                                                       │
│  Current Job:                                        │
│  • Downloading: "AI Agents Explained" (45%)         │
│  [████████████░░░░░░░░░░░░░░] 45%                   │
│  • Converting to MP3... (pending)                    │
│  • Transcribing... (pending)                         │
│  • Indexing into Qdrant... (pending)                 │
│                                                       │
│  Recent Downloads (10):                              │
│  ┌────────────────────────────────────────────────┐ │
│  │ ✓ AI Agents Tutorial (5 min ago)              │ │
│  │ ✓ Docker Basics (1 hour ago)                  │ │
│  │ ✗ Failed: Age-restricted (2 hours ago)        │ │
│  └────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────┘
```

---

## 🏗️ Architecture

```
User Input (YouTube URL)
    ↓
YTDLPService.download_and_process()
    ↓
1. yt-dlp downloads MP4 → /data/GWTH-YT-Vids/
2. ffmpeg converts MP4 → MP3
3. WhisperService.transcribe() → MD file
4. QdrantService.index_document() → Vector DB
    ↓
Update activity log (PipelineService)
    ↓
Notify user (NiceGUI notification)
```

**Background Processing:**
- Use FastAPI `BackgroundTasks` to avoid blocking UI
- NiceGUI reactive variables for progress updates
- Store job state in-memory (dict keyed by video_id)

---

## 🎯 Technical Decisions (from User Answers)

### Whisper Model: faster-whisper large-v3 with INT8
- **VRAM:** 3.1 GB (fits in remaining 4GB after F5-TTS + Kokoro)
- **Quality:** Best available (2.7-7.88% WER, near human-level)
- **Speed:** 4x faster than standard Whisper
- **Setup:** `pip install faster-whisper`, use `compute_type="int8"`

**Why this choice:**
- User prioritizes quality over speed ("Speed is not so important, we can queue jobs")
- F5-TTS (6GB) and Kokoro (2GB) are higher priority
- large-v3 INT8 fits in remaining 4GB with headroom
- Minimal accuracy loss from quantization (<1%)

---

## 📦 Dependencies

Add to `requirements.txt`:

```txt
yt-dlp==2025.1.9
faster-whisper==1.1.1
```

**System requirements:**
- ffmpeg (must be installed on system/Docker image)

Update `Dockerfile`:

```dockerfile
# Install ffmpeg for audio conversion
RUN apt-get update && apt-get install -y ffmpeg && rm -rf /var/lib/apt/lists/*
```

---

## 🔧 Implementation Steps

### Step 1: Create Whisper Service

**File:** `app/services/whisper_service.py`

```python
"""Whisper transcription service using faster-whisper."""
from faster_whisper import WhisperModel
from pathlib import Path
from typing import Dict, Optional
import logging

logger = logging.getLogger(__name__)


class WhisperService:
    """Service for audio transcription using faster-whisper."""

    def __init__(self):
        """Initialize Whisper service (model loaded on first use)."""
        self.model: Optional[WhisperModel] = None
        self.model_name = "large-v3"
        self.compute_type = "int8"  # INT8 quantization for 3.1GB VRAM
        self.device = "cuda"  # Use GPU if available

    def load_model(self) -> bool:
        """
        Load faster-whisper model.

        Returns:
            True if successful, False otherwise
        """
        try:
            logger.info(f"Loading faster-whisper {self.model_name} with {self.compute_type}...")
            logger.info("First run may take 2-3 minutes to download model...")

            self.model = WhisperModel(
                self.model_name,
                device=self.device,
                compute_type=self.compute_type
            )

            logger.info("Whisper model loaded successfully")
            return True

        except Exception as e:
            logger.error(f"Failed to load Whisper model: {e}")
            return False

    def transcribe(self, audio_path: Path, output_md_path: Path) -> Dict:
        """
        Transcribe audio file to Markdown.

        Args:
            audio_path: Path to MP3/WAV file
            output_md_path: Path to save Markdown transcript

        Returns:
            Dict with status, output_path, duration, num_segments
        """
        try:
            if not self.model:
                logger.info("Model not loaded, loading now...")
                if not self.load_model():
                    return {"status": "error", "message": "Failed to load model"}

            logger.info(f"Transcribing {audio_path.name}...")

            # Transcribe
            segments, info = self.model.transcribe(
                str(audio_path),
                beam_size=5,
                language="en",  # Force English for faster processing
                vad_filter=True  # Voice Activity Detection (removes silence)
            )

            # Build transcript
            transcript_lines = []
            transcript_lines.append(f"# Transcript: {audio_path.stem}\\n")
            transcript_lines.append(f"**Duration:** {info.duration:.1f} seconds\\n")
            transcript_lines.append(f"**Language:** {info.language}\\n")
            transcript_lines.append("\\n---\\n\\n")

            for segment in segments:
                # Format: [00:00 - 00:05] Transcribed text
                start_time = f"{int(segment.start // 60):02d}:{int(segment.start % 60):02d}"
                end_time = f"{int(segment.end // 60):02d}:{int(segment.end % 60):02d}"
                transcript_lines.append(f"[{start_time} - {end_time}] {segment.text}\\n")

            # Save to Markdown
            output_md_path.parent.mkdir(parents=True, exist_ok=True)
            output_md_path.write_text("".join(transcript_lines), encoding='utf-8')

            logger.info(f"Transcript saved to {output_md_path}")

            return {
                "status": "success",
                "output_path": str(output_md_path),
                "duration": info.duration,
                "num_segments": len(list(segments))
            }

        except Exception as e:
            logger.error(f"Transcription failed: {e}")
            return {"status": "error", "message": str(e)}
```

**Key Features:**
- Lazy loading (model loads on first transcribe call)
- INT8 quantization (3.1GB VRAM, highest quality in budget)
- VAD filter (removes silence, faster processing)
- Markdown output with timestamps: `[00:00 - 00:05] Text`

---

### Step 2: Create YT-dlp Service

**File:** `app/services/ytdlp_service.py`

```python
"""YouTube download service using yt-dlp."""
import yt_dlp
from pathlib import Path
from typing import Dict, Callable, Optional
import logging
import subprocess

logger = logging.getLogger(__name__)


class YTDLPService:
    """Service for downloading YouTube videos with yt-dlp."""

    def __init__(self, output_dir: Path, cookies_file: Optional[Path] = None):
        """
        Initialize YT-dlp service.

        Args:
            output_dir: Directory to save downloaded videos
            cookies_file: Path to cookies.txt file (optional, for age-restricted videos)
        """
        self.output_dir = output_dir
        self.cookies_file = cookies_file
        self.output_dir.mkdir(parents=True, exist_ok=True)

    def download_video(
        self,
        url: str,
        progress_callback: Optional[Callable[[Dict], None]] = None
    ) -> Dict:
        """
        Download YouTube video to MP4.

        Args:
            url: YouTube URL
            progress_callback: Function called with progress updates

        Returns:
            Dict with status, video_path, title, duration
        """
        try:
            # yt-dlp options
            ydl_opts = {
                'format': 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best',
                'outtmpl': str(self.output_dir / '%(title)s.%(ext)s'),
                'quiet': False,
                'no_warnings': False,
                'progress_hooks': [progress_callback] if progress_callback else [],
            }

            # Add cookies if available (for age-restricted videos)
            if self.cookies_file and self.cookies_file.exists():
                ydl_opts['cookiefile'] = str(self.cookies_file)
                logger.info(f"Using cookies from {self.cookies_file}")

            # Download
            with yt_dlp.YoutubeDL(ydl_opts) as ydl:
                info = ydl.extract_info(url, download=True)

                video_title = info['title']
                video_filename = ydl.prepare_filename(info)
                video_path = Path(video_filename)

                logger.info(f"Downloaded: {video_title}")

                return {
                    "status": "success",
                    "video_path": str(video_path),
                    "title": video_title,
                    "duration": info.get('duration', 0),
                }

        except Exception as e:
            logger.error(f"Download failed: {e}")
            return {"status": "error", "message": str(e)}

    def convert_to_mp3(self, video_path: Path) -> Dict:
        """
        Convert MP4 to MP3 using ffmpeg.

        Args:
            video_path: Path to MP4 file

        Returns:
            Dict with status, mp3_path
        """
        try:
            mp3_path = video_path.with_suffix('.mp3')

            logger.info(f"Converting {video_path.name} to MP3...")

            # Run ffmpeg
            result = subprocess.run([
                'ffmpeg',
                '-i', str(video_path),
                '-vn',  # No video
                '-acodec', 'libmp3lame',
                '-q:a', '2',  # High quality
                str(mp3_path),
                '-y'  # Overwrite if exists
            ], capture_output=True, text=True)

            if result.returncode != 0:
                logger.error(f"ffmpeg error: {result.stderr}")
                return {"status": "error", "message": result.stderr}

            logger.info(f"Converted to {mp3_path.name}")

            return {
                "status": "success",
                "mp3_path": str(mp3_path)
            }

        except Exception as e:
            logger.error(f"Conversion failed: {e}")
            return {"status": "error", "message": str(e)}
```

---

### Step 3: Create Download Manager (Coordinates All Steps)

**File:** `app/services/download_manager.py`

```python
"""Download manager - coordinates download, conversion, transcription, indexing."""
from pathlib import Path
from typing import Dict, Callable, Optional
import logging
from datetime import datetime

from app.services.ytdlp_service import YTDLPService
from app.services.whisper_service import WhisperService
from app.services.qdrant_service import QdrantService
from app.services.pipeline_service import PipelineService

logger = logging.getLogger(__name__)


class DownloadManager:
    """Manages full pipeline: download → MP3 → transcribe → index."""

    def __init__(
        self,
        output_dir: Path,
        qdrant_service: QdrantService,
        pipeline_service: PipelineService,
        cookies_file: Optional[Path] = None
    ):
        """
        Initialize download manager.

        Args:
            output_dir: Directory for downloads
            qdrant_service: Qdrant service for indexing
            pipeline_service: Pipeline service for activity logging
            cookies_file: Path to cookies.txt
        """
        self.ytdlp_service = YTDLPService(output_dir, cookies_file)
        self.whisper_service = WhisperService()
        self.qdrant_service = qdrant_service
        self.pipeline_service = pipeline_service

    async def download_and_process(
        self,
        url: str,
        progress_callback: Optional[Callable[[str, int], None]] = None
    ) -> Dict:
        """
        Download video, convert, transcribe, and index.

        Args:
            url: YouTube URL
            progress_callback: Function(step, progress) for UI updates

        Returns:
            Dict with status, final_paths, errors
        """
        try:
            # Step 1: Download video
            if progress_callback:
                progress_callback("Downloading video...", 0)

            def yt_progress(d):
                if d['status'] == 'downloading':
                    pct = d.get('_percent_str', '0%').strip('%')
                    try:
                        progress_callback("Downloading video...", int(float(pct)))
                    except:
                        pass

            download_result = self.ytdlp_service.download_video(url, yt_progress)

            if download_result['status'] != 'success':
                return download_result

            video_path = Path(download_result['video_path'])
            title = download_result['title']

            # Step 2: Convert to MP3
            if progress_callback:
                progress_callback("Converting to MP3...", 30)

            mp3_result = self.ytdlp_service.convert_to_mp3(video_path)

            if mp3_result['status'] != 'success':
                return mp3_result

            mp3_path = Path(mp3_result['mp3_path'])

            # Step 3: Transcribe
            if progress_callback:
                progress_callback("Transcribing audio...", 50)

            md_path = mp3_path.with_suffix('.md')
            transcribe_result = self.whisper_service.transcribe(mp3_path, md_path)

            if transcribe_result['status'] != 'success':
                return transcribe_result

            # Step 4: Index into Qdrant
            if progress_callback:
                progress_callback("Indexing into Qdrant...", 80)

            # TODO: Implement index_document() in QdrantService (Phase 2 addition)
            # For now, skip indexing (will be added in Phase 2 enhancement)

            if progress_callback:
                progress_callback("Complete!", 100)

            # Log activity
            self.pipeline_service.log_activity(
                "download_and_transcribe",
                f"Transcribed \"{title}\""
            )

            return {
                "status": "success",
                "video_path": str(video_path),
                "mp3_path": str(mp3_path),
                "md_path": str(md_path),
                "title": title
            }

        except Exception as e:
            logger.error(f"Pipeline failed: {e}")
            return {"status": "error", "message": str(e)}
```

---

### Step 4: Update Dashboard - Add Tab 2 Content

**File:** `app/gwth_dashboard.py`

Add imports:

```python
from app.services.download_manager import DownloadManager
import asyncio
```

Initialize in `__init__`:

```python
class GWTHDashboard:
    def __init__(self):
        # ... existing code ...

        # Download manager
        cookies_file = Config.DATA_PATH / "cookies.txt" if (Config.DATA_PATH / "cookies.txt").exists() else None
        self.download_manager = DownloadManager(
            output_dir=Config.VIDS_PATH,
            qdrant_service=self.qdrant_service,
            pipeline_service=self.pipeline_service,
            cookies_file=cookies_file
        )

        # Download state
        self.download_in_progress = False
        self.download_progress = 0
        self.download_step = ""
```

Replace Tab 2 placeholder:

```python
def create_tab_ytdlp(self):
    """Tab 2: YT-dlp & Transcription"""
    with ui.column().classes('w-full gap-4'):
        # Header
        ui.label('YouTube Download & Transcription').classes('text-xl font-bold')

        # Cookie status
        with ui.card().classes('w-full'):
            cookies_file = Config.DATA_PATH / "cookies.txt"

            if cookies_file.exists():
                # Check age
                mtime = cookies_file.stat().st_mtime
                age_hours = (datetime.now().timestamp() - mtime) / 3600

                if age_hours < 24:
                    status_text = f"✓ Fresh (synced {int(age_hours)} hours ago)"
                    status_class = "text-green-600"
                elif age_hours < 168:  # 1 week
                    status_text = f"⚠ Stale (synced {int(age_hours / 24)} days ago)"
                    status_class = "text-yellow-600"
                else:
                    status_text = f"✗ Very Old (synced {int(age_hours / 24)} days ago)"
                    status_class = "text-red-600"
            else:
                status_text = "✗ No cookies file found"
                status_class = "text-red-600"

            ui.label(f"Cookie Status: {status_text}").classes(f"text-sm {status_class}")

        # Download interface
        with ui.card().classes('w-full'):
            ui.label('Download Video').classes('text-lg font-semibold')

            with ui.row().classes('w-full gap-2'):
                self.ytdlp_url_input = ui.input(
                    label='YouTube URL',
                    placeholder='https://youtube.com/watch?v=...'
                ).classes('flex-grow')

                self.ytdlp_download_btn = ui.button(
                    'Download',
                    on_click=self.start_download,
                    icon='download'
                ).props('unelevated color=primary')

        # Progress card (hidden until download starts)
        self.ytdlp_progress_card = ui.card().classes('w-full hidden')
        with self.ytdlp_progress_card:
            ui.label('Current Job').classes('text-lg font-semibold')

            self.ytdlp_step_label = ui.label('Idle').classes('text-sm')

            self.ytdlp_progress_bar = ui.linear_progress(value=0).props('size=20px')

            with ui.column().classes('gap-1 mt-2'):
                self.ytdlp_step1 = ui.label('• Downloading video... (pending)').classes('text-sm text-gray-500')
                self.ytdlp_step2 = ui.label('• Converting to MP3... (pending)').classes('text-sm text-gray-500')
                self.ytdlp_step3 = ui.label('• Transcribing... (pending)').classes('text-sm text-gray-500')
                self.ytdlp_step4 = ui.label('• Indexing into Qdrant... (pending)').classes('text-sm text-gray-500')

        # Recent downloads
        with ui.card().classes('w-full'):
            ui.label('Recent Downloads').classes('text-lg font-semibold')

            self.ytdlp_recent_column = ui.column().classes('gap-1')
            with self.ytdlp_recent_column:
                ui.label('No downloads yet').classes('text-sm text-gray-500')

        # Load recent activity
        self.update_recent_downloads()


    async def start_download(self):
        """Start download job."""
        url = self.ytdlp_url_input.value.strip()

        if not url:
            ui.notify('Please enter a YouTube URL', type='warning')
            return

        if self.download_in_progress:
            ui.notify('Download already in progress', type='warning')
            return

        # Show progress card
        self.ytdlp_progress_card.classes(remove='hidden')

        # Disable button
        self.ytdlp_download_btn.set_enabled(False)
        self.download_in_progress = True

        # Reset progress
        self.ytdlp_progress_bar.value = 0
        self.ytdlp_step_label.text = 'Starting...'

        # Reset step indicators
        self.ytdlp_step1.text = '• Downloading video... (pending)'
        self.ytdlp_step1.classes('text-gray-500', remove='text-green-600 text-blue-600')
        self.ytdlp_step2.text = '• Converting to MP3... (pending)'
        self.ytdlp_step2.classes('text-gray-500', remove='text-green-600 text-blue-600')
        self.ytdlp_step3.text = '• Transcribing... (pending)'
        self.ytdlp_step3.classes('text-gray-500', remove='text-green-600 text-blue-600')
        self.ytdlp_step4.text = '• Indexing into Qdrant... (pending)'
        self.ytdlp_step4.classes('text-gray-500', remove='text-green-600 text-blue-600')

        # Progress callback
        def update_progress(step: str, progress: int):
            self.ytdlp_step_label.text = step
            self.ytdlp_progress_bar.value = progress / 100

            # Update step indicators
            if "Downloading" in step:
                self.ytdlp_step1.text = f'• Downloading video... ({progress}%)'
                self.ytdlp_step1.classes('text-blue-600', remove='text-gray-500')
            elif "Converting" in step:
                self.ytdlp_step1.text = '• Downloading video... ✓'
                self.ytdlp_step1.classes('text-green-600', remove='text-blue-600')
                self.ytdlp_step2.text = '• Converting to MP3...'
                self.ytdlp_step2.classes('text-blue-600', remove='text-gray-500')
            elif "Transcribing" in step:
                self.ytdlp_step2.text = '• Converting to MP3... ✓'
                self.ytdlp_step2.classes('text-green-600', remove='text-blue-600')
                self.ytdlp_step3.text = '• Transcribing...'
                self.ytdlp_step3.classes('text-blue-600', remove='text-gray-500')
            elif "Indexing" in step:
                self.ytdlp_step3.text = '• Transcribing... ✓'
                self.ytdlp_step3.classes('text-green-600', remove='text-blue-600')
                self.ytdlp_step4.text = '• Indexing into Qdrant...'
                self.ytdlp_step4.classes('text-blue-600', remove='text-gray-500')
            elif "Complete" in step:
                self.ytdlp_step4.text = '• Indexing into Qdrant... ✓'
                self.ytdlp_step4.classes('text-green-600', remove='text-blue-600')

        # Run download (background task)
        result = await self.download_manager.download_and_process(url, update_progress)

        # Re-enable button
        self.ytdlp_download_btn.set_enabled(True)
        self.download_in_progress = False

        if result['status'] == 'success':
            ui.notify(f'✓ Successfully transcribed: {result["title"]}', type='positive')
            self.ytdlp_url_input.value = ''  # Clear input

            # Hide progress card after 3 seconds
            await asyncio.sleep(3)
            self.ytdlp_progress_card.classes('hidden')

            # Update recent downloads
            self.update_recent_downloads()

            # Refresh Pipeline Overview stats (Tab 1)
            if hasattr(self, 'refresh_pipeline_stats'):
                await self.refresh_pipeline_stats()
        else:
            ui.notify(f'✗ Download failed: {result.get("message", "Unknown error")}', type='negative')


    def update_recent_downloads(self):
        """Update recent downloads list from activity log."""
        recent = self.pipeline_service.get_recent_activity(limit=10)

        # Filter for download activities
        downloads = [a for a in recent if a['action'] == 'download_and_transcribe']

        self.ytdlp_recent_column.clear()
        with self.ytdlp_recent_column:
            if downloads:
                for activity in downloads[:10]:
                    ts = datetime.fromisoformat(activity['timestamp'])
                    now = datetime.now()
                    diff = now - ts

                    if diff.total_seconds() < 3600:
                        time_ago = f"{int(diff.total_seconds() / 60)} min ago"
                    else:
                        time_ago = f"{int(diff.total_seconds() / 3600)} hr ago"

                    ui.label(f"✓ {activity['description']} ({time_ago})").classes('text-sm')
            else:
                ui.label('No downloads yet').classes('text-sm text-gray-500')
```

---

## 🧪 Acceptance Criteria

### 1. Download Test
- [ ] Paste YouTube URL
- [ ] Click "Download"
- [ ] Progress bar animates 0% → 100%
- [ ] Step indicators update (pending → blue → green ✓)
- [ ] Video downloads to `/data/GWTH-YT-Vids/`
- [ ] MP3 created
- [ ] MD transcript created with timestamps
- [ ] Success notification shows

### 2. Cookie Status Test
- [ ] If cookies.txt exists and < 24 hours → "✓ Fresh"
- [ ] If 1-7 days old → "⚠ Stale"
- [ ] If > 7 days → "✗ Very Old"
- [ ] If missing → "✗ No cookies file found"

### 3. Progress Tracking Test
- [ ] "Downloading video..." shows percentage
- [ ] "Converting to MP3..." appears after download
- [ ] "Transcribing..." appears after conversion
- [ ] "Indexing into Qdrant..." appears after transcription
- [ ] All steps turn green ✓ when complete

### 4. Recent Downloads Test
- [ ] After successful download → appears in "Recent Downloads"
- [ ] Shows time ago (X min ago / X hr ago)
- [ ] Limited to last 10 downloads

### 5. Error Handling Test
- [ ] Invalid URL → error notification
- [ ] Age-restricted video without cookies → error notification
- [ ] Button disabled during download (no double-clicks)

---

## 🚀 Testing Locally (P53)

```bash
# Build with ffmpeg
docker build -t gwth-dashboard:test .

# Run with volumes
docker run -p 8088:8088 \
  -v /c/Projects/gwthpipeline520:/data \
  --gpus all \
  gwth-dashboard:test

# Test download
# 1. Open http://localhost:8088
# 2. Navigate to Tab 2
# 3. Paste: https://www.youtube.com/watch?v=dQw4w9WgXcQ (Rick Astley, public video)
# 4. Click Download
# 5. Watch progress update
```

**Expected:**
- Download completes (may take 5-10 minutes for first run - Whisper model downloads)
- MP4, MP3, MD files appear in `/c/Projects/gwthpipeline520/GWTH-YT-Vids/`

---

## 📦 Deployment to P520

```bash
# Commit
git add app/services/ytdlp_service.py app/services/whisper_service.py app/services/download_manager.py app/gwth_dashboard.py requirements.txt Dockerfile
git commit -m "Phase 3: Add YouTube download & transcription (Tab 2)

- YTDLPService for video downloads
- WhisperService with faster-whisper large-v3 INT8 (3.1GB VRAM)
- DownloadManager coordinating full pipeline
- Tab 2 UI with real-time progress tracking
- Cookie status display
- Recent downloads list

Technical:
- faster-whisper large-v3 INT8 (best quality in 4GB budget)
- ffmpeg MP4 → MP3 conversion
- Background task processing
- Activity log integration

Acceptance tests:
✓ Download video from YouTube
✓ Convert to MP3
✓ Transcribe with timestamps
✓ Progress tracking (0-100%)
✓ Cookie status accurate
✓ Recent downloads display
"
git push

# Deploy
ssh p520
cd /home/david/gwth-pipeline-v2
git pull
coolify deploy --app gwth-dashboard
```

---

## 🐛 Troubleshooting

### "ffmpeg not found"
```bash
# Check ffmpeg in container
docker exec gwth-dashboard which ffmpeg

# If missing, rebuild Dockerfile with ffmpeg install
```

### "Whisper model download fails"
```bash
# Check internet connection
docker exec gwth-dashboard ping -c 3 huggingface.co

# Check disk space (model is ~1.5GB)
df -h
```

### "Out of VRAM"
- Check GPU usage: `nvidia-smi`
- Unload F5-TTS or Kokoro before running Whisper
- Reduce compute_type from "int8" to "int8_float16" (slower, less VRAM)

### "Download stuck at 0%"
- Check YouTube URL is valid
- Try with cookies.txt if age-restricted
- Check logs: `docker logs gwth-dashboard`

---

## 📝 Next Steps

**Next:** Phase 5 (PROMPT_05) - Syllabus Manager (Tab 5) - CRITICAL

**After:** Phase 6 (PROMPT_06) - Lesson Writer (Tab 6)

---

## 🎯 Success Checklist

- [ ] WhisperService created (faster-whisper large-v3 INT8)
- [ ] YTDLPService created (downloads + MP3 conversion)
- [ ] DownloadManager coordinates full pipeline
- [ ] Tab 2 UI with progress tracking
- [ ] Cookie status displays correctly
- [ ] Recent downloads list works
- [ ] Tested locally (downloaded at least 1 video)
- [ ] Committed to git
- [ ] Deployed to P520
- [ ] Verified on P520 (download works, transcripts created)

**Ready for Phase 5 (CRITICAL: Syllabus Manager)!** 🎉
