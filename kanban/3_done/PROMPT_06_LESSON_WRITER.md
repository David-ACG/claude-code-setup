# GWTH Pipeline V2 - PROMPT 06: Lesson Writer

**Phase:** 6 (Tab 6: Lesson Writer)
**Prerequisites:** Phase 5 (Syllabus Manager) must be completed
**Estimated Time:** 3-4 hours
**Complexity:** Medium

---

## 🎯 Goal

AI-assisted lesson creation with Claude Max integration. Load lessons from Syllabus, search RAG for relevant transcripts, generate Claude Max prompts, preview Markdown, and save lessons.

---

## 📋 Features

1. Dropdown to select lesson from Syllabus Manager
2. Auto-fill lesson metadata (title, duration, difficulty, objectives)
3. RAG search button to find relevant transcripts
4. Checkboxes to select which transcripts to include
5. "Generate Prompt" button (copies formatted prompt for Claude Max)
6. Markdown preview pane
7. Save lesson to `/data/generated_lessons/lesson_NNN_title.md`
8. Update lesson status in Syllabus to "in_progress" / "completed"

---

## 🏗️ Implementation

### Service: `app/services/lesson_writer_service.py`

```python
"""Lesson writer service."""
from pathlib import Path
from typing import Dict, List
import logging

class LessonWriterService:
    def __init__(self, lessons_dir: Path):
        self.lessons_dir = lessons_dir
        self.lessons_dir.mkdir(parents=True, exist_ok=True)

    def generate_claude_prompt(self, lesson: Dict, transcripts: List[Dict]) -> str:
        """Generate Claude Max prompt with lesson requirements and transcripts."""
        prompt_parts = [
            f"# Generate Lesson: {lesson['title']}\\n",
            f"**Duration:** {lesson['duration']}",
            f"**Difficulty:** {lesson['difficulty']}\\n",
            f"## Learning Objectives:",
        ]

        for obj in lesson.get('objectives', []):
            prompt_parts.append(f"- {obj}")

        prompt_parts.append("\\n## Source Transcripts:\\n")

        for t in transcripts:
            prompt_parts.append(f"### {t['file_name']}\\n")
            prompt_parts.append(t['content'][:500] + "...\\n")

        prompt_parts.append("\\n## Instructions:")
        prompt_parts.append("Create a comprehensive lesson with:")
        prompt_parts.append("1. Introduction")
        prompt_parts.append("2. Core Concepts")
        prompt_parts.append("3. Practical Examples")
        prompt_parts.append("4. Lab Exercises")
        prompt_parts.append("5. Summary & Resources")

        return "\\n".join(prompt_parts)

    def save_lesson(self, lesson_number: int, title: str, content: str) -> Path:
        """Save lesson to MD file."""
        safe_title = "".join(c if c.isalnum() else "_" for c in title).lower()
        filename = f"lesson_{lesson_number:03d}_{safe_title}.md"
        filepath = self.lessons_dir / filename

        filepath.write_text(content, encoding='utf-8')
        return filepath
```

---

## 🧪 UI Implementation (Tab 6)

```python
def create_tab_lesson_writer(self):
    """Tab 6: Lesson Writer"""
    with ui.column().classes('w-full gap-4'):
        ui.label('Lesson Writer').classes('text-xl font-bold')

        # Lesson selector
        with ui.card().classes('w-full'):
            lesson_options = [
                f"Lesson {l['number']}: {l['title']}"
                for l in self.syllabus_data['lessons']
            ]

            self.lw_lesson_select = ui.select(
                label='Select Lesson from Syllabus',
                options=lesson_options,
                on_change=self.load_lesson_metadata
            ).classes('w-full')

        # Metadata display
        with ui.card().classes('w-full'):
            ui.label('Lesson Metadata').classes('text-lg font-semibold')
            self.lw_metadata_label = ui.label('Select a lesson to begin').classes('text-sm')

        # RAG search
        with ui.card().classes('w-full'):
            ui.label('Search Relevant Transcripts').classes('text-lg font-semibold')

            with ui.row().classes('w-full gap-2'):
                self.lw_search_input = ui.input(
                    label='Search query',
                    placeholder='e.g., "Python basics"'
                ).classes('flex-grow')

                ui.button('Search RAG', on_click=self.search_for_lesson).props('unelevated')

        # Results with checkboxes
        with ui.card().classes('w-full'):
            ui.label('Select Transcripts to Include').classes('text-lg font-semibold')
            self.lw_transcripts_column = ui.column().classes('gap-2')

        # Actions
        with ui.row().classes('w-full gap-2'):
            ui.button('Generate Claude Prompt', on_click=self.generate_prompt_for_claude).props('unelevated color=primary')
            ui.button('Save Lesson', on_click=self.save_current_lesson).props('unelevated color=secondary')

        # Preview
        with ui.card().classes('w-full'):
            ui.label('Markdown Preview').classes('text-lg font-semibold')
            self.lw_content_textarea = ui.textarea(
                label='Lesson Content',
                placeholder='Paste generated content here or edit manually'
            ).classes('w-full').props('rows=20')

def load_lesson_metadata(self, e):
    """Load lesson metadata when selected."""
    selected_text = e.value
    lesson_number = int(selected_text.split(':')[0].replace('Lesson ', ''))

    lesson = next((l for l in self.syllabus_data['lessons'] if l['number'] == lesson_number), None)

    if lesson:
        self.current_lesson = lesson
        metadata_text = f"""
        **Title:** {lesson['title']}
        **Duration:** {lesson['duration']}
        **Difficulty:** {lesson['difficulty']}
        **Status:** {lesson['status']}

        **Objectives:**
        """ + "\\n".join(f"- {obj}" for obj in lesson.get('objectives', []))

        self.lw_metadata_label.text = metadata_text

async def search_for_lesson(self):
    """Search RAG for relevant transcripts."""
    query = self.lw_search_input.value

    if not query:
        ui.notify('Enter search query', type='warning')
        return

    results = self.qdrant_service.semantic_search(query, limit=10)

    self.lw_transcripts_column.clear()
    self.lw_selected_transcripts = []

    with self.lw_transcripts_column:
        for r in results:
            checkbox = ui.checkbox(
                text=f"{r['file_name']} (score: {r['score']})",
                value=False
            )
            checkbox.on('change', lambda e, t=r: self.toggle_transcript_selection(e, t))

def toggle_transcript_selection(self, e, transcript):
    """Track selected transcripts."""
    if e.value:
        self.lw_selected_transcripts.append(transcript)
    else:
        self.lw_selected_transcripts = [t for t in self.lw_selected_transcripts if t['id'] != transcript['id']]

def generate_prompt_for_claude(self):
    """Generate Claude Max prompt and copy to clipboard."""
    if not hasattr(self, 'current_lesson'):
        ui.notify('Select a lesson first', type='warning')
        return

    if not self.lw_selected_transcripts:
        ui.notify('Select at least one transcript', type='warning')
        return

    prompt = self.lesson_writer_service.generate_claude_prompt(
        self.current_lesson,
        self.lw_selected_transcripts
    )

    # Copy to clipboard (JavaScript)
    ui.run_javascript(f'''
    navigator.clipboard.writeText(`{prompt}`);
    ''')

    ui.notify('Prompt copied to clipboard! Paste into Claude Max.', type='positive')

def save_current_lesson(self):
    """Save lesson to file."""
    if not hasattr(self, 'current_lesson'):
        ui.notify('Select a lesson first', type='warning')
        return

    content = self.lw_content_textarea.value

    if not content:
        ui.notify('No content to save', type='warning')
        return

    filepath = self.lesson_writer_service.save_lesson(
        self.current_lesson['number'],
        self.current_lesson['title'],
        content
    )

    # Update lesson status in Syllabus
    self.syllabus_service.update_lesson(
        self.current_lesson['id'],
        {'status': 'completed'}
    )

    ui.notify(f'Lesson saved to {filepath.name}', type='positive')
```

---

## 🧪 Acceptance Criteria

- [ ] Select lesson from dropdown → metadata displays
- [ ] Search RAG → results appear with checkboxes
- [ ] Select transcripts → checkboxes work
- [ ] Generate Prompt → copies to clipboard
- [ ] Paste content → Save Lesson → file created
- [ ] Lesson status updates in Syllabus

---

## 🚀 Deployment

```bash
git add app/services/lesson_writer_service.py app/gwth_dashboard.py
git commit -m "Phase 6: Add Lesson Writer (Tab 6)

- LessonWriterService for prompt generation
- Tab 6 UI with lesson selector, RAG search, transcript selection
- Generate Claude Max prompt (copy to clipboard)
- Save lesson to MD file
- Update lesson status in Syllabus

Acceptance tests:
✓ Select lesson from Syllabus
✓ Search RAG for transcripts
✓ Generate Claude prompt
✓ Save lesson
✓ Status updates
"
git push
```

**Next:** Phase 7A (TTS Intro) 🎙️
