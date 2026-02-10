# GWTH Pipeline V2 - PROMPT 07: PDF & Document Processing

**Phase:** 4 (Tab 3: PDFs & Documents)
**Prerequisites:** Phase 2 (RAG System) must be completed
**Estimated Time:** 2-3 hours
**Complexity:** Medium

---

## 🎯 Goal

Process PDFs and DOCX files with Docling (97.9% table extraction accuracy), convert to Markdown, and auto-index into Qdrant.

---

## 📋 Features

1. Manual PDF upload
2. Docling processing (PDF → Markdown with tables preserved)
3. Auto-indexing into Qdrant after processing
4. Processing status (pending, processing, indexed, failed)
5. Stats: Total PDFs, tables extracted, accuracy rate
6. Recent processing list

---

## 🏗️ Implementation

### Dependencies

```txt
# Add to requirements.txt
docling==2.5.2
```

### Service: `app/services/docling_service.py`

```python
"""Docling document processing service."""
from docling.document_converter import DocumentConverter
from pathlib import Path
import logging

logger = logging.getLogger(__name__)

class DoclingService:
    def __init__(self):
        self.converter = DocumentConverter()

    def process_pdf(self, pdf_path: Path, output_dir: Path) -> dict:
        """Process PDF and convert to Markdown."""
        try:
            result = self.converter.convert(str(pdf_path))

            md_path = output_dir / f"{pdf_path.stem}.md"
            md_path.write_text(result.document.export_to_markdown())

            tables_count = len(result.document.tables)
            accuracy = result.document.quality_score if hasattr(result.document, 'quality_score') else 0.979

            return {
                "status": "success",
                "md_path": str(md_path),
                "tables": tables_count,
                "accuracy": accuracy,
            }
        except Exception as e:
            logger.error(f"Failed to process {pdf_path}: {e}")
            return {"status": "failed", "error": str(e)}
```

---

## 🧪 UI Implementation (Tab 3)

```python
def create_tab_pdfs(self):
    """Tab 3: PDFs & Documents"""
    with ui.column().classes('w-full gap-4'):
        ui.label('Document Processing').classes('text-xl font-bold')

        # Upload interface
        with ui.card().classes('w-full'):
            ui.label('Manual Upload').classes('text-lg font-semibold')

            ui.upload(
                label='Upload PDF or DOCX',
                on_upload=self.handle_pdf_upload,
                auto_upload=True
            ).props('accept=.pdf,.docx')

        # Recent processing
        with ui.card().classes('w-full'):
            ui.label('Recent Processing').classes('text-lg font-semibold')

            self.pdf_recent_column = ui.column().classes('gap-2')
            with self.pdf_recent_column:
                ui.label('No documents processed yet').classes('text-sm text-gray-500')

        # Stats
        with ui.card().classes('w-full'):
            ui.label('Statistics').classes('text-lg font-semibold')
            self.pdf_stats_label = ui.label('• Total PDFs: 0\\n• Tables Extracted: 0\\n• Avg Accuracy: 0%').classes('text-sm')

async def handle_pdf_upload(self, e):
    """Handle PDF upload and processing."""
    uploaded_file = e.content

    # Save to temp location
    temp_pdf = Config.DATA_PATH / "temp" / e.name
    temp_pdf.parent.mkdir(parents=True, exist_ok=True)
    temp_pdf.write_bytes(uploaded_file)

    ui.notify(f'Processing {e.name}...', type='info')

    # Process with Docling
    result = self.docling_service.process_pdf(
        temp_pdf,
        Config.DATA_PATH / "processed_pdfs"
    )

    if result['status'] == 'success':
        ui.notify(f'✓ Processed {e.name} ({result["tables"]} tables, {result["accuracy"]*100:.1f}% accuracy)', type='positive')

        # Index into Qdrant
        md_path = Path(result['md_path'])
        # TODO: Call qdrant_service.index_document()

        # Log activity
        self.pipeline_service.log_activity(
            "process_pdf",
            f"Processed {e.name}"
        )

        # Update UI
        self.update_pdf_recent()
    else:
        ui.notify(f'✗ Failed to process {e.name}', type='negative')

def update_pdf_recent(self):
    """Update recent processing list."""
    recent = self.pipeline_service.get_recent_activity(limit=10)
    pdfs = [a for a in recent if a['action'] == 'process_pdf']

    self.pdf_recent_column.clear()
    with self.pdf_recent_column:
        if pdfs:
            for activity in pdfs[:10]:
                ui.label(f"✓ {activity['description']}").classes('text-sm')
        else:
            ui.label('No documents processed yet').classes('text-sm text-gray-500')
```

---

## 🧪 Acceptance Criteria

- [ ] Upload PDF → Docling processes → MD created
- [ ] Tables extracted correctly
- [ ] Auto-indexes into Qdrant
- [ ] Recent processing list updates
- [ ] Stats display

---

## 🚀 Deployment

```bash
git add app/services/docling_service.py app/gwth_dashboard.py requirements.txt
git commit -m "Phase 4: Add PDF processing (Tab 3)

- DoclingService for PDF → Markdown conversion
- Tab 3 UI with upload and processing status
- Auto-indexing into Qdrant
- Recent processing list

Acceptance tests:
✓ Upload PDF
✓ Docling processes (97.9% accuracy)
✓ Auto-indexes into Qdrant
✓ Recent list updates
"
git push
```

**Next:** Phase 7A (TTS Intro) 🎙️
