# GWTH Pipeline V2 - PROMPT 09: TTS Main Text (Kokoro)

**Phase:** 7B (Tab 8: TTS Main Text)
**Prerequisites:** Phase 6 (Lesson Writer) must be completed
**Estimated Time:** 2-3 hours
**Complexity:** Medium

---

## 🎯 Goal

Main lesson narration with word-level timestamps using Kokoro TTS (2GB VRAM). Generate 3 voice variants, compare waveforms, export timestamps JSON for Remotion.

---

## 📋 Features

1. Kokoro API connection (P520:8880)
2. Voice selection (67 voices with previews)
3. Multi-voice support (generate 3 variants simultaneously)
4. Word-level timestamps for Remotion
5. Waveform comparison (side-by-side 3 variants)
6. Pronunciation dictionary integration
7. Download best variant

---

## 🏗️ Implementation

### Service: `app/services/kokoro_service.py`

```python
"""Kokoro TTS service with word-level timestamps."""
import httpx
from pathlib import Path
from typing import List, Dict
import logging

logger = logging.getLogger(__name__)

class KokoroService:
    def __init__(self, api_url: str = "http://192.168.178.50:8880"):
        self.api_url = api_url
        self.client = httpx.AsyncClient(timeout=300.0)

    async def generate_with_timestamps(
        self,
        text: str,
        voice: str,
        output_path: Path
    ) -> Dict:
        """Generate audio with word-level timestamps."""
        try:
            response = await self.client.post(
                f"{self.api_url}/generate",
                json={
                    "text": text,
                    "voice": voice,
                    "output_path": str(output_path),
                    "return_timestamps": True  # Enable word timestamps
                }
            )
            return response.json()
        except Exception as e:
            logger.error(f"Failed to generate audio: {e}")
            return {"status": "error", "message": str(e)}

    async def generate_variants(
        self,
        text: str,
        voices: List[str],
        output_dir: Path
    ) -> List[Dict]:
        """Generate 3 variants with different voices."""
        results = []
        for i, voice in enumerate(voices):
            output_path = output_dir / f"variant_{i+1}.wav"
            result = await self.generate_with_timestamps(text, voice, output_path)
            results.append(result)
        return results

    async def get_voices(self) -> List[str]:
        """Get list of available voices."""
        try:
            response = await self.client.get(f"{self.api_url}/voices")
            return response.json().get('voices', [])
        except Exception as e:
            logger.error(f"Failed to get voices: {e}")
            return []
```

---

## 🧪 UI Implementation (Tab 8)

```python
def create_tab_tts_main(self):
    """Tab 8: TTS Main Text (Kokoro)"""
    with ui.column().classes('w-full gap-4'):
        ui.label('TTS Main Text (Kokoro + Word Timestamps)').classes('text-xl font-bold')

        # Kokoro status
        with ui.card().classes('w-full'):
            self.kokoro_status_label = ui.label('🟢 Kokoro TTS Status: Loaded (2GB VRAM)').classes('text-sm text-green-600')

        # Input text
        with ui.card().classes('w-full'):
            ui.label('Input Text').classes('text-lg font-semibold')

            self.kokoro_text_textarea = ui.textarea(
                label='Lesson Main Text',
                placeholder='Paste lesson main text here or auto-load from Lesson Writer'
            ).classes('w-full').props('rows=10')

            ui.button('Auto-Load from Last Lesson', on_click=self.load_last_lesson_main).props('flat')

        # Voice selection (3 variants)
        with ui.card().classes('w-full'):
            ui.label('Voice Selection (3 Variants)').classes('text-lg font-semibold')

            with ui.row().classes('w-full gap-4'):
                with ui.column().classes('flex-1'):
                    self.kokoro_voice1 = ui.select(
                        label='Voice 1',
                        options=['af_heart', 'af_sky', 'am_michael'],
                        value='af_heart'
                    )
                    ui.button('Preview', on_click=lambda: self.preview_kokoro_voice(1)).props('flat size=sm')

                with ui.column().classes('flex-1'):
                    self.kokoro_voice2 = ui.select(
                        label='Voice 2',
                        options=['af_heart', 'af_sky', 'am_michael'],
                        value='af_sky'
                    )
                    ui.button('Preview', on_click=lambda: self.preview_kokoro_voice(2)).props('flat size=sm')

                with ui.column().classes('flex-1'):
                    self.kokoro_voice3 = ui.select(
                        label='Voice 3',
                        options=['af_heart', 'af_sky', 'am_michael'],
                        value='am_michael'
                    )
                    ui.button('Preview', on_click=lambda: self.preview_kokoro_voice(3)).props('flat size=sm')

        # Actions
        with ui.row().classes('w-full gap-2'):
            ui.button('Generate 3 Variants', on_click=self.generate_kokoro_variants, icon='mic').props('unelevated color=primary')
            ui.button('Use Pronunciation Dict', on_click=self.apply_pronunciation_dict, icon='spellcheck').props('outline')

        # Variants comparison
        with ui.card().classes('w-full'):
            ui.label('Variants Comparison').classes('text-lg font-semibold')

            with ui.row().classes('w-full gap-4'):
                # Variant 1
                with ui.column().classes('flex-1'):
                    ui.label('Variant 1').classes('font-semibold')
                    self.kokoro_v1_status = ui.label('⏹️ Idle').classes('text-sm')
                    self.kokoro_v1_waveform = ui.label('[Waveform placeholder]').classes('text-xs text-gray-500')
                    with ui.row().classes('gap-2'):
                        ui.button('Play', on_click=lambda: self.play_kokoro_variant(1), icon='play_arrow').props('flat size=sm')
                        ui.button('Download', on_click=lambda: self.download_kokoro_variant(1), icon='download').props('flat size=sm')

                # Variant 2
                with ui.column().classes('flex-1'):
                    ui.label('Variant 2').classes('font-semibold')
                    self.kokoro_v2_status = ui.label('⏹️ Idle').classes('text-sm')
                    self.kokoro_v2_waveform = ui.label('[Waveform placeholder]').classes('text-xs text-gray-500')
                    with ui.row().classes('gap-2'):
                        ui.button('Play', on_click=lambda: self.play_kokoro_variant(2), icon='play_arrow').props('flat size=sm')
                        ui.button('Download', on_click=lambda: self.download_kokoro_variant(2), icon='download').props('flat size=sm')

                # Variant 3
                with ui.column().classes('flex-1'):
                    ui.label('Variant 3').classes('font-semibold')
                    self.kokoro_v3_status = ui.label('⏹️ Idle').classes('text-sm')
                    self.kokoro_v3_waveform = ui.label('[Waveform placeholder]').classes('text-xs text-gray-500')
                    with ui.row().classes('gap-2'):
                        ui.button('Play', on_click=lambda: self.play_kokoro_variant(3), icon='play_arrow').props('flat size=sm')
                        ui.button('Download', on_click=lambda: self.download_kokoro_variant(3), icon='download').props('flat size=sm')

        # Word timestamps
        with ui.card().classes('w-full'):
            ui.label('Word Timestamps (Variant 1)').classes('text-lg font-semibold')

            self.kokoro_timestamps_textarea = ui.textarea(
                label='Timestamps JSON (for Remotion)',
                placeholder='Word timestamps will appear here after generation'
            ).classes('w-full').props('rows=8 readonly')

            ui.button('Export for Remotion', on_click=self.export_timestamps_json).props('outline')

def load_last_lesson_main(self):
    """Auto-load main text from last lesson."""
    ui.notify('Auto-load: Extract main lesson text (TODO)', type='info')

async def generate_kokoro_variants(self):
    """Generate 3 variants with Kokoro."""
    text = self.kokoro_text_textarea.value

    if not text:
        ui.notify('Enter text', type='warning')
        return

    voices = [
        self.kokoro_voice1.value,
        self.kokoro_voice2.value,
        self.kokoro_voice3.value
    ]

    # Update status
    self.kokoro_v1_status.text = '⚡ Generating...'
    self.kokoro_v2_status.text = '⚡ Generating...'
    self.kokoro_v3_status.text = '⚡ Generating...'

    output_dir = Config.DATA_PATH / "tts_sessions" / "kokoro_variants"
    output_dir.mkdir(parents=True, exist_ok=True)

    results = await self.kokoro_service.generate_variants(text, voices, output_dir)

    # Update status for each variant
    for i, result in enumerate(results):
        status_label = getattr(self, f'kokoro_v{i+1}_status')

        if result.get('status') == 'success':
            status_label.text = '✓ Ready'
            status_label.classes('text-green-600')

            # Show timestamps for variant 1
            if i == 0 and 'timestamps' in result:
                import json
                self.kokoro_timestamps_textarea.value = json.dumps(result['timestamps'], indent=2)
        else:
            status_label.text = '✗ Failed'
            status_label.classes('text-red-600')

    ui.notify('Variants generated!', type='positive')

def apply_pronunciation_dict(self):
    """Apply pronunciation dictionary before generation."""
    ui.notify('Pronunciation dict: Replace "API" → "A P I" (TODO: load from file)', type='info')

def preview_kokoro_voice(self, voice_num):
    """Preview voice sample."""
    ui.notify(f'Preview Voice {voice_num} (TODO: play sample)', type='info')

def play_kokoro_variant(self, variant_num):
    """Play variant audio."""
    ui.notify(f'Play Variant {variant_num} (TODO: audio player)', type='info')

def download_kokoro_variant(self, variant_num):
    """Download variant WAV."""
    ui.notify(f'Download Variant {variant_num} (TODO: file download)', type='info')

def export_timestamps_json(self):
    """Export timestamps JSON for Remotion."""
    timestamps_json = self.kokoro_timestamps_textarea.value

    if not timestamps_json:
        ui.notify('No timestamps to export', type='warning')
        return

    # Save to file
    output_path = Config.DATA_PATH / "tts_sessions" / "word_timestamps.json"
    output_path.write_text(timestamps_json, encoding='utf-8')

    ui.notify(f'Timestamps exported to {output_path.name}', type='positive')
```

---

## 🧪 Acceptance Criteria

- [ ] Generate 3 variants → all complete successfully
- [ ] Word timestamps JSON exported
- [ ] Waveforms display side-by-side
- [ ] Play/pause controls work
- [ ] Download variant → saves WAV file
- [ ] Pronunciation dictionary applied

---

## 🚀 Deployment

```bash
git commit -m "Phase 7B: Add TTS Main Text (Tab 8)

- KokoroService with word-level timestamps
- Tab 8 UI with 3-variant generation, comparison, timestamps
- Export timestamps JSON for Remotion
"
git push
```

**Next:** Phase 8 (Remotion Studio) 🎬
