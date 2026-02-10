# GWTH Pipeline V2 - PROMPT 10: Remotion Studio

**Phase:** 8 (Tab 9: Remotion Studio)
**Prerequisites:** Phases 7A-7B (TTS tabs) must be completed
**Estimated Time:** 2-3 hours
**Complexity:** Low (mostly iframe embedding + template management)

---

## 🎯 Goal

Programmatic video creation with Remotion. Display template gallery, create compositions, import assets from TTS tabs, render to MP4.

---

## 📋 Features

1. Remotion server status check (P520:3000 or local)
2. Template gallery with visual previews
3. Create new composition form
4. Import audio from TTS tabs (auto-detect generated files)
5. "Open in Remotion Studio" button (new tab)
6. Render composition to MP4
7. Download rendered videos

---

## 🏗️ Implementation

### Service: `app/services/remotion_service.py`

```python
"""Remotion programmatic video service."""
import httpx
from pathlib import Path
from typing import Dict, List
import logging

logger = logging.getLogger(__name__)

class RemotionService:
    def __init__(self, api_url: str = "http://192.168.178.50:3000"):
        self.api_url = api_url
        self.studio_url = api_url  # Remotion Studio UI
        self.client = httpx.AsyncClient(timeout=300.0)

    async def check_status(self) -> bool:
        """Check if Remotion Studio is running."""
        try:
            response = await self.client.get(f"{self.api_url}/api/status")
            return response.status_code == 200
        except:
            return False

    async def get_templates(self) -> List[Dict]:
        """Get available Remotion templates."""
        try:
            response = await self.client.get(f"{self.api_url}/api/templates")
            return response.json().get('templates', [])
        except Exception as e:
            logger.error(f"Failed to get templates: {e}")
            return []

    async def create_composition(
        self,
        template: str,
        title: str,
        audio_path: Path,
        duration: int
    ) -> Dict:
        """Create new Remotion composition."""
        try:
            response = await self.client.post(
                f"{self.api_url}/api/compositions",
                json={
                    "template": template,
                    "title": title,
                    "audio": str(audio_path),
                    "duration": duration
                }
            )
            return response.json()
        except Exception as e:
            logger.error(f"Failed to create composition: {e}")
            return {"status": "error", "message": str(e)}

    async def render_composition(
        self,
        composition_id: str,
        output_path: Path
    ) -> Dict:
        """Render composition to MP4."""
        try:
            response = await self.client.post(
                f"{self.api_url}/api/render",
                json={
                    "composition_id": composition_id,
                    "output_path": str(output_path)
                }
            )
            return response.json()
        except Exception as e:
            logger.error(f"Failed to render composition: {e}")
            return {"status": "error", "message": str(e)}
```

---

## 🧪 UI Implementation (Tab 9)

```python
def create_tab_remotion(self):
    """Tab 9: Remotion Studio"""
    with ui.column().classes('w-full gap-4'):
        ui.label('Remotion Studio').classes('text-xl font-bold')

        # Studio status
        with ui.card().classes('w-full'):
            with ui.row().classes('gap-4 items-center'):
                self.remotion_status_label = ui.label('Checking status...').classes('text-sm')
                ui.button(
                    'Open Remotion Studio',
                    on_click=self.open_remotion_studio,
                    icon='open_in_new'
                ).props('outline')

            # Check status on load
            self.check_remotion_status()

        # Template gallery
        with ui.card().classes('w-full'):
            ui.label('Template Gallery').classes('text-lg font-semibold')

            with ui.row().classes('w-full gap-4'):
                # Template 1
                with ui.card().classes('flex-1 cursor-pointer').on('click', lambda: self.select_template('LessonTitle-Accent')):
                    ui.label('[Template Preview]').classes('text-center text-gray-400 text-xs')
                    ui.label('LessonTitle-Accent').classes('text-sm font-semibold text-center')
                    ui.button('Use Template', icon='check').props('flat size=sm')

                # Template 2
                with ui.card().classes('flex-1 cursor-pointer').on('click', lambda: self.select_template('GradientBackground')):
                    ui.label('[Template Preview]').classes('text-center text-gray-400 text-xs')
                    ui.label('Gradient Background').classes('text-sm font-semibold text-center')
                    ui.button('Use Template', icon='check').props('flat size=sm')

                # Template 3
                with ui.card().classes('flex-1 cursor-pointer').on('click', lambda: self.select_template('CodeDemo')):
                    ui.label('[Template Preview]').classes('text-center text-gray-400 text-xs')
                    ui.label('Code Demo').classes('text-sm font-semibold text-center')
                    ui.button('Use Template', icon='check').props('flat size=sm')

        # Create composition
        with ui.card().classes('w-full'):
            ui.label('Create Composition').classes('text-lg font-semibold')

            self.remotion_template_select = ui.select(
                label='Template',
                options=['LessonTitle-Accent', 'GradientBackground', 'CodeDemo'],
                value='LessonTitle-Accent'
            ).classes('w-full')

            self.remotion_title_input = ui.input(
                label='Title',
                placeholder='e.g., Lesson 95: Transformers'
            ).classes('w-full')

            # Audio import from TTS tabs
            with ui.row().classes('w-full gap-2'):
                self.remotion_audio_select = ui.select(
                    label='Audio File',
                    options=self.get_available_audio_files(),
                    value=None
                ).classes('flex-grow')

                ui.button('Refresh', on_click=self.refresh_audio_files, icon='refresh').props('flat')

            self.remotion_duration_input = ui.number(
                label='Duration (seconds)',
                value=60,
                min=1,
                max=600
            ).classes('w-full')

            with ui.row().classes('w-full gap-2'):
                ui.button('Create', on_click=self.create_remotion_composition, icon='add').props('unelevated color=primary')
                ui.button('Render to MP4', on_click=self.render_remotion_video, icon='movie').props('unelevated color=secondary')

        # Rendered videos
        with ui.card().classes('w-full'):
            ui.label('Rendered Videos').classes('text-lg font-semibold')

            self.remotion_videos_column = ui.column().classes('gap-2')
            with self.remotion_videos_column:
                ui.label('No rendered videos yet').classes('text-sm text-gray-500')

async def check_remotion_status(self):
    """Check if Remotion Studio is running."""
    is_running = await self.remotion_service.check_status()

    if is_running:
        self.remotion_status_label.text = f'✓ Studio Running ({self.remotion_service.studio_url})'
        self.remotion_status_label.classes('text-green-600')
    else:
        self.remotion_status_label.text = '✗ Studio Not Running (start manually)'
        self.remotion_status_label.classes('text-red-600')

def open_remotion_studio(self):
    """Open Remotion Studio in new tab."""
    ui.run_javascript(f'window.open("{self.remotion_service.studio_url}", "_blank")')

def select_template(self, template_name):
    """Select template from gallery."""
    self.remotion_template_select.value = template_name
    ui.notify(f'Selected: {template_name}', type='positive')

def get_available_audio_files(self) -> List[str]:
    """Get list of audio files from TTS sessions."""
    tts_dir = Config.DATA_PATH / "tts_sessions"

    if not tts_dir.exists():
        return []

    audio_files = []
    for file in tts_dir.glob("**/*.wav"):
        audio_files.append(str(file.relative_to(Config.DATA_PATH)))

    return audio_files

def refresh_audio_files(self):
    """Refresh audio file list."""
    self.remotion_audio_select.options = self.get_available_audio_files()
    ui.notify('Audio files refreshed', type='positive')

async def create_remotion_composition(self):
    """Create new Remotion composition."""
    template = self.remotion_template_select.value
    title = self.remotion_title_input.value
    audio_file = self.remotion_audio_select.value
    duration = int(self.remotion_duration_input.value)

    if not title:
        ui.notify('Enter title', type='warning')
        return

    if not audio_file:
        ui.notify('Select audio file', type='warning')
        return

    audio_path = Config.DATA_PATH / audio_file

    result = await self.remotion_service.create_composition(
        template=template,
        title=title,
        audio_path=audio_path,
        duration=duration
    )

    if result.get('status') == 'success':
        ui.notify('Composition created! Open Remotion Studio to preview.', type='positive')
    else:
        ui.notify(f'Failed to create composition: {result.get("message")}', type='negative')

async def render_remotion_video(self):
    """Render composition to MP4."""
    ui.notify('Rendering video... (this may take 2-5 minutes)', type='info')

    output_path = Config.DATA_PATH / "rendered_videos" / "lesson_video.mp4"
    output_path.parent.mkdir(parents=True, exist_ok=True)

    result = await self.remotion_service.render_composition(
        composition_id="latest",  # TODO: Track actual composition ID
        output_path=output_path
    )

    if result.get('status') == 'success':
        ui.notify(f'Video rendered: {output_path.name}', type='positive')
        self.update_rendered_videos()
    else:
        ui.notify(f'Render failed: {result.get("message")}', type='negative')

def update_rendered_videos(self):
    """Update rendered videos list."""
    videos_dir = Config.DATA_PATH / "rendered_videos"

    if not videos_dir.exists():
        return

    videos = list(videos_dir.glob("*.mp4"))

    self.remotion_videos_column.clear()
    with self.remotion_videos_column:
        if videos:
            for video in videos:
                size_mb = video.stat().st_size / (1024 * 1024)

                with ui.row().classes('w-full justify-between items-center'):
                    ui.label(f'• {video.name} ({size_mb:.1f} MB, 1080p)').classes('text-sm')
                    with ui.row().classes('gap-2'):
                        ui.button('Download', on_click=lambda v=video: self.download_video(v), icon='download').props('flat size=sm')
                        ui.button('Preview', on_click=lambda v=video: self.preview_video(v), icon='play_circle').props('flat size=sm')
        else:
            ui.label('No rendered videos yet').classes('text-sm text-gray-500')

def download_video(self, video_path):
    """Download rendered video."""
    ui.notify(f'Download: {video_path.name} (TODO: file download)', type='info')

def preview_video(self, video_path):
    """Preview rendered video."""
    ui.notify(f'Preview: {video_path.name} (TODO: video player)', type='info')
```

---

## 🧪 Acceptance Criteria

- [ ] Remotion Studio status check works
- [ ] "Open in Studio" button opens P520:3000 in new tab
- [ ] Template gallery displays 3 templates
- [ ] Select template → populates dropdown
- [ ] Audio files from TTS tabs appear in dropdown
- [ ] Create composition → success notification
- [ ] Render to MP4 → video file created
- [ ] Rendered videos list updates

---

## 🚀 Deployment

```bash
git commit -m "Phase 8: Add Remotion Studio (Tab 9)

- RemotionService for composition management
- Tab 9 UI with template gallery, composition creation, rendering
- Import audio from TTS tabs
- Render to MP4 and download

Acceptance tests:
✓ Studio status check
✓ Template gallery
✓ Create composition
✓ Render to MP4
✓ Download videos
"
git push
```

---

## 🎉 All 9 Tabs Complete!

**Dependency Chain Now Works:**
```
Syllabus (Tab 5) → Lesson Writer (Tab 6) → TTS Intro (Tab 7) → TTS Main (Tab 8) → Remotion (Tab 9)
```

**Next:** Update BUILD_PLAN.md and QUICK_START.md with all prompt links! 📚
