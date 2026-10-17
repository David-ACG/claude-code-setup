---
title: What Claude Code Projects can teach the GWTH workflow
date: 2026-10-17
author: Claude (Opus 5.5) for David
sources_checked: 2026-10-17
video: https://www.youtube.com/watch?v=mKjxGy6vCnY (Chase AI, 16 Oct 2026, 18:49)
docs: https://code.claude.com/docs/en/claude-projects
status: analysis + recommendations, nothing built yet
---

# What Claude Code Projects can teach the GWTH workflow

## 1. The short version

- **Claude Code Projects** (public beta on Pro and Max, launched 17 Sep 2026) puts one **coordinator** conversation in front of a set of **threads**. The threads are full, separate Claude Code sessions, usually in Anthropic's cloud, each on its own branch and pull request. It is not the old claude.ai "Projects" folders.
- **Your worry about usage is justified, and Anthropic says so itself.** A project "draws on the same plan limits as your other Claude Code sessions and uses them faster". By default every thread runs on **Opus at high effort**, "which draws on your plan fastest". The only hard limit is **200 new threads a day**. Limits you set in conversation ("at most two threads") are "a preference rather than a cap". A thread that hits your limit **waits and carries on automatically when the limit resets**, spending your next window without asking.
- **It is a poor fit for most GWTH work.** Cloud threads run in a 4 vCPU / 16 GB Ubuntu VM with no GPU, need a GitHub.com repo, and cannot see hlab, the P520 GPU, Kokoro/dots.tts, `/data`, Coolify or Tailscale. Threads on your own machine are possible through Remote Control, but they skip project memory, re-ask approval for every thread, and have open bugs (instructions cut off at 8 KB, the picker lists cloud environments only).
- **The ideas are worth copying, and you already have about 70% of the plumbing.** Beads, the hub Run button, the cockpit, Firstmate, `ship.py` and `flash-worker` cover most of it. What Projects does better is put **one front door**, **one set of states**, **one shared memory** and **resumable workers** on top. What you already do better is **hard spending control**, **local hardware**, **mixing models** (flash-worker, Codex) and **proof before "done"**.
- **My recommendation:** don't adopt Projects. Lift six patterns from it into the current setup, in this order:
  1. Hard spending guards.
  2. One set of states and one "what needs you" page.
  3. Shared project memory for headless workers.
  4. A coordinator session.
  5. Warm-resume workers.
  6. Slimmer instructions.

  Section 7 has the detail and the order.

## 2. What Claude Projects actually is

All of this was checked against the official docs on 17 Oct 2026. Quotes are verbatim.

| Concept | What the docs say | Note |
|---|---|---|
| Project | "one ongoing conversation where Claude coordinates a stream of related work for you" | Single user. Not shareable during the beta. |
| Coordinator (the project conversation) | "decides what becomes a thread, and keeps track of every thread it started. It sees what threads report back, not every step they take." | Defaults to **Opus, low effort**. Has no connectors of its own. |
| Threads | Each is "a separate session with its own context window that does one piece of work and reports back". A cloud thread works on its own branch and PR. | Defaults to **Opus, high effort**. Threads can use subagents and workflows internally. |
| Goal | One optional line the project works towards. | |
| Project instructions | "Text sent to each new thread and to Claude in the project conversation, up to 16,000 characters." | The equivalent of a CLAUDE.md for the whole project. |
| Project memory | Notes on "requirements, decisions, and pitfalls, stored as files. Every cloud thread reads the index file `MEMORY.md` when it starts and opens the other files when it needs them." | Separate from repo `CLAUDE.md`. Rule of thumb: repo facts go in CLAUDE.md, project facts go in memory. |
| Context / Library | Repos, files, folders and Drive folders you add, plus the files threads produce. | Uploads are copies, with size caps. |
| Thread states | **Ready for review**, **Waiting on you**, **Working**, **Landing**, **Idle**, **Resolved**. A thread resolves itself "after a week with no activity". | The Overview pane groups threads by these states. |
| Suggested threads | Claude proposes threads; you start each one with a click. | |
| Thread actions | Resolve conflicts, Fix CI, Address comments, Merge it, Review PR, Create PR. | Auto-fix is always on for a thread's PR. |
| Steering | Plain language, e.g. "Propose threads and wait for my go-ahead", "Run at most two threads at a time", "Only post when something finishes or is blocked". | Saved to project memory, but "not enforced settings". |
| Context management | "You don't manage context windows in a project. Threads compact automatically, and the conversation works from recent messages, recent threads, and project memory rather than its full history." | "Put anything that must never be dropped in project memory." |
| Routines | Scheduled work inside a project runs as threads in that project. | A routine-started thread **stops** at the usage limit instead of waiting. |
| Local threads | **Work locally** runs a thread on your machine through Remote Control. It uses that machine's files, MCP, hooks and permissions. | It "starts with the project's instructions, but not with its memory files loaded" and only runs while the machine is awake. |
| Where you use it | claude.ai/code, the desktop app Code tab, iOS and Android. | Not the terminal CLI or the IDEs. Anthropic models only. |

### How it relates to what you know

- **Subagents** live inside one session and hand a summary back. Threads are whole sessions that persist and that you can talk to directly.
- **Agent teams** form one session's team for one task and end with that task. A project goes on indefinitely.
- **Workflow tool**: "a script holds the plan instead of Claude's turn-by-turn judgment". A thread can run one.
- **Routines and cloud sessions** are the building blocks. Every cloud thread is a cloud session.
- **claude.ai chat Projects** are the old folders of conversations and reference files, with no coordinator. They are being converted, and some users report it happened without an opt-out (GitHub issues #99554 and #101369).

## 3. What the video adds (Chase AI, 16 Oct 2026)

Chase walks through the settings, gives his advice, and builds an "AI Creator Radar" dashboard in a 25-minute demo. That build split into five parallel threads: dashboard, X scanner, YouTube coverage, content packs and Claude Code news. Two came back ready for review and three were blocked on API keys or decisions. The X scanner ran as a **local** thread because it needed his logged-in browser, and it set up a local scheduled routine. Points worth keeping:

- **Coordinator on low effort** [8:20]. "It's not really the one doing the work. It's just the one coordinating." The docs agree; it is the default.
- **Thread model: drop to medium, or Sonnet** [8:55], because "you could have 5 10 15 sessions … all doing stuff at the same time 24/7". The docs' default is Opus **high**, so the cost-conscious move is to change it.
- **Project instructions: "less is more"** [9:40]. Only put in what must apply to every thread.
- **Blockers come back to you** [13:20]. The useful UX is a list of what is waiting on you, each item with its own steer box.
- **Debug access between projects** [11:50]. One project can inspect another whose context is "poisoned". This is not in the docs page as checked (unverified), but the idea is the same as your fresh-eyes reviewer (`hub_review.py`, `qa_chain.py`).
- **Boris Cherny uses Projects as a backlog "dumping ground"** [4:50]. Unverified, but it describes a real pattern: tasks go to the coordinator, not to sessions you manage yourself.

Corrections to the video:

- "First came out a couple months ago" is wrong. It launched 17 Sep 2026.
- "They let everybody off the wait list" is not quite right. The docs still describe a gradual rollout and a waitlist.
- "Runs 24/7, never shut off" is overstated. Sandboxes pause between turns. A lost sandbox can drop uncommitted work. Idle threads resolve after a week.
- "Share context and memory" is only partly true. Threads share project **instructions** and project **memory**. They do **not** share context windows; the coordinator sees only their reports.

## 4. The usage question, answered

| What uses your plan | Why it matters to you |
|---|---|
| Every running thread is a full session on Opus high by default | 5 to 15 parallel Opus-high sessions is the fastest burn there is. Your rule 09 (latest Opus, high) would make it worse inside Projects. |
| The coordinator's own tokens | Small at low effort, but it never stops while work flows. |
| Idle threads watching a PR **wake on CI failures and review comments** | Spending you did not ask for. You must tell each thread to stop watching. |
| Hitting the limit: the thread **retries and continues when the limit resets** | Your next 5-hour or weekly window gets spent on old work without a word. Only Stop or Pause prevents it. |
| Reviving a thread idle for more than an hour (the cache lifetime) re-reads its whole conversation | Cold follow-ups are expensive. The docs advise starting a fresh thread instead. |
| Usage credits | A project can only go past your plan limits if you have turned usage credits on. "A thread can't turn them on for you." |
| Concurrency | No cap except **200 new threads a day**. Your "max two" is a preference. |

What you get in return: a **Usage** tab showing tokens per thread, per model and for the coordinator. An idle or archived project uses nothing.

Third-party numbers: I found **no credible measured report** (percent of the weekly limit per thread, or tokens per project). The press repeats Anthropic's "reach limits faster" line. The Register's headline was "work and pay in parallel". For scale, the docs' general cost page puts agent teams at about **7x** the tokens of a single session in plan mode.

**Bottom line:** compared with your setup, Projects moves control from *code you own* to *preferences Claude keeps*. Your setup is the opposite: locks, queues, single writers and timeouts. That is your advantage, and it should get stronger, not weaker.

## 5. Why not just use it (fit with GWTH)

| GWTH need | Projects today |
|---|---|
| TTS (Kokoro, dots.tts voice clone), GPU image and video, Remotion renders | No GPU in cloud VMs. A local thread is possible but immature (see below). |
| Files on hlab: `/data`, the pipeline dirs, Qdrant, NiceGUI dashboard | Cloud threads can't reach them. Upload copies are capped (100 files, 2 GB, 480 MB per file). |
| Deploys: Coolify, Hetzner, `ship.py` probes on Tailscale URLs | No Tailscale. The network goes through Anthropic's proxy, and `gh` GraphQL is blocked. |
| Your user-level rules, skills and hooks (`~/.claude/…`) | **Not loaded** in cloud threads. Only repo-level `.claude/` and claude.ai account skills are. |
| Cheap lanes (flash-worker on DeepSeek, Codex checks) | Anthropic models only. |
| Hard caps on spend and concurrency | Preferences only, apart from 200 threads a day. |
| Proof before "done" (hlab probe, then Hetzner probe) | Its "done" is a merged PR. Nothing checks that the change is live. |
| Remote access from your phone | You already have this: cockpit `/m/`, Web Push, Telegram. |

Local threads through Remote Control are the bridge, but as of today:

- **No project memory** in local threads.
- **Instructions cut off at 8,192 bytes** (#101398).
- **A device approval for every new thread** (#101368).
- **Cloud environments only in the environment picker**, and bypass mode is not honoured (#101539).
- **Auto-mode classifier blocks** on work you had already approved (#96775, #98355, #97947).

Check again in a couple of months. It is the part that would make Projects relevant to you.

## 6. Concept-by-concept: what you have, and the gap

| Projects concept | What GWTH has today | Gap | Worth copying? |
|---|---|---|---|
| **One coordinator conversation** (routes only; reads reports, not transcripts) | Coordination is spread over the board (:8090), hub Run, cockpit and `/m/`, `bd ready`, Telegram and chat sessions. Firstmate's decompose step is one call, not a standing coordinator, and isn't wired to beads. | **No single front door.** You are still the coordinator. | **Yes** (R4) |
| **Threads = persistent, messageable sessions** | Night, track and hub runs start fresh by design. Only Firstmate keeps `session_id` and `--resume`s, and only after an escalation. `scheduled_prompts/now/*-resume.md` are hand-written resume prompts. | Can't follow up with the worker that did the job. | **Yes, carefully** (R5) |
| **One set of states**: Working / Waiting on you / Ready for review / Landing / Idle / Resolved, with a week to auto-resolve | Six vocabularies: board `blocked`, beads states, ship ledger `awaiting_review/sent_back`, verify verdicts, Firstmate `escalated`, cockpit `needs_input`. `ship.py brief` already parks after 7 days. | The same item shows different states in different places. | **Yes** (R2) |
| **Project memory** (`MEMORY.md` index; every worker reads it at start; any worker can add to it) | CLAUDE.md, bible, wiki, `bd remember`, yaml overlays. Headless workers read files but never write memory back. | Lessons a night run learns die with it. | **Yes** (R3) |
| **Project instructions ≤ 16,000 characters** | A GWTH-launch-plan worker loads **about 86,000 characters** at start: project CLAUDE.md 53k (883 lines), global 11.5k, rules 21k. | 5x Anthropic's ceiling. It costs tokens on every run and dilutes attention. | **Yes** (R6) |
| **Suggested threads**: Claude proposes, you click to start | Firstmate shows a DAG to approve. `whats_next.py` ranks beads. The 2026-09-07 rule: one decision at a time. | Already close. It needs to live behind the coordinator. | Folded into R4 |
| **"What needs you" Overview** | The one-line hand-over rule (2026-09-25), the cockpit lanes, the `ship.py brief` hook. | Good. It just needs the single state model under it. | Folded into R2 |
| **Per-thread usage view** | `usage_collector.py` covers Claude, Codex, OpenRouter and GPU at account level. The Claude lane has been stale since 2026-07-25. No per-run tokens. No `--max-turns` on workers. | You can't see what a bead cost, and the Claude meter itself may be wrong. | **Yes, first** (R1) |
| **Auto-continue on limit reset** | A limit hit means a failed run and a retry next night. The collector knows reset times but nothing schedules against them. | It is a gap, but Projects' version is the dangerous one. | **Only opt-in and capped** (R1) |
| **Branch or worktree per thread, one owner per PR** | Night, track and hub share one working tree per repo, serialised by locks. Only Firstmate uses worktrees (max 3). | Limits parallelism, but it is also what keeps spend low. | Later, and only for chosen lanes |
| **Idle threads wake on CI or comments** | No equivalent. | The equivalent would be a cost trap. | **No** |
| **Local thread via outbound-only connection** | Everything already runs on hlab. | None. | Nothing to copy |
| **Debug access across projects** (video) | `hub_review.py`, `qa_chain.py` (fresh-eyes reviewers). | None. | Already have it |
| **Routine threads stop at the limit, chat threads wait** | Night runs stop at the limit. | A sensible split. Keep it. | Already have it |

## 7. Recommendations, in order

Each recommendation lists what to build, where it goes, the cost to build it, and what it saves or adds in usage.

### R1. Hard spending guards before anything else
*Projects' weakest point is your strongest. Make it explicit.*

- **Fix the Claude usage lane first.** It has been stale since 2026-07-25, so every decision about spend is currently made blind. Re-auth on hlab, then confirm `usage_collector.py` reports live weekly and 5-hour percentages.
- **Per-run budget.**
  - Every headless `claude -p` the board starts (`run_scheduled_prompt.sh`, `run_track_pipeline.sh`, `hub_run_session.sh`, Firstmate `run_worker.sh`) gets `--max-turns` plus the existing timeout.
  - Read the `usage` block from stream-json and record tokens per run in `hub_runs.yaml` against the bead id.
  - That gives the "tokens by thread" view Projects has, but per **bead**.
- **A start gate.** No new worker starts while the weekly Claude meter is above a threshold you choose (say 80%), or the 5-hour one above 90%. This is enforced in code, in one shared helper called by every runner. It is not a prompt.
- **A Pause-all switch.** One cockpit button and one CLI flag that stop the queues from starting anything and leave running jobs to finish. This is Projects' "Pause project", across all lanes.
- **Resume-at-reset, opt-in per job.** A job can carry `resume_at_reset: true` with a spend ceiling. The watchdog arms it at the reset time from the collector. The default stays as it is today: a limit hit is a failure, and you decide.
- **Effort per lane.** Your rule 09 says every Claude task runs on the latest Opus at high effort, and only you can change that. Projects' own guidance is low effort for coordinating and smaller models for mechanical work. Changing it is your call (see the questions at the end).

*Build: about a day, mostly in GWTH-launch-plan `scripts/`. Usage: saves. It is the only item that reduces spend directly.*

### R2. One set of states and one "what needs you" page

- **Adopt Projects' vocabulary as the canonical set, mapped onto what exists:**

  | State | Meaning |
  |---|---|
  | Proposed | Suggested, not started |
  | Working | Running |
  | Waiting on you | Needs a reply or approval, or failed |
  | Ready for review | On hlab and probed |
  | Landing | Approved, publishing to Hetzner |
  | Idle | Finished, nothing outstanding |
  | Resolved | Live and proven, or parked after 7 days |

- **Mapping:**
  - beads → `bd set-state <id> lane=…`
  - ship ledger: `on_hlab` / `awaiting_review` → Ready for review; `approved` → Landing; `done` → Resolved
  - Firstmate `escalated` and cockpit `needs_input` → Waiting on you
  - board `blocked` → Waiting on you
- **One writer** turns the mapping into one view: a `scripts/lanes.py` read model, not a new store. The cockpit's lanes view renders it. The end-of-session one link can then always point at "Waiting on you" filtered to that item.
- Night-run blockers currently come back as failures plus Telegram. Make them **questions** that land in Waiting on you, the way Firstmate's `fm_escalate.py` does: write a wip commit, write the question, exit, resume on the answer.

*Build: one to two days. Usage: neutral. Value: fewer "where is that?" moments, which was the reason for the 2026-09-25 rule.*

### R3. Project memory that headless workers both read and write

- **Create `GWTH-launch-plan/memory/`** with a `MEMORY.md` index and one file per fact: requirements, decisions, pitfalls. Use Claude Code's own memory file format so it works the same everywhere.
- **Every worker prompt** the board builds starts with "read `memory/MEMORY.md`, open the files you need". It is cheap: an index of one-liners, with files opened only on demand.
- **Workers propose, one writer commits.**
  - A completion packet gets a `## Memory proposals` section.
  - `hub_review.py` (already a fresh-eyes gate) accepts, merges or rejects proposals.
  - `scripts/project_memory.py` is the only writer, in keeping with your single-writer rule.
- **Keep the split Projects uses:**
  - Facts about a **repo** stay in that repo's CLAUDE.md.
  - Facts about the **project**, which span GWTH_V2, the pipeline and launch-plan, go in project memory.
  - Taste and style decisions stay in the **bible**. Reference knowledge stays in the **wiki**.
- Today, lessons a night run learns (a gotcha, a corrected path) die with that run. This keeps them, and it is the main way Projects avoids repeating mistakes.

*Build: about a day. Usage: saves over time (fewer repeated mistakes and re-runs), plus a small per-run read cost.*

### R4. A coordinator session: one front door for big projects

- **A long-running local Claude Code session named "GWTH Coordinator"**, started from a `coordinator` skill. It runs on hlab, so it has everything local. Its whole job is routing:
  - answer quick questions itself;
  - turn new work into beads;
  - **propose** workers and wait for your go, which matches the one-decision-at-a-time rule;
  - dispatch through the existing `hub_run.py` queue;
  - read **completion packets and reports, never worker transcripts**;
  - keep `memory/` current;
  - give you the one-line hand-over.
- **It doesn't build anything.** Projects' coordinator is cheap because it only routes. If it starts reading diffs and fixing code itself, it becomes another expensive worker.
- **Its context survives** the way Projects' does: recent messages, plus the lanes view (R2), plus project memory (R3), not its full history. When it compacts, nothing important is lost because the important things are in files.
- **You reach it from your phone** through the cockpit channel and `/m/`, which already exist. The channel needs the dev-channels flag, so this is the place to harden that.
- Start with GWTH. The same skill works for any big project with beads and a board (Jobs_LinkedIn, model-bakeoff).

*Build: two to three days (skill, prompt, wiring to hub_run and the lanes view). Usage: small and steady if it routes only. This is the one to watch in R1's per-run numbers.*

### R5. Workers you can follow up with: warm resume, cold restart

- **Record `session_id` per bead** for every headless run. Firstmate already does this; extend it to `hub_run`, night and track runs, stored in `hub_runs.yaml`.
- **The cache-lifetime rule from the Projects docs:**
  - A follow-up on the same bead **within an hour** of its last turn: `claude -p --resume <sid>`. The cache is warm and the context is kept.
  - **Older than an hour:** start fresh with a hand-over note made from the completion packet and memory. A cold resume re-reads the whole conversation at full price.
- **Optional named standing workers per area**, such as "website", "pipeline-audio" and "films", each holding its last `session_id`. That is the closest local equivalent of Projects' "reuse an existing thread for follow-ups in the same area". The same warm/cold rule applies.
- **Talk to a worker directly** from the cockpit by sending to that bead's session (resume plus a message). This replaces hand-written `*-resume.md` prompts.

*Build: about a day. Usage: saves on warm follow-ups. The cold rule prevents the expensive case.*

### R6. Slim the instructions every worker loads

- **Today:** about 86,000 characters before a GWTH-launch-plan worker does anything. Projects caps project instructions at **16,000**, and Chase's advice is "less is more".
- **Target:** under 20,000 for what every worker loads.
  - Move the long procedures in the 883-line `GWTH-launch-plan/CLAUDE.md` (ship ledger detail, night scheduler, cockpit channel) into on-demand skills. This is the same move that took kanban-gates and infrastructure out of the always-on rules in June.
  - Keep CLAUDE.md to goals, routing and the non-negotiables.
- **Guard it:** a check in the existing wiki lint that fails if always-loaded instructions exceed the budget.

*Build: half a day, plus your review of what moves. Usage: saves on every single run, with no change in behaviour.*

### What not to copy

- **Idle workers waking on CI failures or review comments**: automatic spend you didn't ask for.
- **Soft concurrency caps**: keep yours in code (`fleet.py` max 3, the hub's FIFO queue, the repo lock).
- **Opus-high everywhere for every task**: the docs call it the fastest burn. flash-worker and Codex already give you cheaper lanes Projects can't use.
- **Auto-continue by default.** Opt-in only (R1).
- **"Merged PR = done".** Your hlab probe → approve → Hetzner probe stays the definition of done.

### Optional: a capped one-week pilot of the real thing

Only if you want first-hand numbers. Use one cloud-safe repo: a GWTH_V2 UI task with no secrets and nothing on hlab. Set these in Project settings and project instructions:

- **Thread model:** Sonnet, medium.
- **Coordinator:** low.
- **Instructions:** "Propose threads and wait for my go-ahead. At most two at a time. Stop watching PRs when idle."
- **Usage credits:** off.

Record the weekly-limit % before and after. **I don't recommend doing this now.** The patterns above get most of the value without the risk.

## 8. Suggested order and size

| Step | What | Size | Usage effect |
|---|---|---|---|
| 1 | R1 Spending guards (fix the meter, per-run tokens, start gate, Pause-all) | ~1 day | Saves |
| 2 | R6 Slim instructions to ≤ 20k characters | ~½ day | Saves on every run |
| 3 | R3 Project memory read and written by workers | ~1 day | Saves over time |
| 4 | R2 One set of states and the "Waiting on you" view | 1 to 2 days | Neutral |
| 5 | R5 Warm resume / cold restart per bead | ~1 day | Saves |
| 6 | R4 Coordinator session | 2 to 3 days | Small, steady; measure with R1 |

R1 comes first because every other change is easier to judge once you can see what each run costs. R4 comes last because it depends on R2 and R3 being in place.

## 9. Decisions that are yours

These go to you one at a time in chat. They are listed here for the record.

1. Which recommendation to build first. Mine: R1.
2. Whether the coordinator (R4) may run below "Opus high", given rule 09.
3. The start-gate thresholds (R1): what weekly percentage stops new workers.
4. Whether to run the optional pilot at all.

## 10. Sources (checked 2026-10-17)

- Claude Code Projects docs: https://code.claude.com/docs/en/claude-projects
- Launch post: https://claude.com/blog/projects-redesigned
- Cloud environments (VM size, network levels, proxy): https://code.claude.com/docs/en/cloud-environments
- Remote Control: https://code.claude.com/docs/en/remote-control
- Self-hosted environments (Team/Enterprise beta): https://code.claude.com/docs/en/self-hosted-environments
- Costs and usage credits: https://code.claude.com/docs/en/costs
- Running agents in parallel (comparison): https://code.claude.com/docs/en/agents
- Routines: https://code.claude.com/docs/en/routines
- VentureBeat launch coverage: https://venturebeat.com/orchestration/anthropic-launches-claude-code-projects-an-always-on-conversation-that-remembers-and-delegates-your-long-running-dev-work
- The Register: https://www.theregister.com/a/5297532
- Implicator (Opus default, local mode "coming soon" at launch): https://www.implicator.ai/anthropic-claude-code-projects-opus-default/
- SSD Nodes on threads and usage limits: https://www.ssdnodes.com/learn/claude-code-projects-threads-and-usage-limits
- GitHub issues: [#101398](https://github.com/anthropics/claude-code/issues/101398) (8 KB instructions), [#101539](https://github.com/anthropics/claude-code/issues/101539) (environment picker), [#101368](https://github.com/anthropics/claude-code/issues/101368) (device re-approval), [#99091](https://github.com/anthropics/claude-code/issues/99091) (stuck threads), [#102395](https://github.com/anthropics/claude-code/issues/102395) (connectors missing), [#96775](https://github.com/anthropics/claude-code/issues/96775) (classifier blocks), [#101369](https://github.com/anthropics/claude-code/issues/101369) (chat projects converted)
- Video: Chase AI, "Claude Code's Secret Upgrade Is an Orchestration Beast", https://www.youtube.com/watch?v=mKjxGy6vCnY. Transcript and research: [`../youtube/2026-10-17_claude-code-s-secret-upgrade-is-an-orchestration-beast/`](../youtube/2026-10-17_claude-code-s-secret-upgrade-is-an-orchestration-beast/research.md)
- Current-setup map: read-only survey of GWTH-launch-plan (CLAUDE.md, `scripts/ship.py`, `hub_run.py`, `hub_review.py`, `run_scheduled_prompt.sh`, `run_track_pipeline.sh`, `cockpit_daemon.py`, `usage_collector.py`), firstmate (`lib/fleet.py`, `run_worker.sh`), claude-code-setup (`kanban/run-kanban.sh`) and `~/.claude/` on 2026-10-17.
