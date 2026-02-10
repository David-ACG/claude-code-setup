# GWTH Pipeline V2 - PROMPT 02: RAG System Integration

**Phase:** 2A-2B (Tab 4: RAG System & Vector DB)
**Prerequisites:** Phase 1 (Foundation) must be completed and tested
**Estimated Time:** 2-3 hours
**Complexity:** Medium

---

## 🎯 Goal

Integrate Qdrant vector database for semantic search of YouTube transcripts. Users should be able to search for concepts like "AI agents" and get relevant transcript excerpts with relevance scores.

---

## 📋 What You're Building

### Tab 4: RAG System & Vector DB

**Features:**
1. Connect to Qdrant embedded database
2. Semantic search with all-MiniLM-L6-v2 embeddings
3. Display search results with relevance scores
4. Modal popup to view full transcripts
5. Database statistics display

**UI Components:**
- Search input field
- Search button
- Results table (score, file name, channel, date, content preview)
- Stats card (total points, database size, collection info)
- Full transcript modal (click any result to expand)

---

## 🏗️ Architecture

```
User Input → NiceGUI Tab 4
              ↓
       QdrantService (new)
              ↓
       Qdrant Embedded DB (/data/qdrant_data/)
              ↓
       Search Results → Display in UI
```

**Data Flow:**
1. User types query: "AI agents and automation"
2. QdrantService generates embedding using sentence-transformers
3. Qdrant searches for similar vectors
4. Results returned with scores (0.0-1.0, higher = more relevant)
5. UI displays top 10 results with clickable rows

---

## 📦 Dependencies

Add to `requirements.txt`:

```txt
qdrant-client==1.11.1
sentence-transformers==3.2.1
```

**Why these versions:**
- qdrant-client 1.11.1: Latest stable (2026-01), supports embedded mode
- sentence-transformers 3.2.1: Latest stable, all-MiniLM-L6-v2 compatible

---

## 🔧 Implementation Steps

### Step 1: Create Qdrant Service

**File:** `app/services/qdrant_service.py`

```python
"""Qdrant vector database service for semantic search."""
from qdrant_client import QdrantClient
from qdrant_client.models import Distance, VectorParams
from sentence_transformers import SentenceTransformer
from pathlib import Path
from typing import List, Dict, Optional
import logging

logger = logging.getLogger(__name__)


class QdrantService:
    """Service for interacting with Qdrant vector database."""

    def __init__(self, qdrant_path: Path):
        """
        Initialize Qdrant service.

        Args:
            qdrant_path: Path to Qdrant data directory (e.g., /data/qdrant_data/)
        """
        self.qdrant_path = qdrant_path
        self.client: Optional[QdrantClient] = None
        self.model: Optional[SentenceTransformer] = None
        self.collection_name = "gwth_lessons"
        self.connected = False

    def connect(self) -> bool:
        """
        Connect to Qdrant embedded database and load embedding model.

        Returns:
            True if successful, False otherwise
        """
        try:
            # Connect to embedded Qdrant (no server required)
            self.client = QdrantClient(path=str(self.qdrant_path))

            # Load sentence-transformers model (downloads on first run)
            logger.info("Loading embedding model (may take 1-2 minutes first time)...")
            self.model = SentenceTransformer('sentence-transformers/all-MiniLM-L6-v2')

            # Verify collection exists
            collections = self.client.get_collections().collections
            collection_names = [c.name for c in collections]

            if self.collection_name not in collection_names:
                logger.warning(f"Collection '{self.collection_name}' not found!")
                logger.warning(f"Available collections: {collection_names}")
                return False

            self.connected = True
            logger.info(f"Connected to Qdrant at {self.qdrant_path}")
            return True

        except Exception as e:
            logger.error(f"Failed to connect to Qdrant: {e}")
            self.connected = False
            return False

    def get_stats(self) -> Dict:
        """
        Get collection statistics.

        Returns:
            Dict with status, points count, vectors count, segments count
        """
        if not self.client or not self.connected:
            return {"status": "disconnected"}

        try:
            collection_info = self.client.get_collection(self.collection_name)

            # Calculate database size (approximate)
            db_size_gb = self.qdrant_path.stat().st_size / (1024 ** 3) if self.qdrant_path.exists() else 0

            return {
                "status": "connected",
                "points": collection_info.points_count,
                "vectors": collection_info.vectors_count,
                "segments": collection_info.segments_count,
                "db_size_gb": round(db_size_gb, 2),
            }
        except Exception as e:
            logger.error(f"Failed to get stats: {e}")
            return {"status": "error", "message": str(e)}

    def semantic_search(self, query: str, limit: int = 10) -> List[Dict]:
        """
        Perform semantic search on transcripts.

        Args:
            query: Search query (e.g., "AI agents and automation")
            limit: Maximum number of results (default: 10)

        Returns:
            List of dicts with id, score, content, file_name, channel, date
        """
        if not self.client or not self.model or not self.connected:
            logger.error("Cannot search: not connected to Qdrant")
            return []

        try:
            # Generate query embedding (384 dimensions for all-MiniLM-L6-v2)
            logger.info(f"Generating embedding for query: '{query[:50]}...'")
            query_vector = self.model.encode(query).tolist()

            # Search Qdrant
            logger.info(f"Searching Qdrant for top {limit} results...")
            results = self.client.search(
                collection_name=self.collection_name,
                query_vector=query_vector,
                limit=limit
            )

            # Format results
            formatted = []
            for result in results:
                formatted.append({
                    "id": result.id,
                    "score": round(result.score, 4),
                    "content": result.payload.get("content", ""),
                    "file_name": result.payload.get("file_name", "Unknown"),
                    "channel": result.payload.get("channel", "Unknown"),
                    "date": result.payload.get("date", "Unknown"),
                })

            logger.info(f"Found {len(formatted)} results")
            return formatted

        except Exception as e:
            logger.error(f"Search failed: {e}")
            return []
```

**Critical Details:**
- `connect()` checks if collection exists before claiming success
- `get_stats()` calculates database size in GB
- `semantic_search()` returns scores 0.0-1.0 (higher = more relevant)
- All methods handle errors gracefully (no crashes)

---

### Step 2: Update Config

**File:** `app/config.py`

Add Qdrant path:

```python
class Config:
    # ... existing config ...

    # Qdrant vector database
    QDRANT_PATH: Path = DATA_PATH / "qdrant_data"
```

---

### Step 3: Update Dashboard - Add Tab 4 Content

**File:** `app/gwth_dashboard.py`

Add imports at top:

```python
from app.services.qdrant_service import QdrantService
```

Initialize service in `__init__`:

```python
class GWTHDashboard:
    def __init__(self):
        # ... existing code ...

        # RAG System service
        self.qdrant_service = QdrantService(Config.QDRANT_PATH)
        self.qdrant_connected = False
        self.search_results = []
```

Add RAG tab content (replace placeholder in Phase 1):

```python
def create_tab_rag(self):
    """Tab 4: RAG System & Vector DB"""
    with ui.column().classes('w-full gap-4'):
        # Header with stats
        with ui.card().classes('w-full'):
            ui.label('RAG System & Vector DB').classes('text-xl font-bold')

            # Connection status
            status_row = ui.row().classes('gap-4 items-center')
            self.rag_status_label = ui.label('Status: Not Connected').classes('text-sm')
            self.rag_connect_btn = ui.button(
                'Connect to Qdrant',
                on_click=self.connect_qdrant
            ).props('outline')

            status_row.move(self.rag_status_label)
            status_row.move(self.rag_connect_btn)

            # Stats (hidden until connected)
            self.rag_stats_card = ui.card().classes('w-full hidden')
            with self.rag_stats_card:
                ui.label('Database Statistics').classes('text-lg font-semibold')
                self.rag_stats_label = ui.label('').classes('text-sm')

        # Search interface
        with ui.card().classes('w-full'):
            ui.label('Semantic Search').classes('text-lg font-semibold')
            ui.label('Search for concepts, topics, or keywords in YouTube transcripts').classes('text-sm text-gray-600')

            with ui.row().classes('w-full gap-2'):
                self.rag_search_input = ui.input(
                    label='Search query',
                    placeholder='e.g., "AI agents and automation"'
                ).classes('flex-grow')

                self.rag_search_btn = ui.button(
                    'Search',
                    on_click=self.do_qdrant_search
                ).props('unelevated color=primary')

        # Results table
        with ui.card().classes('w-full'):
            ui.label('Search Results').classes('text-lg font-semibold')

            # Table columns
            columns = [
                {'name': 'score', 'label': 'Score', 'field': 'score', 'sortable': True, 'align': 'left'},
                {'name': 'file_name', 'label': 'File', 'field': 'file_name', 'sortable': True, 'align': 'left'},
                {'name': 'channel', 'label': 'Channel', 'field': 'channel', 'sortable': True, 'align': 'left'},
                {'name': 'date', 'label': 'Date', 'field': 'date', 'sortable': True, 'align': 'left'},
                {'name': 'preview', 'label': 'Content Preview', 'field': 'preview', 'sortable': False, 'align': 'left'},
            ]

            self.rag_results_table = ui.table(
                columns=columns,
                rows=[],
                row_key='id'
            ).classes('w-full')

            # Click handler for rows
            self.rag_results_table.on('row-click', self.show_full_transcript)


    async def connect_qdrant(self):
        """Connect to Qdrant database."""
        self.rag_connect_btn.set_enabled(False)
        self.rag_status_label.text = 'Status: Connecting...'

        # Run connection in background
        success = self.qdrant_service.connect()

        if success:
            self.qdrant_connected = True
            self.rag_status_label.text = '✓ Status: Connected'
            self.rag_status_label.classes('text-green-600', remove='text-red-600')
            self.rag_connect_btn.set_visible(False)

            # Show stats
            stats = self.qdrant_service.get_stats()
            self.rag_stats_label.text = f'''
                Points: {stats['points']:,}
                Vectors: {stats['vectors']:,}
                Segments: {stats['segments']}
                Database Size: {stats['db_size_gb']} GB
            '''
            self.rag_stats_card.classes(remove='hidden')
        else:
            self.rag_status_label.text = '✗ Status: Connection Failed'
            self.rag_status_label.classes('text-red-600')
            self.rag_connect_btn.set_enabled(True)

            ui.notify('Failed to connect to Qdrant. Check logs.', type='negative')


    async def do_qdrant_search(self):
        """Perform semantic search."""
        query = self.rag_search_input.value.strip()

        if not query:
            ui.notify('Please enter a search query', type='warning')
            return

        if not self.qdrant_connected:
            ui.notify('Not connected to Qdrant. Click "Connect" first.', type='warning')
            return

        # Disable search during query
        self.rag_search_btn.set_enabled(False)
        self.rag_search_btn.text = 'Searching...'

        # Run search
        results = self.qdrant_service.semantic_search(query, limit=10)

        # Format for table
        table_rows = []
        for r in results:
            table_rows.append({
                'id': r['id'],
                'score': f"{r['score']:.3f}",
                'file_name': r['file_name'][:40] + '...' if len(r['file_name']) > 40 else r['file_name'],
                'channel': r['channel'],
                'date': r['date'],
                'preview': r['content'][:100] + '...' if len(r['content']) > 100 else r['content'],
                '_full_content': r['content']  # Store full content for modal
            })

        self.rag_results_table.rows = table_rows
        self.search_results = results  # Store for modal

        # Re-enable search
        self.rag_search_btn.set_enabled(True)
        self.rag_search_btn.text = 'Search'

        ui.notify(f'Found {len(results)} results', type='positive')


    def show_full_transcript(self, e):
        """Show full transcript in modal."""
        row = e.args['row']

        with ui.dialog() as dialog, ui.card().classes('w-full max-w-4xl'):
            ui.label(row['file_name']).classes('text-xl font-bold')
            ui.label(f"Channel: {row['channel']} | Date: {row['date']}").classes('text-sm text-gray-600')
            ui.separator()

            # Full content (scrollable)
            ui.markdown(row['_full_content']).classes('max-h-96 overflow-y-auto')

            ui.button('Close', on_click=dialog.close).props('flat')

        dialog.open()
```

---

## 🧪 Acceptance Criteria

Test each of these after implementation:

### 1. Connection Test
- [ ] Click "Connect to Qdrant" button
- [ ] Status changes to "✓ Status: Connected"
- [ ] Stats display: Points, Vectors, Segments, Database Size
- [ ] Connect button disappears after successful connection

### 2. Search Test
- [ ] Enter query: "AI agents"
- [ ] Click "Search"
- [ ] Results table populates with 10 rows
- [ ] Each row shows: Score (0.0-1.0), File name, Channel, Date, Content preview
- [ ] Scores are sorted highest to lowest

### 3. Modal Test
- [ ] Click any result row
- [ ] Modal pops up with full transcript
- [ ] Modal shows: File name, channel, date, full content
- [ ] Content is scrollable if long
- [ ] Close button closes modal

### 4. Error Handling Test
- [ ] Try searching before connecting → shows warning notification
- [ ] Try searching with empty query → shows warning notification
- [ ] If Qdrant path doesn't exist → connection fails gracefully with error message

### 5. Stats Accuracy Test
- [ ] Stats show ~746,000 points (P520 production data)
- [ ] Database size shows ~9.3 GB
- [ ] Collection name is "gwth_lessons"

---

## 🚀 Testing Locally (P53)

Before deploying to P520, test on your local machine:

```bash
# Build and run
docker build -t gwth-dashboard:test .
docker run -p 8088:8088 \
  -v /c/Projects/gwthpipeline520/qdrant_data:/data/qdrant_data \
  gwth-dashboard:test

# Open browser
start http://localhost:8088

# Navigate to Tab 4: RAG System
# Follow acceptance criteria checklist
```

**Expected behavior:**
- If `qdrant_data/` exists locally → connects successfully
- If not → shows connection error (expected, only on P520)

---

## 📦 Deployment to P520 (Coolify)

After local testing passes:

```bash
# Commit changes
git add app/services/qdrant_service.py app/gwth_dashboard.py app/config.py requirements.txt
git commit -m "Phase 2: Add RAG system integration (Tab 4)

- QdrantService with semantic search
- Tab 4 UI with search, results table, full transcript modal
- Connection status and database stats
- Error handling for disconnected state

Acceptance tests:
✓ Connect to Qdrant
✓ Search returns top 10 results with scores
✓ Click result shows full transcript in modal
✓ Stats display correctly (746K points, 9.3GB)
"
git push
```

SSH into P520 and deploy:

```bash
ssh p520
cd /home/david/gwth-pipeline-v2

# Pull latest
git pull

# Rebuild with Coolify
coolify deploy --app gwth-dashboard --config coolify.yml

# Or manual deployment
docker build -t gwth-dashboard:latest .
docker run -d \
  --name gwth-dashboard \
  -p 8088:8088 \
  -v /home/david/gwth-dashboard/qdrant_data:/data/qdrant_data \
  gwth-dashboard:latest

# Check logs
docker logs gwth-dashboard
```

Access dashboard: `http://192.168.178.50:8088`

---

## 🐛 Troubleshooting

### "Collection 'gwth_lessons' not found"
```bash
# Check Qdrant data exists
ls -lh /data/qdrant_data/

# Check collection names
docker exec gwth-dashboard python -c "
from qdrant_client import QdrantClient
client = QdrantClient(path='/data/qdrant_data/')
print(client.get_collections())
"
```

**Fix:** If collection doesn't exist, you need to run the indexing script on P520 first.

### "Failed to load embedding model"
```bash
# Check internet connection (model downloads on first run)
docker exec gwth-dashboard ping -c 3 huggingface.co

# Check disk space (model is ~80MB)
df -h
```

**Fix:** Ensure Docker container has internet access and sufficient disk space.

### "Search returns empty results"
- Verify Qdrant has data: Check stats show >0 points
- Try simpler query: "Python" or "AI"
- Check logs for errors: `docker logs gwth-dashboard`

### "Modal doesn't open"
- Check browser console for JavaScript errors (F12)
- Verify NiceGUI version: Should be 2.x
- Try reloading page (Ctrl+Shift+R)

---

## 📝 Next Steps

After Phase 2 is complete and tested:

1. **Phase 2C (PROMPT_03):** Pipeline Overview (Tab 1) - depends on RAG stats
2. **Phase 3 (PROMPT_04):** YT-dlp & Transcription (Tab 2)
3. **Phase 5 (PROMPT_05):** Syllabus Manager (Tab 5) - CRITICAL

**Don't proceed until:**
- All 5 acceptance criteria pass
- Connection works on P520
- Search returns accurate results
- No errors in Docker logs

---

## 🎯 Success Checklist

- [ ] QdrantService created with connect(), get_stats(), semantic_search()
- [ ] Tab 4 UI implemented with search, results table, modal
- [ ] requirements.txt updated with qdrant-client, sentence-transformers
- [ ] Tested locally (all acceptance criteria pass)
- [ ] Committed to git with detailed message
- [ ] Deployed to P520 via Coolify
- [ ] Tested on P520 (search works, stats accurate)
- [ ] No errors in logs

**Ready for Phase 3!** 🎉
