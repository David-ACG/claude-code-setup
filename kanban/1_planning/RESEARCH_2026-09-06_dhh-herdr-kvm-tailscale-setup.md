# RESEARCH — DHH's "16 agents, Herdr, KVM, Tailscale" setup vs David's P520 + desktop-app workflow

**Date:** 2026-09-06
**Source video:** "DHH's new setup for programming with AI - terminal, 16 agents, Herdr, Tailscale" (Lex Clips, 12:42, `4Xg1AE6Uu1k`), cut from Lex Fridman Podcast #501 (26 Aug 2026, chapter "Programming setup for AI agents" at 01:35:40; full transcript at https://lexfridman.com/dhh-2-transcript/).
**Transcript fetched via:** TranscriptAPI.com (`transcriptapi.com/api/v2/youtube/transcript`, key from the pipeline container). Saved at [kanban/research-docs/dhh-setup/transcript_4Xg1AE6Uu1k.md](../research-docs/dhh-setup/transcript_4Xg1AE6Uu1k.md).
**Browser version of this doc (Tailscale):** https://hlab.taila51191.ts.net:9459/dhh-setup/
**Video-centric research (yt-research skill layout, with claims table and full transcript):** [research.md](../research-docs/youtube/2026-09-06_dhh-s-new-setup-for-programming-with-ai-terminal-16-agents/research.md) · https://hlab.taila51191.ts.net:9459/youtube/2026-09-06_dhh-s-new-setup-for-programming-with-ai-terminal-16-agents/research.html
**Questions asked:** similar KVM/IP setup with the P520 over the existing tailnet; advantages; costs; the workflow if Claude Code Desktop + Codex Desktop replace Herdr; whether to use Herdr at all given a GUI/design-heavy way of working; and how to use Codex much more without it dragging the laptop down.

---

## 0. TL;DR for Claude Code sessions

1. **David already has the architecture DHH describes**, minus the multi-machine part and the KVM. Claude Code Desktop SSH sessions run their engine on hlab (`~/.claude/remote/ccd-cli/*` processes), and the Codex desktop app on x1eg3 is **already SSH-connected to hlab** (`codex app-server --listen unix://` spawned by the app's `CODEX_REMOTE_PAYLOAD` bootstrap, `SSH_CLIENT=100.114.161.65`, up ~2 days at time of writing). So "the agent runs on the P520, the laptop is a thin client" is already true for both tools.
2. **The laptop slowdown is not Codex compute.** It is (a) the unified ChatGPT/Codex Windows app shell itself (documented WMI process scans + `git.exe`/`conhost.exe` storms + Defender load, present even when idle; openai/codex #29949, #33711) and (b) the x1eg3's Thunderbolt controller fault loop (see memory `x1eg3-thunderbolt-fault`), which drags the whole machine regardless of Codex.
3. **Do not adopt Herdr as the primary cockpit.** It is a Rust terminal multiplexer (tmux reimplemented with agent-state sidebar + ding). It is single-host per client, TUI-only, and would reverse the GUI-committed decision. Its value (state per session, worktree per session, notify on done/blocked) is already native in both desktop apps. Optional later: Herdr on hlab purely as the persistence layer for headless runs, replacing tmux, because its socket API can push "done/blocked" events into the :8090 board or ntfy.
4. **A KVM is insurance, not throughput.** It adds out-of-band control (BIOS, hung box, reinstall, "Tailscale is down on the host") for one always-on server. Worth it only if the P520 must survive unattended while David travels. Costs and options are in §4.
5. **The real DHH lesson for David is parallelism + notification, not hardware.** The P520 (8c/16t Xeon W-2145, 125 GB RAM, RTX 3090 + 3060, 2.5 TB free) can host 16 agent sessions on its own; agent sessions are API-bound, not CPU-bound. What is missing is a "ding" that reaches him wherever he is and a single place that shows which sessions need him. §5 gives the concrete wiring using hooks in both tools.

---

## 1. What DHH actually described (12-minute clip, paraphrased)

| Element | What he said (paraphrased) | Notes |
|---|---|---|
| Mental shift | From single-threaded "flow" to parallel processing: waiting on one agent feels unproductive, so run a handful and stay busy making decisions and unblocking them. | The core argument. |
| Cockpit | Terminal only. Started with tmux panes/tabs; moved to **Herdr** ("tmux plus agent notifications": goes *ding* when an agent is done or needs a decision, tracks working vs not). He runs **multiple Herdr setups, one per machine**. | He rejects the Claude Code app and Codex app explicitly ("I love that this revolution was kicked off in the terminal"). |
| Hardware | Bought **GL.iNet Comet** KVMs: plug HDMI + USB into each machine, open a web page, log in once, control it. Connected **four mini PCs from his closet** this way. | Multi-core analogy: "what if I had 16, 32, 64 cores". |
| Network | **Tailscale** (WireGuard) makes every machine in Malibu and Copenhagen look local from his phone, no firewall holes. It "decreases the friction to get new compute online". | David already runs this (`hlab.taila51191.ts.net`). |
| Scale | ~4–5 machines × ~3 agents ≈ **16 threads** at current agent speed; output went from ~20–30 hand-written lines/hour to hundreds/hour (he disowns lines-of-code as a metric). | In the full episode he says he runs Claude in the top pane and Codex in the bottom pane inside Herdr. |
| Review | Neovim as a project browser + lazygit; **hunk** for diffs, but he prefers seeing surrounding untouched context, so Neovim wins. | hunk is a TUI diff viewer (hunk.dev), Omarchy 4 default. |
| OS | Linux, because agents "love the Unix philosophy": everything is a config file or CLI tool; Mac/Windows/WSL are worse (WSL "is a sandbox"). | Omarchy 4 "Quattro" ships Herdr and hunk. |

---

## 2. What David has today (verified on hlab, 2026-09-06)

| Item | Fact |
|---|---|
| Server | Lenovo ThinkStation P520 (`30BFS0R700`), Xeon W-2145 8c/16t @ 3.7 GHz, 125 GB RAM, RTX 3090 24 GB + RTX 3060 12 GB, 3.6 TB NVMe (2.5 TB free), Ubuntu, uptime 8 days, load ~1. BIOS S03KT58A (03/2023). `/dev/mei0` present (Intel ME), so AMT/vPro is hardware-plausible but provisioning is **unverified** (see §4.3). |
| Tailnet | `hlab` = 100.79.248.39 / `hlab.taila51191.ts.net`; peers: `x1eg3` (David's laptop, direct connection), `acg-proxmox1` (tagged), `david-x1-gen7`, `p53` (offline 68 d), Pixel 9 Pro. 36 `tailscale serve` HTTPS ports already in use (8101, 8444/5, 9443–9477). |
| Claude Code | Desktop app on x1eg3 → SSH environment on hlab. Engine processes on hlab: `~/.claude/remote/ccd-cli/2.1.247…2.1.260`, server `~/.claude/remote/srv/*/server --serve`. CLI 2.1.170 in `~/.local/bin`. Each Desktop session gets its own git worktree; hooks are shared CLI + Desktop. |
| Codex | CLI **0.144.1** on hlab (latest 0.153.4; GPT-6 Astra became the default picker entry in 0.153.4 → upgrade). `~/.codex/config.toml`: `model = "gpt-5.6-sol"`, `model_reasoning_effort = "high"`, `service_tier = "priority"`, 11 trusted projects. **Codex desktop app on x1eg3 is SSH-connected to hlab**: `codex -c features.code_mode_host=true app-server --listen unix://` running under systemd (PPID 1), bootstrapped by the app's `CODEX_REMOTE_PAYLOAD` script with a forwarded SSH agent. Port 9234 (the remote-bootstrap loopback port from openai/codex #18503) is free on hlab. |
| Current Codex pattern | Claude Code on hlab calls Codex (`codex exec` / subprocess) for specific pieces of work. |
| Laptop | x1eg3 (ThinkPad X1 Extreme Gen 3, Windows, user `ducce`). Known fault: Titan Ridge Thunderbolt controller in a continuous fault loop (~37 `nhi` events/min, xHCI in Error state) — memory `x1eg3-thunderbolt-fault`. |
| Existing fleet tooling | Firstmate Fleet at :8091 (headless `claude -p` workers in worktrees), launch board at :8090/:8101, `ship.py` ledger. |

**Implication:** structurally David is already "DHH with one big machine and two GUIs". The remaining gaps are notification, a single "who needs me" view, out-of-band recovery, and the laptop's own health.

---

## 3. Herdr — what it is and whether to use it

**Facts** (herdr.dev, github.com/herdrdev/herdr; author Can Celik, Herdr Inc., YC F26; Apache-2.0 since Jul 2026; free, no account, no telemetry; Rust single binary ~10 MB; Linux/macOS/Windows native; `curl -fsSL https://herdr.dev/install.sh | sh`).

- A **terminal multiplexer** with a server/client model like tmux (detach/reattach), not a wrapper around tmux and not a GUI.
- Sidebar shows each pane's agent state: `working / blocked / idle / done / unknown`. Detection uses agent lifecycle hooks where available (Claude Code hooks are authoritative) and TOML "screen manifests" (pattern-matching the bottom of the screen) for agents without hooks. 21 agents auto-detected including Claude Code, Codex, Gemini CLI, Cursor, Copilot, Kiro CLI.
- Notifications on `done` and `blocked`: in-app toast, terminal OSC (works over SSH), OS notification, or off; mp3 sounds. Telegram/Slack/phone only via community plugins (plugin marketplace ~980 entries).
- Automation: `herdr agent start|prompt|send-keys|wait|read`, Unix-socket JSON API with `events.subscribe` (this is the interesting bit for David's board).
- **Multi-machine:** `herdr --remote user@host` turns the local Herdr into a thin client for **exactly one** remote server. No multi-host view yet (GitHub Discussion #515: "top priority", needs a rewrite). DHH's "multiple Herdr setups" therefore means one Herdr per mini PC reached over Tailscale. Windows can be a `--remote` client but not a target.
- GUI options are all community: Herdr Studio (web), Collie (PWA over `tailscale serve`, push when an agent blocks), Moshi (iOS). None official.
- Comparables: Agent of Empires (tmux TUI + web dashboard), Claude Squad (tmux TUI), Conductor (Mac, Pro $50/mo), Mux by Coder (Electron + browser, SSH remote workspaces), cmux (Mac), Vibe Kanban.

**Verdict: no, not as the cockpit.**

| Herdr gives DHH | David already gets it from |
|---|---|
| Pane per agent with working/blocked/done state | Claude Code Desktop sidebar (filter by status, OS notification when a non-visible session finishes); Codex app thread list (attention indicators, system notification on finish/needs approval) |
| Worktree per agent | Both apps create a git worktree per session/thread automatically (Desktop: `<root>/.claude/worktrees/`; Codex: `$CODEX_HOME/worktrees/`) |
| Detach/reattach survives disconnect | Desktop SSH engine keeps running through dropped SSH, sleep or app quit; Codex app-server likewise |
| Ding | Missing today → §5 |
| One view across Claude + Codex | Missing today (Herdr has it, but only for one host and only in a terminal) → §5 |

Herdr would cost David the voice input, paste, split view, dispatch and phone surfaces of the Desktop apps, for a state sidebar he already has. That contradicts the standing decision recorded in memory `gui-committed-workflow`.

**Where Herdr could still earn a place (optional, later):** on hlab as the *persistence layer* for headless/overnight runs instead of tmux. It is tmux with a state API: a small script subscribed to `events.subscribe` could push `blocked/done` into ntfy/Telegram or the :8090 board. Revisit when (a) Herdr ships the multi-host view or (b) David adds a second agent machine.

---

## 4. KVM-over-IP for the P520

### 4.1 What a KVM adds over what David already has

Everything used today (SSH over Tailscale, Desktop SSH sessions, Codex app-server over SSH, Tailscale serve pages) is **in-band**: it needs the kernel, networking, `tailscaled` and sshd alive. A KVM-over-IP box is a fake monitor plus fake keyboard with its own network stack, so it works when none of those are true.

Only a KVM (or AMT) helps with: a hung/OOM-wedged box (hard reset via ATX header, watch it POST); boot failures after a kernel/NVIDIA DKMS update (GRUB rescue, initramfs, fsck prompt, emergency shell); Tailscale or networking broken on the host (the one failure that removes every in-band path at once); BIOS/UEFI changes and firmware updates; reinstalling or rescuing Ubuntu from a mounted ISO; cold power-on after a power cut when WoL does not fire.

**Honest value for hlab:** a handful of uses per year. Each of those is currently "wait until home" or "ask someone to press the button and describe the screen". With a Comet it becomes a two-minute fix from the laptop anywhere, and risky remote operations (kernel/driver upgrades, BIOS tweaks, disk migrations) become safe to do from Copenhagen-style distance. It adds **zero agent throughput**. Cheaper partial insurance: a Tailscale-reachable smart plug plus BIOS "power on after AC loss" gives the hard-reboot half for ~£10, with no screen.

### 4.2 GL.iNet Comet (what DHH bought)

| Model | UK price (seen 2026-09-06) | Key facts |
|---|---|---|
| Comet GL-RM1 (V2, ARM64, no PoE, small eMMC) | ~£96 (snippet; US $89.99) | 4K@30 in, USB-C HID, ~30–60 ms latency, 5 V/2 A USB-C power (**not** a USB-PD charger). V1 was ARM32 and had a Tailscale 1.90.1 breakage (fixed next day). |
| **Comet PoE GL-RM1PE (recommended)** | ~£107 (snippet; US $109.99) | Quad A53, 1 GB, **32 GB eMMC** (fits an Ubuntu ISO), PoE or USB-C, 4K@30 / 2K@60, ~3× faster file transfer than V1. |
| Comet Pro GL-RM10 | £172.99 (verified gl-inet.com/en-gb) | Wi-Fi 6, touchscreen, HDMI passthrough, no PoE. Only if the P520 has no spare Ethernet run. |
| ATX board GL-ATXPC | $15.99 (≈£13–16, GBP unverified) | Wires to the motherboard front-panel header: power/reset from fully off, force-off (6.5 s). Recommended over WoL. Fingerbot FGB-01 ($29.99) presses the physical button instead. |

- **Tailscale runs on the Comet itself** (Apps Center → Tailscale → bind once), so it becomes its own tailnet node at `https://glkvm.<tailnet>.ts.net`; no GL.iNet cloud account needed. Exit node / subnet routes supported. Updates via `tailscale update` in the web terminal. Docs: https://docs.gl-inet.com/kvm/en/faq/remote_access_via_tailscale/
- Virtual media: read-only ISO mount at BIOS/UEFI level plus a read-write virtual USB drive; EDID presets/custom EDID (so **no HDMI dummy plug needed**); 2FA; custom TLS cert; root web terminal; two-way audio; OCR.
- Because hlab is on the home LAN at 192.168.178.50, the Comet is reachable on the LAN even when the P520's own Tailscale is dead.
- Nits (ServeTheHome): pings public DNS/STUN even in local-only use; UI is a closed fork of PiKVM.

### 4.3 Alternatives

| Device | UK price | Tailscale | Trade-off |
|---|---|---|---|
| JetKVM (Apr-2026 rev, PoE) | $103 / $119 + $20 ATX at iKoolcore, **sold out**; eBay ~£130 | Install script (needs dev-mode SSH) | Best UI and open-source app, but 1080p60 only, 100 Mbps NIC, no audio, ~98 ms; hard to buy in the UK. |
| Sipeed NanoKVM Lite / Full / Pro | ~£45 / ~£70 / Pro unpriced | Pro preinstalled | Cheapest, but Lite/Full are MJPEG 90–230 ms; security history (hard-coded JWT secrets, root everything, CVE-2026-32296 auth bypass fixed in fw 2.3.1). Only behind an isolated VLAN + Tailscale. |
| PiKVM V4 Mini / Plus | £225 / £315 at The Pi Hut, in stock | Official package, not preinstalled | Fully open (GPLv3), ATX board included, IPMI/Redfish emulation; the reference implementation at 2× the Comet price. |
| TinyPilot Voyager 3 | $399 / ~£340, sold out | One-click | Business polish (RBAC, serial console); same raw capability as PiKVM at a premium. |
| Comet X GL-RM4PE (4-port) | $279.99 | Yes | Only if a second/third agent machine appears. |

### 4.4 Intel AMT on the P520 (free, partial)

Lenovo PSREF lists the P520 as **Intel vPro with AMT 11** (C422 chipset, I219-LM NIC with WoL); `/dev/mei0` exists on hlab. **But AMT's KVM screen only works with Intel integrated graphics**, and the Xeon W-2145 has none, so MeshCentral/MeshCommander would give power on/off/reset, Serial-over-LAN (GRUB + a getty on ttyS if configured), boot-to-BIOS/PXE and IDE-R ISO boot with a **black screen**. Enabling it needs one visit to MEBx (Ctrl+P at POST) and it should stay LAN/Tailscale-only. Worth enabling for free power control + SOL even alongside a Comet; not a KVM substitute on this CPU. Whether AMT is currently provisioned is unverified; from the laptop, `http://192.168.178.50:16992` answering would confirm it.

### 4.5 Cost of ownership, one machine

| Option | Parts | Total |
|---|---|---|
| **Comet PoE + ATX board** | £107 + ~£15; PoE via a switch port or ~£15 injector, or the included USB-C PSU; cables in the box; no dummy plug | **~£120–145** |
| Comet GL-RM1 V2 + ATX | £96 + ~£15 | ~£111 (bring a USB stick for ISOs) |
| PiKVM V4 Mini | all-in | £225 |
| NanoKVM Full | incl. ATX | ~£70 (accept the CVE history) |
| Intel AMT (power + SOL only) | — | £0 |

**Bottom line:** if David wants the insurance, buy **Comet PoE + ATX board (~£125)**, bind it to the tailnet, and enable AMT for free as a second layer. Skip NanoKVM unless the £50 saving outweighs the security record; PiKVM only for a fully open stack.

---

## 5. The workflow: Claude Code Desktop + Codex Desktop instead of Herdr

### 5.1 Roles

- **Claude Code Desktop (SSH → hlab)** = the cockpit. Sessions sidebar, one worktree per session, cross-session messaging, voice, dispatch from phone, Remote Control for browser/mobile steering.
- **Codex** = a second workforce with its own strengths (GPT-6 Astra / GPT-5.6 Sol reasoning, cheap Luna for bulk), used in **two modes**:
  1. *Delegated* (today's pattern, keep it): Claude Code on hlab runs `codex exec` / `codex mcp-server` for bounded tasks and reviews the result. Zero laptop involvement.
  2. *Direct GUI* (for design-heavy interactive work): Codex threads on hlab driven from a GUI **that does not run the heavy Windows app shell**. Options ranked in §6.
- **Notification bus on hlab** = the "ding": both tools' hooks post to one channel (ntfy or Telegram), so it does not matter which app started the session or which device David is holding.
- **Review**: Desktop diff view for Claude sessions; Codex app PR review for Codex threads; `hunk diff --watch` on hlab only if a terminal is open anyway (it is a TUI).

### 5.2 Concrete wiring (all on hlab, no laptop load)

**Claude Code hooks** (shared by CLI and Desktop; `~/.claude/settings.json`):
- `Notification` matchers `permission_prompt|idle_prompt|agent_needs_input|agent_completed` → POST to ntfy topic (Tailscale-only ntfy at, e.g., `tailscale serve` port) or Telegram.
- `Stop` → "session finished" ping with `cwd` and session name.
- Turn on Desktop's own OS notification for finished sessions (already default) and the mobile push toggles under Remote Control (`/config` → "Push when actions required").

**Codex hooks** (`~/.codex/hooks.json`, events include `PermissionRequest`, `Stop`, `SubagentStop`, `Interrupt`, `async: true`, can call MCP tools) → same ntfy/Telegram endpoint. Codex's older `notify = [...]` only fires on `agent-turn-complete`; use hooks.

**Persistence for headless/overnight:** `claude remote-control --spawn worktree --capacity 8 --name hlab` inside tmux (or Herdr) on hlab. Sessions then appear in claude.ai/code and the mobile app with a green dot, and cross-session messaging can reach them from Desktop.

**Channels (research preview):** `/plugin install telegram@claude-plugins-official` and `claude --channels plugin:telegram@…` relays permission prompts into Telegram so David can approve from the phone. Codex has Codex Remote (QR-paired phone) for the same on the Codex side.

**"Who needs me" view:** short term, the Desktop sidebar filtered by status plus the ntfy feed. Medium term, a tiny page on the :8090 board reading both hook feeds (this is exactly what Herdr's sidebar is, but cross-tool and in the browser). `claude agents` (agent view, research preview) gives the same grouped Working/Needs-input/Idle/Completed list in a terminal on hlab.

### 5.3 A typical day

1. Open Claude Code Desktop → hlab environment. Ctrl+N per task; each lands in its own worktree. Kick off 4–8.
2. For any bounded, well-specified chunk (migration, test scaffolding, a refactor), the Claude session delegates to Codex (`codex exec --json --sandbox workspace-write --cd <worktree>`), so Codex threads multiply without a second GUI.
3. For design work where David wants to talk to Codex directly, open Codex via the light path from §6 (VS Code Remote-SSH + Codex extension, or the app with the scanning triggers removed).
4. Phone dings (ntfy/Telegram) on `blocked` or `done`; approve from Telegram/Claude mobile or come back to the Desktop.
5. Review in the Desktop diff view / Codex PR review; `ship.py` for anything visible.

---

## 6. Codex without the laptop drag

### 6.1 Why the laptop is slow (documented, Jun–Jul 2026, openai/codex)

| Cause | Evidence | Applies when agent is remote? |
|---|---|---|
| Unified ChatGPT/Codex Windows app main process runs PowerShell WMI process inventories ~26/min and spawns hundreds–thousands of `git.exe`/`conhost.exe` per minute for repo discovery; 234 ms input lag → 16 ms when suppressed | Discussion #29949, #29911; no fix through 26.707.x | Likely yes (app shell behaviour); unverified for remote-only projects |
| Defender `MsMpEng.exe` 5–17 % CPU while the app is open, exclusions do not help; 1–3 % idle in tray | #33711, #30527, #30721 | Yes |
| Windows sandbox ACL traversal of big workspaces, WSL2 `/mnt/c` stat storms | #30084, #26149, #25715 | No (only local/WSL agents) |
| Electron renderer animations 50–60 % of a core | #10885 | Yes |
| **x1eg3 Thunderbolt fault loop** (Titan Ridge, ~37 `nhi` events/min, xHCI in Error state) | memory `x1eg3-thunderbolt-fault` | Independent of Codex; fix via Lenovo TB firmware/driver/BIOS |

### 6.2 Options, ranked for David

| # | Option | GUI | Compute on hlab | Laptop cost | State |
|---|---|---|---|---|---|
| 1 | **Keep delegating from Claude Code** (`codex exec` / `codex mcp-server`), scale it with hooks + worktrees | Claude Desktop | 100 % | ~0 | Works today |
| 2 | **VS Code Remote-SSH → hlab + Codex IDE extension** (extension host and Codex run on hlab) | VS Code sidebar | 100 % | VS Code only | Works for many; loading-hang bugs #27597/#32385 (socket perms in `/tmp/codex-ipc`, stale temp dirs) — single-user hlab avoids the main cause |
| 3 | **ChatGPT app + SSH host** (what is connected now) with triggers removed: never open a multi-repo parent dir as a project, delete empty `.git` dirs, disable the VS Code Codex extension while the app is open, keep the app updated | Full app | agent 100 % | app shell + Defender | GA; shell cost remains |
| 4 | **Codex Linux desktop app on hlab**, window streamed (xrdp / Sunshine + Moonlight over Tailscale) | Full app | 100 % | video decode only | Linux preview since 2026-08-13; **unverified** as a streamed setup |
| 5 | **Codex cloud** (chatgpt.com/codex, GitHub repos) | Browser | 0 % (OpenAI sandbox, not hlab) | ~0 | GA; no self-hosted runner; shares plan usage |
| 6 | Phone: Codex Remote (QR pairing, GA 2026-06-26) / Claude Remote Control | Mobile | 100 % | 0 | GA |

**Recommendation:** 1 as the default, 2 as the interactive GUI for Codex, 3 only when a Codex-app-specific feature (PR review, automations, multi-repo projects) is needed. Fix the Thunderbolt fault regardless.

### 6.3 Immediate to-dos on hlab

- `npm i -g @openai/codex@0.153.4` (0.144.1 → 0.153.4; GPT-6 Astra default, hooks `Interrupt`, early rate-limit warnings).
- Decide model mix in `config.toml`: `gpt-6-astra` for hard design/reasoning, `gpt-5.6-sol` (current) for general, `gpt-5.6-luna` for bulk mechanical tasks. Plan windows (Plus 5-hour, local messages): Astra 5–45, Sol 10–100, Terra 25–200, Luna 250–2,000; Pro 5x is 5× those.
- Add the ntfy/Telegram hooks for both tools (§5.2).
- Optionally register Codex as an MCP server in Claude Code: `claude mcp add codex -- codex mcp-server` (marked deprecated in favour of app-server, still documented and working).

---

## 7. Costs

| Item | Cost | Needed? |
|---|---|---|
| Herdr | Free (Apache-2.0) | No (see §3) |
| hunk | Free (MIT) | Optional |
| Tailscale | Already running (personal plan free up to 3 users / 100 devices) | Yes, no change |
| KVM hardware | see §4 | Optional insurance |
| Extra machines | £0 if the P520 hosts 16 sessions; `acg-proxmox1` is already on the tailnet for VM "cores" if ever needed | No |
| Codex plan | Plus $20 / Pro 5x $100 / Pro 20x $200 per month; Codex CLI/app/IDE/cloud all included and share one pool; API overage Astra $10/$50 per 1M in/out, Sol $4/$20, Terra $2/$12, Luna $0.20/$1.20 | Depends on volume; heavy Astra use pushes towards Pro 5x |
| Claude plan | Desktop Code tab needs Pro/Max/Team/Enterprise; Remote Control, Channels, Dispatch on Pro/Max | Already have |
| VS Code + Remote-SSH + Codex extension | Free | If option 2 |

---

## 8. Decision summary

- **KVM:** buy one only for unattended resilience (§4 tells which). It does not add agent throughput.
- **Herdr:** skip as cockpit; possible later as hlab's headless persistence layer with an event feed.
- **Cockpit:** Claude Code Desktop (SSH → hlab) stays primary; Codex reached via delegation from Claude and via VS Code Remote-SSH for direct GUI work; the heavy Windows app only when its exclusive features are needed.
- **Ding:** hooks in both tools → one ntfy/Telegram channel + Claude Remote Control push; that is the piece of DHH's setup David is actually missing.
- **Laptop:** the drag is the Windows app shell plus the Thunderbolt fault, not the agents; both are fixable without changing where the agents run.

---

## Sources

- Lex Fridman #501 transcript: https://lexfridman.com/dhh-2-transcript/ · clip https://www.youtube.com/watch?v=4Xg1AE6Uu1k
- Herdr: https://herdr.dev/ · https://github.com/herdrdev/herdr · docs `/docs/agents/`, `/docs/persistence-remote/`, `/docs/configuration/`, `/docs/agent-automation/` · multi-host discussion https://github.com/herdrdev/herdr/discussions/515 · YC post https://herdr.dev/blog/herdr-is-joining-y-combinator/ · Omarchy 4 https://codetocloud.io/blog/omarchy-4-quattro-whats-new/ · Collie https://github.com/AltanS/collie
- hunk: https://www.hunk.dev/ · https://github.com/modem-dev/hunk
- Claude Code: https://code.claude.com/docs/en/desktop · https://claude.com/docs/third-party/claude-desktop/ssh-remote-sessions · https://code.claude.com/docs/en/remote-control · https://code.claude.com/docs/en/hooks · https://code.claude.com/docs/en/agent-view · https://code.claude.com/docs/en/channels · https://code.claude.com/docs/en/agents · https://code.claude.com/docs/en/cross-session-messaging · issues #67551, #40633, #29045
- Codex: https://learn.chatgpt.com/docs/remote-connections · https://learn.chatgpt.com/docs/app · https://learn.chatgpt.com/docs/app-server · https://learn.chatgpt.com/docs/hooks · https://learn.chatgpt.com/docs/non-interactive-mode · https://learn.chatgpt.com/docs/models · https://learn.chatgpt.com/docs/pricing · https://developers.openai.com/api/docs/pricing · https://learn.chatgpt.com/docs/mcp-server · openai/codex #29949, #29911, #33711, #30527, #30721, #30084, #26149, #18503, #27597, #32385 · https://codex.danielvaughan.com/2026/04/17/codex-remote-ssh-app-server-architecture/
- KVM: https://docs.gl-inet.com/kvm/en/faq/remote_access_via_tailscale/ · https://docs.gl-inet.com/kvm/en/user_guide/gl-atx-board/ · https://www.gl-inet.com/en-gb/products/gl-rm1 · https://www.cnx-software.com/2025/09/21/gl-inet-comet-poe-kvm-over-ip-solution-32gb-emmc-flash/ · https://www.servethehome.com/gl-inet-comet-poe-4k-remote-kvm-review-gl-rm1pe/ · https://forum.gl-inet.com/t/new-version-of-tailscale-v1-90-1-breaks-comet/64987 · https://jetkvm.com/docs/networking/remote-access · https://thepihut.com/products/pikvm-v4-mini · https://docs.pikvm.org/tailscale/ · https://www.sentinelone.com/vulnerability-database/cve-2026-32296/ · Lenovo PSREF P520 https://psref.lenovo.com/syspool/Sys/PDF/ThinkStation/ThinkStation_P520/ThinkStation_P520_Spec.html · Intel AMT KVM needs iGPU https://software.intel.com/sites/manageability/AMT_Implementation_and_Reference_Guide/WordDocuments/kvmonaplatformwithdiscretegraphics.htm · DHH closet tweet https://x.com/dhh/status/2078247687128809812
