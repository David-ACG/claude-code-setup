# Prompt 1: Create GWTH Dashboard Foundation with Docker/Coolify

**Phase:** 1A + 1B Combined
**Goal:** Working NiceGUI dashboard with dual-theme UI, 9 tabs, Docker deployment
**Est. Completion:** Dashboard accessible at http://192.168.178.50:8088

---

## Context

You are building the GWTH Lesson Creation Pipeline V2 dashboard from scratch using NiceGUI (Python-only web framework). This is a clean rebuild to replace a legacy 20,000-line Flask monolith.

**Target Environment:**
- **Server:** P520 (Ubuntu, Docker, Coolify)
- **Deployment:** Docker container with Coolify orchestration
- **Port:** 8088
- **Data Volume:** `/home/david/gwth-pipeline/` (will be mounted read-only)

**Design References (CRITICAL - Read These First):**
1. `.claude/design-system.md` - Complete color palette, typography, spacing rules
2. `.claude/architecture.md` - System architecture, technology stack, service layout
3. `GWTH_PIPELINE_V2_UI_MOCKUP.html` - Working HTML/CSS prototype (convert patterns to NiceGUI)
4. `GWTH_ICON_MAPPING.md` - Hand-drawn icon mappings (32px recommended size)

---

## 🧹 Pre-Flight Check (P520 Cleanup)

**CRITICAL:** If deploying to P520, first verify no OLD dashboard is running.

Check for OLD dashboard:
```bash
ssh p520 "systemctl --user status gwth-dashboard 2>&1 | head -3"
```

If you see "Active: active (running)" or the directory `/home/david/gwth-dashboard/` exists:

**STOP! The OLD Flask dashboard is still running. This will cause confusion.**

**Cleanup procedure:**
1. Stop service: `ssh p520 "systemctl --user stop gwth-dashboard"`
2. Disable service: `ssh p520 "systemctl --user disable gwth-dashboard"`
3. Back up: `ssh p520 "cd /home/david && tar -czf gwth-dashboard-backup-$(date +%Y%m%d).tar.gz gwth-dashboard/"`
4. Delete: `ssh p520 "rm -rf /home/david/gwth-dashboard"`
5. Verify ports free: `ssh p520 "ss -tlnp | grep :808"`

**Expected result:** Port 8080 and 8088 both free, no OLD dashboard directory.

**If already cleaned:** Continue to Task below.

---

## Task: Create Complete Dashboard Foundation

### Part 1: Project Structure & Docker Setup

Create the following file structure:

```
gwthpipeline520/
├── app/
│   ├── __init__.py
│   ├── gwth_dashboard.py          # Main NiceGUI application
│   ├── config.py                   # Environment config
│   └── services/
│       └── __init__.py
├── icons/                           # (Already exists - hand-drawn PNG icons)
├── requirements.txt                 # Python dependencies
├── Dockerfile                       # Python 3.11-slim container
├── docker-compose.yml              # For local testing
├── coolify.yml                     # Coolify deployment config
├── .dockerignore                   # Exclude .git, __pycache__, etc.
├── .env.example                    # Example environment variables
└── README.md                       # Setup and deployment instructions
```

### Part 2: Dependencies (requirements.txt)

```txt
# Web Framework
nicegui>=2.0.0
fastapi>=0.110.0
uvicorn[standard]>=0.27.0

# Utilities
python-dotenv>=1.0.0
```

### Part 3: Docker Configuration

**Dockerfile:**
```dockerfile
FROM python:3.11-slim

WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY app/ ./app/
COPY icons/ ./icons/

# Expose port
EXPOSE 8088

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8088/health || exit 1

# Run application
CMD ["python", "-m", "uvicorn", "app.gwth_dashboard:app", "--host", "0.0.0.0", "--port", "8088"]
```

**docker-compose.yml** (for local testing):
```yaml
version: '3.8'
services:
  dashboard:
    build: .
    ports:
      - "8088:8088"
    volumes:
      - /home/david/gwth-pipeline:/data:ro
    environment:
      - DASHBOARD_PORT=8088
      - DATA_PATH=/data
      - LOG_LEVEL=info
    restart: unless-stopped
```

**coolify.yml:**
```yaml
name: gwth-dashboard
type: application
publish_directory: /
build_pack: dockerfile
dockerfile: ./Dockerfile
ports:
  - 8088:8088
volumes:
  - /home/david/gwth-pipeline:/data:ro
environment:
  DASHBOARD_PORT: 8088
  DATA_PATH: /data
  LOG_LEVEL: info
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:8088/health"]
  interval: 30s
  timeout: 10s
  retries: 3
  start_period: 40s
restart: always
resources:
  limits:
    memory: 2G
    cpus: '2.0'
```

**.dockerignore:**
```
.git
.gitignore
__pycache__
*.pyc
*.pyo
*.pyd
.Python
env/
venv/
.venv
pip-log.txt
pip-delete-this-directory.txt
.tox/
.coverage
.coverage.*
.cache
nosetests.xml
coverage.xml
*.cover
*.log
.DS_Store
*.swp
.vscode/
.idea/
```

### Part 4: Configuration (config.py)

```python
"""Application configuration from environment variables."""
import os
from pathlib import Path
from typing import Optional

class Config:
    """Application configuration."""

    # Server
    PORT: int = int(os.getenv("DASHBOARD_PORT", "8088"))
    HOST: str = os.getenv("DASHBOARD_HOST", "0.0.0.0")
    LOG_LEVEL: str = os.getenv("LOG_LEVEL", "info")

    # Data paths
    DATA_PATH: Path = Path(os.getenv("DATA_PATH", "/data"))
    QDRANT_PATH: Path = DATA_PATH / "qdrant_data"
    VIDS_PATH: Path = DATA_PATH / "GWTH-YT-Vids"
    LESSONS_PATH: Path = DATA_PATH / "generated_lessons"

    # Icons
    ICON_PATH: Path = Path(__file__).parent.parent / "icons" / "200-handdrawn-icons-by-heloholo" / "png" / "32"

    # App info
    APP_NAME: str = "GWTH Pipeline V2"
    APP_VERSION: str = "2.0.0"

    @classmethod
    def validate(cls) -> dict[str, bool]:
        """Check if paths exist."""
        return {
            "data_path": cls.DATA_PATH.exists(),
            "icon_path": cls.ICON_PATH.exists(),
        }
```

### Part 5: Main Dashboard (gwth_dashboard.py)

**CRITICAL DESIGN REQUIREMENTS** (from .claude/design-system.md and GWTH_PIPELINE_V2_UI_MOCKUP.html):

#### Color Palette (CSS Variables)

**Dark Theme (Default):**
```css
--bg-primary: #1C1C1E        /* Very dark warm grey (main background) */
--bg-secondary: #2C2C2E      /* Dark warm grey (cards) */
--bg-tertiary: #3A3A3C       /* Medium dark grey (elevated surfaces) */
--text-primary: #10A37F      /* Green for primary text */
--text-secondary: #A8A8A8    /* Light grey for secondary text */
--text-inverse: #FAF9F0      /* Warm off-white for headers */
--text-body: #E5E5E5         /* Body text */
--accent-primary: #3A3A3C    /* Dark grey buttons */
--accent-hover: #4A4A4C      /* Slightly lighter on hover */
--btn-text: #A8A8A8          /* Light grey text for buttons */
--btn-text-hover: #FAF9F0    /* Off-white text on hover */
--success: #10A37F           /* Green */
--warning: #D4A574           /* Muted warm orange */
--error: #C97C7C             /* Muted warm red */
--border-light: #3A3A3C
--shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.3)
--shadow-md: 0 4px 6px rgba(0, 0, 0, 0.4)
```

**Light Theme:**
```css
--bg-primary: #f5ebe0        /* Warm beige background */
--bg-secondary: #ffffff      /* White cards */
--bg-tertiary: #faf6f1       /* Slightly off-white */
--text-primary: #10b981      /* Brighter green */
--text-secondary: #6b6b6b    /* Dark grey */
--text-inverse: #1a1a1a      /* Dark text for headers */
--text-body: #374151         /* Dark grey body text */
--accent-primary: #333333    /* Dark grey buttons */
--accent-hover: #4a4a4a      /* Lighter grey on hover */
--btn-text: #f5f5f5          /* Off-white button text */
--btn-text-hover: #ffffff    /* Pure white on hover */
--success: #10b981
--warning: #f59e0b
--error: #ef4444
--border-light: #e5e7eb
--shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.05)
```

#### Typography
- **Font Family:** System font stack: `-apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen', 'Ubuntu', 'Cantarell', sans-serif`
- **h1:** 2rem (32px), weight 700
- **h2:** 1.5rem (24px), weight 600
- **h3:** 1.25rem (20px), weight 600
- **Body:** 1rem (16px), weight 400, line-height 1.6
- **Small:** 0.875rem (14px)

#### Icons
- **Size:** 32px (from `icons/200-handdrawn-icons-by-heloholo/png/32/`)
- **Dark Theme Filter:** `invert(1) brightness(0.9)` (converts black → white)
- **Light Theme Filter:** `none` (keep black)
- **Accent Filter:** `invert(1) sepia(1) saturate(2.5) hue-rotate(20deg)` (warm brown)
- **Success Filter:** `invert(1) sepia(1) saturate(3) hue-rotate(80deg)` (green)

#### Layout Components

**Header:**
- Height: ~60px
- Background: `var(--bg-secondary)`
- Border-bottom: `1px solid var(--border-light)`
- Padding: `1rem 2rem`
- Layout: Flex, space-between
- Left: Logo "GWTH" + span ".ai" (green color)
- Right: Status indicators + theme toggle

**Tab Navigation:**
- Background: `var(--bg-secondary)`
- Border-bottom: `1px solid var(--border-light)`
- Padding: `0 2rem`
- Horizontal scroll if needed
- Active tab: Green text + bottom border (2px)
- Hover: Background lighten, color → white

**Main Content:**
- Padding: `2rem`
- Max-width: `1400px`
- Centered with `margin: 0 auto`
- Background: `var(--bg-primary)`

**Buttons:**
- Background: `var(--accent-primary)`
- Color: `var(--btn-text)`
- Padding: `0.75rem 1.5rem`
- Border-radius: `6px`
- Hover: Background `var(--accent-hover)`, color `var(--btn-text-hover)`, transform `translateY(-1px)`, shadow `var(--shadow-md)`
- Transition: `all 0.2s ease`

**Cards:**
- Background: `var(--bg-tertiary)`
- Border-radius: `8px`
- Padding: `1.5rem`
- Box-shadow: `var(--shadow-sm)`
- Hover: Shadow `var(--shadow-md)`, transform `translateY(-2px)`

#### NiceGUI Implementation Patterns

Reference GWTH_PIPELINE_V2_UI_MOCKUP.html and convert HTML/CSS patterns to NiceGUI:

1. **Header:**
```python
with ui.header().classes('header-custom'):
    ui.label('GWTH').classes('logo-main')
    ui.label('.ai').classes('logo-accent')  # Green color
    with ui.row().classes('header-status'):
        ui.label('P520: Not Connected').classes('status-indicator')
        ui.label('Qdrant: Not Connected').classes('status-indicator')
        ui.button(icon='dark_mode', on_click=toggle_theme).props('flat round')
```

2. **Tabs:**
```python
with ui.tabs().classes('tabs-custom') as tabs:
    tab1 = ui.tab('Workflow Overview', icon='dashboard')
    tab2 = ui.tab('YT-dlp Download', icon='download')
    # ... (9 tabs total)

with ui.tab_panels(tabs, value=tab1).classes('tab-panels-custom'):
    with ui.tab_panel(tab1):
        ui.label('Coming soon').classes('placeholder')
        ui.image(f'{Config.ICON_PATH}/dashboard32.png').classes('icon-placeholder')
```

3. **Theme Toggle:**
```python
def toggle_theme():
    """Switch between dark and light themes."""
    current = ui.run_javascript('document.documentElement.getAttribute("data-theme")')
    new_theme = 'light' if current == 'dark' else 'dark'
    ui.run_javascript(f'document.documentElement.setAttribute("data-theme", "{new_theme}")')
    ui.run_javascript(f'localStorage.setItem("gwth-theme", "{new_theme}")')
```

4. **Theme Persistence:**
```python
# On page load
ui.run_javascript('''
    const savedTheme = localStorage.getItem("gwth-theme") || "dark";
    document.documentElement.setAttribute("data-theme", savedTheme);
''')
```

5. **Custom CSS Injection:**
```python
ui.add_head_html('''
<style>
:root, [data-theme="dark"] {
    --bg-primary: #1C1C1E;
    --bg-secondary: #2C2C2E;
    --bg-tertiary: #3A3A3C;
    --text-primary: #10A37F;
    --text-inverse: #FAF9F0;
    --text-body: #E5E5E5;
    --accent-primary: #3A3A3C;
    --accent-hover: #4A4A4C;
    --btn-text: #A8A8A8;
    --btn-text-hover: #FAF9F0;
    --shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.3);
}

[data-theme="light"] {
    --bg-primary: #f5ebe0;
    --bg-secondary: #ffffff;
    --bg-tertiary: #faf6f1;
    --text-primary: #10b981;
    --text-inverse: #1a1a1a;
    --text-body: #374151;
    --accent-primary: #333333;
    --accent-hover: #4a4a4a;
    --btn-text: #f5f5f5;
    --btn-text-hover: #ffffff;
    --shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.05);
}

body {
    background-color: var(--bg-primary) !important;
    color: var(--text-body) !important;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
}

.icon-handdrawn {
    filter: var(--icon-filter-base);
}

[data-theme="dark"] .icon-handdrawn {
    filter: invert(1) brightness(0.9);
}

[data-theme="light"] .icon-handdrawn {
    filter: none;
}
</style>
''')
```

#### 9 Tab Structure (Empty Placeholders for Now)

Each tab should display:
- Icon (32px from GWTH_ICON_MAPPING.md)
- Heading with tab name
- "Coming soon" message
- Placeholder stats/content area

**Tab Mapping:**

| # | Tab Name | Description |
|---|----------|-------------|
| 1 | Pipeline Overview | Pipeline status, workflow orchestration |
| 2 | YT-dlp & Transcription | YouTube video downloads and transcription |
| 3 | External Content | External resources and content management |
| 4 | RAG System | Vector database search |
| 5 | Syllabus Manager | Course structure editor |
| 6 | Lesson Writer | AI lesson generation |
| 7 | TTS Intro Video | Voice-cloned intros |
| 8 | TTS Main Text | Main lesson audio |
| 9 | Remotion Studio | Video creation |
| 10 | Export to GWTH | Export lessons to production |

### Part 6: FastAPI Health Endpoint

Add to gwth_dashboard.py:

```python
from fastapi import FastAPI
from fastapi.responses import JSONResponse

app = FastAPI()

@app.get("/health")
async def health_check():
    """Health check endpoint for Coolify."""
    validation = Config.validate()
    return JSONResponse({
        "status": "healthy",
        "app": Config.APP_NAME,
        "version": Config.APP_VERSION,
        "data_path_exists": validation["data_path"],
        "icon_path_exists": validation["icon_path"],
        "timestamp": datetime.now().isoformat()
    })

@app.get("/version")
async def version():
    """Return app and framework versions."""
    import nicegui
    return {
        "app_version": Config.APP_VERSION,
        "nicegui_version": nicegui.__version__,
        "python_version": sys.version
    }
```

### Part 7: README.md

Create comprehensive setup instructions:

```markdown
# GWTH Pipeline V2 Dashboard

NiceGUI-based dashboard for the GWTH Lesson Creation Pipeline.

## Prerequisites

- Docker 20.10+
- Docker Compose 2.0+
- Coolify (for P520 deployment)

## Local Development

1. Clone repository:
   \```bash
   git clone https://github.com/David-ACG/gwthpipeline520.git
   cd gwthpipeline520
   \```

2. Create environment file:
   \```bash
   cp .env.example .env
   \```

3. Build and run:
   \```bash
   docker-compose up --build
   \```

4. Open browser:
   \```
   http://localhost:8088
   \```

## P520 Deployment (Coolify)

1. Push to GitHub:
   \```bash
   git push origin master
   \```

2. Deploy via Coolify:
   \```bash
   coolify deploy --app gwth-dashboard --config coolify.yml
   \```

3. Access dashboard:
   \```
   http://192.168.178.50:8088
   \```

## Testing

### Health Check
\```bash
curl http://localhost:8088/health
\```

Expected response:
\```json
{
  "status": "healthy",
  "app": "GWTH Pipeline V2",
  "version": "2.0.0",
  "data_path_exists": true,
  "icon_path_exists": true,
  "timestamp": "2026-01-09T..."
}
\```

### Version Check
\```bash
curl http://localhost:8088/version
\```

## Project Structure

\```
gwthpipeline520/
├── app/
│   ├── gwth_dashboard.py    # Main NiceGUI app
│   ├── config.py             # Configuration
│   └── services/             # Future services (Qdrant, etc.)
├── icons/                    # Hand-drawn PNG icons
├── requirements.txt          # Python dependencies
├── Dockerfile                # Container definition
├── docker-compose.yml        # Local testing
└── coolify.yml               # Production deployment
\```

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `DASHBOARD_PORT` | 8088 | Server port |
| `DATA_PATH` | /data | Volume mount path |
| `LOG_LEVEL` | info | Logging level |

## Troubleshooting

### Container won't start
\```bash
docker logs gwth-dashboard
\```

### Health check failing
\```bash
docker exec gwth-dashboard curl http://localhost:8088/health
\```

### Theme not persisting
Clear browser localStorage and refresh.
\```

---

## Acceptance Criteria

Before marking this prompt as complete, verify:

- [ ] `docker build -t gwth-dashboard:test .` succeeds
- [ ] `docker run -p 8088:8088 gwth-dashboard:test` starts without errors
- [ ] `curl http://localhost:8088/health` returns 200 OK with JSON
- [ ] Open http://localhost:8088 → dashboard loads
- [ ] All 9 tabs are visible and clickable
- [ ] Theme toggle button switches dark ↔ light mode
- [ ] Theme persists after page refresh
- [ ] Icons display correctly (not broken images)
- [ ] Header shows "GWTH.ai" with green ".ai"
- [ ] Status indicators show "Not Connected" (placeholder)
- [ ] No console errors in browser DevTools
- [ ] Mobile responsive: resize to 768px width → layout adapts

## Manual Test Checklist

1. **Build & Run:**
   ```bash
   cd /c/Projects/gwthpipeline520
   docker build -t gwth-dashboard:test .
   docker run -p 8088:8088 -v /c/Projects/gwthpipeline520/icons:/app/icons gwth-dashboard:test
   ```

2. **Health Checks:**
   ```bash
   curl http://localhost:8088/health | jq .
   curl http://localhost:8088/version | jq .
   ```

3. **UI Tests (in browser):**
   - Visit http://localhost:8088
   - Verify header logo displays correctly
   - Click theme toggle → background changes
   - Refresh page → theme persists
   - Click each tab → content area updates
   - Check all 9 tabs are present
   - Verify icons are visible (not 404)
   - Open DevTools → no console errors

4. **Responsive Test:**
   - Open DevTools → toggle device toolbar
   - Resize to 768px width
   - Verify tabs scroll horizontally
   - Verify content doesn't overflow

## Success = MVP Dashboard Shell Ready for Phase 2 (RAG Integration)

Once all acceptance criteria pass, commit and move to next prompt!
