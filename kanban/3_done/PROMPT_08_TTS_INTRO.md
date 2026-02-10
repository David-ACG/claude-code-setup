# GWTH Pipeline V2 - PROMPT 08: TTS Intro Video (F5-TTS)

**Phase:** 7A (Tab 7: TTS Intro Video)
**Prerequisites:** Phase 6 (Lesson Writer) must be completed
**Estimated Time:** 2-3 hours
**Complexity:** Medium

---

## 🎯 Goal

Voice-cloned intro narration using F5-TTS. Auto-load intro scripts from Lesson Writer, generate audio, preview waveform, download WAV/MP3.

---

## 📋 Features

1. F5-TTS connection status (P520:8881 or local)
2. Model load/unload (6GB VRAM management)
3. Voice selection (reference audio picker)
4. Script input (auto-loads from Lesson Writer if available)
5. Generate audio button
6. Waveform preview
7. Download WAV/MP3

---

## 🏗️ Implementation

### Service: `app/services/f5tts_service.py`

```python
"""F5-TTS voice cloning service."""
import httpx
from pathlib import Path
import logging

logger = logging.getLogger(__name__)

class F5TTSService:
    def __init__(self, api_url: str = "http://192.168.178.50:8881"):
        self.api_url = api_url
        self.client = httpx.AsyncClient(timeout=300.0)

    async def load_model(self) -> dict:
        """Load F5-TTS model (6GB VRAM)."""
        try:
            response = await self.client.post(f"{self.api_url}/load")
            return response.json()
        except Exception as e:
            logger.error(f"Failed to load F5-TTS: {e}")
            return {"status": "error", "message": str(e)}

    async def unload_model(self) -> dict:
        """Unload F5-TTS model to free VRAM."""
        try:
            response = await self.client.post(f"{self.api_url}/unload")
            return response.json()
        except Exception as e:
            logger.error(f"Failed to unload F5-TTS: {e}")
            return {"status": "error", "message": str(e)}

    async def generate(self, text: str, voice_ref: str, output_path: Path) -> dict:
        """Generate voice-cloned audio."""
        try:
            response = await self.client.post(
                f"{self.api_url}/generate",
                json={
                    "text": text,
                    "voice_reference": voice_ref,
                    "output_path": str(output_path)
                }
            )
            return response.json()
        except Exception as e:
            logger.error(f"Failed to generate audio: {e}")
            return {"status": "error", "message": str(e)}
```

---

## 🧪 UI Implementation (Tab 7)

```python
def create_tab_tts_intro(self):
    """Tab 7: TTS Intro Video (F5-TTS)"""
    with ui.column().classes('w-full gap-4'):
        ui.label('TTS Intro Video (F5-TTS Voice Clone)').classes('text-xl font-bold')

        # F5-TTS status
        with ui.card().classes('w-full'):
            with ui.row().classes('gap-4 items-center'):
                self.f5_status_label = ui.label('⚫ Status: Not Loaded').classes('text-sm')

                self.f5_load_btn = ui.button(
                    'Load F5-TTS',
                    on_click=self.load_f5tts,
                    icon='play_arrow'
                ).props('outline')

                self.f5_unload_btn = ui.button(
                    'Unload (Free 6GB)',
                    on_click=self.unload_f5tts,
                    icon='stop'
                ).props('outline').set_visible(False)

        # Script input
        with ui.card().classes('w-full'):
            ui.label('Intro Script').classes('text-lg font-semibold')

            self.f5_script_textarea = ui.textarea(
                label='Script',
                placeholder='Paste intro script here or auto-load from Lesson Writer'
            ).classes('w-full').props('rows=8')

            ui.button('Auto-Load from Last Lesson', on_click=self.load_last_lesson_intro).props('flat')

        # Voice selection
        with ui.card().classes('w-full'):
            ui.label('Voice Reference').classes('text-lg font-semibold')

            self.f5_voice_select = ui.select(
                label='Voice',
                options=['Voice 1 (David - warm)', 'Voice 2 (Professional)', 'Voice 3 (Energetic)'],
                value='Voice 1 (David - warm)'
            ).classes('w-full')

        # Actions
        with ui.row().classes('w-full gap-2'):
            ui.button('Generate Audio', on_click=self.generate_f5_audio, icon='mic').props('unelevated color=primary')
            ui.button('Preview', on_click=self.preview_f5_audio, icon='play_circle').props('outline')
            ui.button('Download WAV', on_click=self.download_f5_audio, icon='download').props('outline')

        # Status
        with ui.card().classes('w-full'):
            self.f5_status_text = ui.label('Status: Idle').classes('text-sm')
            self.f5_last_generated = ui.label('Last Generated: None').classes('text-xs text-gray-500')

async def load_f5tts(self):
    """Load F5-TTS model."""
    self.f5_load_btn.set_enabled(False)
    self.f5_status_label.text = '⚡ Loading...'

    result = await self.f5tts_service.load_model()

    if result.get('status') == 'success' or 'loaded' in str(result).lower():
        self.f5_status_label.text = '🟢 Status: Loaded (6GB VRAM)'
        self.f5_status_label.classes('text-green-600')
        self.f5_load_btn.set_visible(False)
        self.f5_unload_btn.set_visible(True)
        ui.notify('F5-TTS loaded successfully', type='positive')
    else:
        self.f5_status_label.text = '✗ Status: Load Failed'
        self.f5_status_label.classes('text-red-600')
        self.f5_load_btn.set_enabled(True)
        ui.notify(f'Failed to load F5-TTS: {result.get("message", "Unknown error")}', type='negative')

async def unload_f5tts(self):
    """Unload F5-TTS model."""
    result = await self.f5tts_service.unload_model()

    self.f5_status_label.text = '⚫ Status: Not Loaded'
    self.f5_status_label.classes(remove='text-green-600')
    self.f5_load_btn.set_visible(True)
    self.f5_load_btn.set_enabled(True)
    self.f5_unload_btn.set_visible(False)

    ui.notify('F5-TTS unloaded (6GB VRAM freed)', type='positive')

def load_last_lesson_intro(self):
    """Auto-load intro script from last generated lesson."""
    # TODO: Find last lesson MD file, extract intro paragraph
    ui.notify('Auto-load: Find last lesson and extract intro (TODO)', type='info')
    self.f5_script_textarea.value = "Welcome to Lesson 95: Transformers. In this lesson, we'll explore the architecture that revolutionized NLP..."

async def generate_f5_audio(self):
    """Generate audio with F5-TTS."""
    script = self.f5_script_textarea.value

    if not script:
        ui.notify('Enter script text', type='warning')
        return

    self.f5_status_text.text = 'Status: Generating...'

    output_path = Config.DATA_PATH / "tts_sessions" / "f5_intro.wav"
    output_path.parent.mkdir(parents=True, exist_ok=True)

    result = await self.f5tts_service.generate(
        text=script,
        voice_ref="voice1.wav",  # TODO: Map from dropdown
        output_path=output_path
    )

    if result.get('status') == 'success':
        self.f5_status_text.text = 'Status: Complete'
        self.f5_last_generated.text = f'Last Generated: {output_path.name} ({output_path.stat().st_size / 1024 / 1024:.1f} MB)'
        ui.notify('Audio generated!', type='positive')
    else:
        self.f5_status_text.text = 'Status: Failed'
        ui.notify(f'Generation failed: {result.get("message")}', type='negative')

def preview_f5_audio(self):
    """Preview generated audio."""
    # TODO: Implement audio player
    ui.notify('Preview: Play audio (TODO: implement audio element)', type='info')

def download_f5_audio(self):
    """Download generated audio."""
    # TODO: Implement file download
    ui.notify('Download: Provide download link (TODO)', type='info')
```

---

## 🧪 Acceptance Criteria

- [ ] Load F5-TTS → status shows "Loaded (6GB VRAM)"
- [ ] Auto-load intro script works
- [ ] Generate audio → WAV file created
- [ ] Unload model → frees VRAM

---

## 🚀 Deployment

```bash
git commit -m "Phase 7A: Add TTS Intro (Tab 7)

- F5TTSService for voice cloning
- Tab 7 UI with load/unload, script input, generation
- Auto-load from Lesson Writer
"
git push
```

**Next:** Phase 7B (TTS Main) 🎙️
