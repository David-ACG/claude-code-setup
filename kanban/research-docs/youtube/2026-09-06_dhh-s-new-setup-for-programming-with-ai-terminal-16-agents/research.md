---
title: DHH's new setup for programming with AI - terminal, 16 agents, Herdr, Tailscale
video_url: https://www.youtube.com/watch?v=4Xg1AE6Uu1k
video_id: 4Xg1AE6Uu1k
channel: Lex Clips
published: 2026-09-04
duration: 12:42
researched: 2026-09-06
focus: David's P520 + Tailscale: KVM/IP setup, Herdr vs Claude Code Desktop + Codex Desktop, using Codex more without slowing the laptop
tags: agentic engineering, Herdr, tmux, GL.iNet Comet, KVM over IP, Tailscale, Codex, Claude Code, Omarchy, Linux, hunk
---

# DHH's new setup for programming with AI - terminal, 16 agents, Herdr, Tailscale

## Summary

A 12-minute Lex Clips cut from Lex Fridman Podcast #501 (26 Aug 2026) in which David Heinemeier Hansson explains how his programming setup changed once he started working with coding agents. He argues that agents turn programming from single-threaded flow into parallel processing, so the tooling has to show many agents at once and tell you when one needs you. His stack is terminal-only: Herdr (a tmux-like multiplexer with agent-state tracking and a notification bell), one Herdr per machine, four to five mini PCs put on his Tailscale network with GL.iNet Comet KVM boxes, about 16 agent threads in total, Neovim and lazygit for review, and Linux because agents work best with config files and CLI tools. Research verdict: every product and mechanism he names checks out and is current; the setup is a good fit for a terminal-first Linux user and a poor fit for David, who already runs both agents on hlab from GUI desktop apps and whose remaining gaps are notification and out-of-band recovery, not hardware. The decision write-up for David's questions is in [RESEARCH_2026-09-06_dhh-herdr-kvm-tailscale-setup.md](../../../1_planning/RESEARCH_2026-09-06_dhh-herdr-kvm-tailscale-setup.md) and the readable page at https://hlab.taila51191.ts.net:9459/dhh-setup/.

## Key takeaways

- Agents are "at once both too fast and too slow", so waiting on one agent feels useless; run a handful in parallel and spend your time making decisions and unblocking them [1:31] [2:16].
- The tool change that matters is a multiplexer that tracks agent state and rings when an agent is done or blocked. DHH moved from tmux to Herdr for exactly that [3:47] [3:57].
- Herdr does not span machines: DHH runs "multiple Herdr setups running on individual machines" [4:21]. Verified: Herdr's client attaches to one server; a multi-host view is still an open request.
- More agent threads came from more machines, not a bigger one: four closet mini PCs, each with a GL.iNet Comet KVM, all on Tailscale, roughly 16 threads [4:45] [6:07] [6:35]. For David, the P520 alone has the headroom for that thread count because agent sessions are API-bound.
- Tailscale is the enabler: every machine in Malibu and Copenhagen looks local from his phone with no firewall changes [5:22] [5:32]. David already has this.
- The Comet's appeal is friction: plug in HDMI and USB, open a web page, log in once, control the box [4:52] [5:06]. Verified, and the Comet runs Tailscale on the device itself.
- Review moved to Neovim as a project browser plus lazygit; hunk shows only the changeset while he wants surrounding context [8:22] [8:46] [8:57].
- Linux wins for agents because "everything in Linux is either a config file or a CLI tool" [9:39]; the Mac's GUI-only configuration and WSL's sandboxing are the counterexamples [10:48] [11:45].
- He disowns lines of code as a metric while using it as shorthand for the jump from tens to hundreds of lines an hour [7:27] [7:41].

## Who this is for and why it matters

The audience is working programmers deciding how to organise a day spent supervising several coding agents, and Linux-curious developers weighing Omarchy-style setups. Prerequisites are comfort with a terminal, tmux-style multiplexing and SSH; DHH assumes all three. The clip is opinion and workflow, not a tutorial, so the value is in the mental model (parallel supervision, notification-driven attention) rather than in any command.

For David the connection is direct. He supervises Claude Code and Codex on the P520 from a Windows laptop over Tailscale, wants to use Codex much more, and is weighing a KVM. The research below confirms that his current architecture already matches DHH's on the points that count (agents on Linux, mesh network, worktree per session) and that the parts he lacks are the ding and out-of-band recovery. The GWTH angle is indirect: more parallel sessions with reliable notification would raise throughput on the launch board, but nothing here changes lesson content.

## Chapter by chapter

### [0:03] From TextMate to agents
Lex asks how the setup changed. DHH used TextMate for almost twenty years from 2005, was forced out only by the move to Linux, and then by "agentic engineering", a term he says he hates; both settle on calling it programming [0:40] [0:53]. Programming with agents "requires a different tool set" [0:54].

### [1:04] Single-thread flow versus parallel processing
Hand-written code meant one problem at a time, and that immersion "was actually the portal to flow" [1:21]. Agents break it because they answer neither instantly nor slowly enough to ignore, so "you have to let the agent cook" [1:48]. Sitting and waiting "feels actually like you're a little bit useless" [2:04].

### [2:16] Throwing more resources at it
His first agentic phase ran one agent and left him unconvinced. The fix was the scaling-law instinct: run a handful, and you are back in a flow state because you are constantly deciding, unblocking an agent that has a question, or handing out the next task [2:34] [2:47]. He began with tmux panes and splits, "a terminal with tabs" [2:58].

### [3:06] Still the terminal
Asked whether he uses the Claude Code app or the Codex app, he says he loves that "this agent revolution was kicked off in the terminal" and that the modern terminal is "a beautiful place to be" [3:13] [3:28]. This is the explicit rejection of GUI cockpits.

### [3:38] Herdr
Once agents run on several machines, "tmux alone is not enough to keep track of it", so he switched to Herdr, "essentially tmux plus agent notifications" [3:47] [3:57]. It rings when an agent is done or needs something and tracks working versus not [4:04] [4:18]. He runs multiple Herdr setups, one per machine [4:21]. He jokes about whether the human is master or servant [4:11].

### [4:26] Sixteen cores: GL.iNet Comet KVMs
About a month before recording he decided one machine was not fast enough, "like I've discovered multi-core programming, but I only have two cores" [4:36], and bought GL.iNet Comet KVMs. Plug in HDMI and USB, go to a web page, log in once, and the box is controllable [4:52] [5:06].

### [5:16] Tailscale
The other revolution of the year: WireGuard networks. Tailscale turns all his computers into one local network wherever he is; from his phone he reaches the Malibu and Copenhagen offices as if sitting next to the machines, "without having to punch holes in a firewall" [5:26] [5:45]. It "decreases the friction it takes to get new compute online" [5:51].

### [5:58] The closet
He connected four mini PCs from earlier experiments, each with a Comet, and controlled them all with Herdr [6:07] [6:18]. He maxed out at about four to five machines running three agents each, roughly 16 threads, fewer as agents get faster [6:28] [6:35].

### [6:47] Delirious, and the lines-of-code caveat
He describes going from excited to "delirious" [6:52], compares current bandwidth to dial-up [7:00], and estimates hand-written output at 20 to 30 lines an hour against hundreds now [7:27] [7:33]. He then disowns the metric: lines of code is "a stupid metric", and the right question is "what did you build?" [7:45] [7:58].

### [8:22] Review: Neovim, lazygit, hunk
Still Neovim, but as a project browser and a way to open lazygit for the change log [8:27] [8:30]. GitHub's PR view would be nicer if faster [8:39]. hunk produces nice diffs but shows only the change set; when reviewing agent output he wants to see the untouched neighbouring file that maybe should have changed, so Neovim wins [8:46] [8:57] [9:08].

### [9:11] Linux and the Unix philosophy
Everything runs on Linux. Agents "love the Unix philosophy": individual tools invoked from the command line; no major OS does this as well as Linux, where "it's either a config file or a CLI tool" [9:20] [9:39]. The irony: Linux's old drawback is now its selling point [9:56].

### [10:07] Stuck with a Mac
Four months earlier he arrived somewhere expecting a Linux box and found a Mac mini. Homebrew is "the missing package manager" and has become good [10:36], but Raycast has no config file you can script; you export from the GUI and carry the file on a USB key, and default key bindings cannot be automated [10:53] [11:13]. Lex counters that there are ways; DHH: "Not good ones. I looked. I tried hard." [11:24]

### [11:27] Lex's Windows and WSL detour
Lex uses Windows for Adobe Premiere and WSL for Linux; both agree WSL "is a sandbox" and agents need Linux "unleashed" [11:45] [11:50]. Lex has woken up to Omarchy-style config-file setups and finds many apps lacking them; DHH says people build the app themselves, but "they're hacks. You don't have to live like this, Lex." [12:14] [12:20]

## Claims and verification

| # | Claim (timestamp) | Status | Evidence | Source |
|---|---|---|---|---|
| 1 | Herdr is "tmux plus agent notifications" that rings when an agent is done or needs a decision [3:57] | Verified | Herdr is a Rust terminal multiplexer with per-pane agent state (working, blocked, idle, done) and notifications on done and blocked; detection via agent hooks or screen manifests | [Herdr docs: agents](https://herdr.dev/docs/agents/), [configuration](https://herdr.dev/docs/configuration/) |
| 2 | He runs multiple Herdr setups, one per machine [4:21] | Verified | One Herdr client attaches to exactly one server; `herdr --remote user@host` is a thin client to one remote; multi-host view is Discussion #515, "top priority" but unshipped | [persistence and remote](https://herdr.dev/docs/persistence-remote/), [discussion 515](https://github.com/herdrdev/herdr/discussions/515) |
| 3 | GL.iNet Comet: plug HDMI and USB in, open a web page, log in once, control the computer [4:52] | Verified | Comet GL-RM1 is a KVM-over-IP box with HDMI capture and USB HID emulation, a local web UI, and optional Tailscale, ZeroTier or GL.iNet cloud remote access | [GL.iNet KVM docs](https://docs.gl-inet.com/kvm/en/), [remote access via Tailscale](https://docs.gl-inet.com/kvm/en/faq/remote_access_via_tailscale/) |
| 4 | Tailscale makes all your computers one local network anywhere without firewall changes [5:26] | Verified | Tailscale builds a WireGuard mesh with NAT traversal; the Comet itself can join the tailnet | [Tailscale on the Comet](https://docs.gl-inet.com/kvm/en/faq/remote_access_via_tailscale/) |
| 5 | Four to five machines with about three agents each, about 16 threads [6:35] | Verified as his report | Consistent with the Lex Fridman episode page summary and his July 2026 "server closet is growing" tweet; not independently measurable | [episode page summary](https://finance.biggo.com/podcast/24748b357b42d559), [DHH tweet](https://x.com/dhh/status/2078247687128809812) |
| 6 | Herdr is what he uses "as of late" [3:54] and Omarchy has it [context] | Verified | DHH tweeted on 9 Aug 2026 that Herdr ships in Omarchy 4 "Quattro"; Omarchy opens it with Super+Ctrl+Return | [DHH tweet](https://x.com/dhh/status/2086539415682224565), [Omarchy 4 notes](https://codetocloud.io/blog/omarchy-4-quattro-whats-new/) |
| 7 | hunk "produces diffs in a really nice way" but shows only the change set [8:48] | Verified | hunk is a review-first TUI diff viewer for agent changesets with `hunk diff --watch`; it renders hunks, not whole files | [hunk.dev](https://www.hunk.dev/), [repo](https://github.com/modem-dev/hunk) |
| 8 | Homebrew is "the missing package manager for the Mac" [10:38] | Verified | Homebrew's own tagline | [brew.sh](https://brew.sh/) |
| 9 | Raycast has no config file; you must export from the GUI [10:53] | Partly true | Raycast settings are exported and imported via the app; there is no plain-text config for keybindings, though extensions and scripts are files. Unverified whether the export can be scripted | Unverified |
| 10 | WSL "is a sandbox" and not good Linux for agents [11:45] | Partly true | WSL2 is a lightweight VM with its own kernel; agents run fine inside it, but cross-filesystem access to `/mnt/c` is slow and OpenAI documents WSL2 stat storms for Codex; OpenAI's own advice is to keep repos inside the WSL filesystem | [Codex on WSL](https://learn.chatgpt.com/docs/windows/wsl), [openai/codex 26149](https://github.com/openai/codex/issues/26149) |
| 11 | He does not use the Claude Code app or the Codex app [3:10] | Verified as stated | Both apps exist and run sessions in worktrees with notifications; his choice is preference, not capability | [Claude Code desktop](https://code.claude.com/docs/en/desktop), [Codex app](https://learn.chatgpt.com/docs/app) |
| 12 | Agents work best on Linux because everything is a config file or CLI tool [9:39] | Opinion, plausible | No benchmark; consistent with both vendors documenting Linux and macOS as primary and Windows as later ports (Codex Windows app March 2026, Linux preview Aug 2026) | [Codex changelog](https://learn.chatgpt.com/docs/changelog) |
| 13 | Full episode context: he runs Claude in the top pane and Codex below inside Herdr | Verified | Stated at 02:43:27 in the full episode transcript | [Lex transcript](https://lexfridman.com/dhh-2-transcript/) |
| 14 | Herdr is free and open | Verified | Apache-2.0 since July 2026 (AGPL before), no account, no telemetry; Herdr Inc. joined Y Combinator F26 and plans paid features above the runtime | [Herdr YC post](https://herdr.dev/blog/herdr-is-joining-y-combinator/), [repo](https://github.com/herdrdev/herdr) |

## Tools, products and people mentioned

| Name | What it is | Role in the video | Current status (as of 2026-09-06) | Official link |
|---|---|---|---|---|
| Herdr | Rust terminal multiplexer with agent-state sidebar and notifications | His cockpit, one per machine | Apache-2.0, free, Linux/macOS/Windows; ~35.7k GitHub stars; no multi-host view yet | https://herdr.dev/ |
| tmux | Terminal multiplexer | His previous cockpit | Stable; Herdr reimplements its model | https://github.com/tmux/tmux |
| GL.iNet Comet (GL-RM1 / RM1PE / RM10) | KVM-over-IP box with on-device Tailscale | Puts closet mini PCs online | RM1 V2 ~£96, RM1PE ~£107, RM10 £172.99 UK; ATX power board $15.99 | https://www.gl-inet.com/en-gb/products/gl-rm1 |
| Tailscale | WireGuard mesh VPN | Makes all machines local | Personal plan free; runs on the Comet, on hlab and on x1eg3 already | https://tailscale.com/ |
| Neovim | Editor | Project browser and review | Stable | https://neovim.io/ |
| lazygit | Terminal git UI | Change log review | Stable | https://github.com/jesseduffield/lazygit |
| hunk | TUI diff viewer for agent changesets | Tried for review | MIT, ~9.1k stars, Omarchy 4 default with `hunk diff --watch` | https://www.hunk.dev/ |
| Omarchy | DHH's Arch-based Linux distribution | Implied home of the setup | Version 4 "Quattro" ships Herdr and hunk | https://omarchy.org/ |
| Claude Code app | Anthropic desktop app running Claude Code sessions | Rejected by DHH | Windows and macOS; SSH environments run the engine on a remote Linux box; worktree per session | https://code.claude.com/docs/en/desktop |
| Codex app | OpenAI agent app, merged into the unified ChatGPT desktop app 2026-07-09 | Rejected by DHH | Windows since 2026-03-05, Linux preview 2026-08-13; SSH hosts run `codex app-server` remotely | https://learn.chatgpt.com/docs/app |
| Homebrew | macOS package manager | Praised | Stable | https://brew.sh/ |
| Raycast | macOS launcher | Criticised for GUI-only config | Current | https://www.raycast.com/ |
| WSL | Windows Subsystem for Linux | Lex's Linux; called a sandbox | WSL2 current; WSL1 dropped by Codex | https://learn.microsoft.com/windows/wsl/ |
| TextMate | macOS editor | Twenty years of history | Maintained, open source | https://macromates.com/ |
| David Heinemeier Hansson | Rails creator, 37signals CTO, Omarchy author | Speaker | Lex Fridman #501, 26 Aug 2026 | https://lexfridman.com/dhh-2/ |
| Can (Ogulcan) Celik | Herdr author, Herdr Inc. (YC F26) | Not named; builds the tool | Solo developer, incorporated Aug 2026 | https://github.com/ogulcancelik |

## What has changed since the video was published

- Nothing material in the two days since the clip's 4 Sep 2026 upload; the interview was recorded around late August 2026.
- Since the recording: Codex CLI 0.153.4 (4 Sep 2026) made GPT-6 Astra (released 3 Sep 2026) the default model in its picker, and GPT-5.5 and 5.4 were retired from Codex on 31 Aug 2026. Source: [Codex changelog](https://learn.chatgpt.com/docs/changelog), [Codex models](https://learn.chatgpt.com/docs/models).
- Herdr's licence changed from AGPL to Apache-2.0 in July 2026 and the company joined YC in August 2026; older articles still say AGPL. Source: [Herdr YC post](https://herdr.dev/blog/herdr-is-joining-y-combinator/).
- GL.iNet added the four-port Comet X (GL-RM4PE, $279.99, June 2026) for people who, like DHH, put several boxes online. Source: [GL.iNet Comet X](https://www.gl-inet.com/en-us/products/gl-rm4pe).
- Anthropic's Claude Code gained an agent view (`claude agents`), background sessions, Channels for Telegram and Discord, and Remote Control server mode with per-session worktrees, which together cover Herdr's use case for Claude sessions without a terminal multiplexer. Source: [agent view](https://code.claude.com/docs/en/agent-view), [remote control](https://code.claude.com/docs/en/remote-control), [channels](https://code.claude.com/docs/en/channels).

## Related material worth reading

- [Lex Fridman #501 full transcript](https://lexfridman.com/dhh-2-transcript/): the surrounding five hours, including the Claude-above-Codex pane detail at 02:43:27.
- [Herdr docs: agents](https://herdr.dev/docs/agents/) and [persistence and remote](https://herdr.dev/docs/persistence-remote/): how state detection and the single-server remote model actually work.
- [Herdr multi-host discussion #515](https://github.com/herdrdev/herdr/discussions/515): the maintainer on why multiple remote servers are not supported yet.
- [GL.iNet: remote access via Tailscale](https://docs.gl-inet.com/kvm/en/faq/remote_access_via_tailscale/) and [ATX board guide](https://docs.gl-inet.com/kvm/en/user_guide/gl-atx-board/): the two pages that make the Comet a full out-of-band tool.
- [ServeTheHome Comet PoE review](https://www.servethehome.com/gl-inet-comet-poe-4k-remote-kvm-review-gl-rm1pe/): independent test, privacy nits, and why they buy them for Tailscale.
- [Intel: AMT KVM needs integrated graphics](https://software.intel.com/sites/manageability/AMT_Implementation_and_Reference_Guide/WordDocuments/kvmonaplatformwithdiscretegraphics.htm): why the P520's vPro cannot replace a KVM box.
- [Claude Code desktop: SSH sessions](https://code.claude.com/docs/en/desktop#ssh-sessions) and [Codex remote connections](https://learn.chatgpt.com/docs/remote-connections): the GUI equivalents of DHH's SSH-into-the-closet workflow.
- [openai/codex discussion 29949](https://github.com/openai/codex/discussions/29949): the documented Windows app-shell scanning that makes laptops lag.
- [Omarchy 4 "Quattro" notes](https://codetocloud.io/blog/omarchy-4-quattro-whats-new/): how DHH's distribution packages Herdr and hunk.
- [hunk](https://github.com/modem-dev/hunk): the diff tool he mentions, with its agent-notes sidecar.

## Open questions and caveats

- The clip omits how DHH hands work to each machine and merges results; the full episode does not describe a git or worktree strategy across boxes.
- Whether the "16 threads" ceiling was API rate limits, his attention, or CPU is not stated. For a single P520 the binding limit is plan usage and attention, not cores.
- Herdr's screen-manifest detection for agents without hooks is heuristic; "blocked" can be missed or false. Claude Code's hooks are the authoritative path.
- Prices for the GL.iNet RM1, RM1PE and ATX board in GBP come from search snippets because the store renders prices with JavaScript; only the Comet Pro price was verified on the page.
- Whether AMT is provisioned on the P520 is unverified; from the laptop, an answer at `http://192.168.178.50:16992` would confirm it.
- DHH's Raycast criticism is partly a matter of taste; the export path exists, scriptability is what he wants.
- Everything he says about GUI apps being the wrong cockpit is preference. Both vendor apps now offer the state, worktree and notification features he attributes to Herdr, for their own agent only.

## Implementation notes (agent)

### Procedures shown
Nothing is typed on screen; the clip is conversation. The procedures below are the ones DHH describes, reconstructed from the vendor docs.

1. Put a machine on the tailnet with a Comet [4:52] [5:06] [6:07]:
   - Connect Comet HDMI-in to the host GPU, Comet USB-C (HID) to a host USB port, Ethernet (PoE or with the 5 V/2 A supply). Optionally the ATX board from the Comet's USB-A port to the motherboard front-panel header.
   - Browse to `http://glkvm.local` on the LAN, set the admin password.
   - Apps Center, Tailscale, Bind Device, log in once. Then from any tailnet device: `https://glkvm.<tailnet>.ts.net`.
   - Keep the Comet's Tailscale current from its web terminal:
```bash
tailscale update
```
2. Herdr on a Linux box, attach from a laptop [3:54] [4:21]:
```bash
curl -fsSL https://herdr.dev/install.sh | sh
```
```bash
herdr                      # start or reattach to the local server
```
```bash
herdr --remote david@hlab.taila51191.ts.net   # thin client to one remote Herdr server
```
   - Notifications in `~/.config/herdr/config.toml`: delivery `herdr`, `terminal`, `system` or `off`; sound via `path`, `done_path`, `request_path`.
   - Custom agent detection: `HERDR_AGENT=<name>` on the wrapper command.
3. Review flow [8:27] [8:46]: Neovim as browser, lazygit for the change log; optional:
```bash
curl -fsSL https://hunk.dev/install.sh | sh && hunk diff --watch
```

### Code and configuration
None shown in the video. Reconstructed from docs (not from the video):

- Claude Code notification hooks on hlab, shared by CLI and Desktop (`~/.claude/settings.json`): a `Notification` hook with matcher `permission_prompt|idle_prompt|agent_needs_input|agent_completed` and a `Stop` hook, each running a command that POSTs to an ntfy topic or Telegram. Source: https://code.claude.com/docs/en/hooks
- Codex hooks on hlab (`~/.codex/hooks.json`): `PermissionRequest`, `Stop`, `SubagentStop`, `Interrupt`, with `"async": true`. Source: https://learn.chatgpt.com/docs/hooks
- Remote Control server mode on hlab inside tmux (inference, matches docs):
```bash
claude remote-control --spawn worktree --capacity 8 --name hlab
```
- Codex as an MCP server for Claude Code (documented, marked deprecated in favour of app-server, still works):
```bash
claude mcp add codex -- codex mcp-server
```

### Decisions, trade-offs and gotchas
- Terminal cockpit over GUI apps [3:13]: DHH's reason is taste and TUI affinity. Research: both GUI apps supply the same per-session state, worktree isolation and finish notifications for their own agent; Herdr's edge is cross-agent state in one screen, on one host. For David the GUI decision stands (memory `gui-committed-workflow`).
- Many machines over one big one [4:36]: his reason is thread count. Research: agent sessions are API-bound; hlab (8c/16t, 125 GB) can hold 16 sessions. Multi-machine only matters for isolation or for hardware-bound jobs (GPU).
- Herdr per machine [4:21]: forced by Herdr's single-server client. Gotcha: Windows can be a `--remote` client but not a target.
- Comet over cheaper KVMs [4:45]: Comet runs Tailscale on-device; NanoKVM has a security history (CVE-2026-32296); JetKVM is hard to buy in the UK; PiKVM costs twice as much. Gotcha: power the Comet from its own 5 V/2 A supply, not a USB-PD charger; prefer the ARM64 RM1PE (32 GB) so ISOs fit.
- AMT on the P520 is not a KVM substitute: the Xeon W-2145 has no integrated graphics, so AMT KVM cannot render; power control and serial-over-LAN only.
- hunk versus editor for review [8:57]: he wants untouched context; the Desktop diff view and Codex PR review already show files in context.
- WSL [11:45]: OpenAI documents WSL2 stat storms and slow `/mnt/c` access for Codex; keep repos in the Linux filesystem, which David already does by running everything on hlab.
- Codex on Windows: the unified ChatGPT app shell scans processes and spawns `git.exe` storms even when the agent is remote (openai/codex #29949, #33711). Mitigations: never open a multi-repo parent folder as a project, delete empty `.git` dirs, disable the VS Code Codex extension while the app is open. Or avoid the app shell via VS Code Remote-SSH + Codex extension, or delegation from Claude Code.

### How to apply this in a codebase
1. Confirm both agents run on hlab (they do: `~/.claude/remote/ccd-cli/*` and `codex app-server --listen unix://` processes present on 2026-09-06).
2. Upgrade Codex CLI on hlab: `npm i -g @openai/codex@0.153.4`.
3. Add the Claude Code and Codex hooks above, pointing at one ntfy topic served over Tailscale or a Telegram bot; test with a deliberate permission prompt.
4. Enable Claude Remote Control push under `/config` and start a server-mode Remote Control in tmux for phone steering.
5. Trial VS Code Remote-SSH to hlab with the Codex extension for direct Codex sessions; keep the Windows app closed unless its exclusive features are needed.
6. Optional: buy Comet PoE + ATX board, wire it to the P520, bind Tailscale, enable AMT in MEBx for free power control.
7. Optional later: Herdr on hlab as the persistence layer for headless runs, with a socket subscriber pushing events to the :8090 board.
Projects touched: claude-code-setup (this repo, hooks and scripts), GWTH-launch-plan (board page for "who needs me"), infra tasks for the KVM. No GWTH_V2, pipeline or curriculum changes.

### Terminology and entities
- Agentic engineering: programming by directing coding agents; DHH prefers "programming".
- Multiplexer: a program that hosts several terminal sessions in one window with detach/reattach (tmux, Herdr).
- Pane / split / tab: subdivisions of a multiplexer window.
- Herdr: Rust multiplexer with agent-state tracking. https://herdr.dev/
- KVM: keyboard, video, mouse. KVM over IP: a device that captures a machine's video and emulates its keyboard and mouse over the network, giving out-of-band control including BIOS.
- Out-of-band: control that does not depend on the host's OS or network being up.
- ATX board: adapter that lets a KVM press the motherboard's power and reset lines.
- WireGuard: modern VPN protocol; Tailscale builds a mesh on it. https://tailscale.com/
- Tailnet: one Tailscale network; MagicDNS gives names like `hlab.taila51191.ts.net`.
- Thread (DHH's use): one running agent session.
- Scaling law: more compute, better results; DHH applies it to parallel agents.
- lazygit: terminal UI for git. https://github.com/jesseduffield/lazygit
- hunk: TUI diff viewer. https://www.hunk.dev/
- Unix philosophy: small composable tools invoked from the command line.
- Homebrew: macOS package manager. https://brew.sh/
- Raycast: macOS launcher. https://www.raycast.com/
- WSL: Windows Subsystem for Linux. https://learn.microsoft.com/windows/wsl/
- Omarchy: DHH's Arch-based distribution. https://omarchy.org/
- Intel AMT / vPro: firmware-level remote management in Intel business platforms; KVM part needs integrated graphics.
- 37signals: DHH's company (Basecamp, HEY).

### Notable quotes
- "The programming with agents requires a different tool set. It really does." [0:54]
- "You're going from single-thread programming in your head to parallel processing." [1:04]
- "The agents are at once both too fast and too slow." [1:34]
- "You have to let the agent cook." [1:48]
- "It feels actually like you're a little bit useless." [2:04]
- "Herdr's essentially tmux plus agent notifications." [3:57]
- "Is it master or servant? I'm not quite sure always." [4:11]
- "It's like I've discovered multi-core programming, but I only have two cores." [4:36]
- "Tailscale is essentially turning all the computers you have into a local network wherever you are." [5:24]
- "At the current pace I can run about 16 threads." [6:39]
- "Lines of code is a stupid metric in general." [7:45]
- "Agents love the Unix philosophy." [9:20]
- "Everything in Linux, it's either a config file or a CLI tool." [9:39]
- "They're hacks. You don't have to live like this, Lex." [12:20]

### Research log
- 2026-09-06 TranscriptAPI `/api/v2/youtube/transcript` for 4Xg1AE6Uu1k: first fetch by hand (1 credit), then the skill script into this folder (1 credit). 365 segments, 2,217 words, no chapters.
- Four parallel research subagents (Herdr; KVM hardware and AMT; Codex remote and performance; Claude Code desktop remote), each with WebSearch and WebFetch. Combined about 290 tool calls. Key URLs:
  - Herdr: https://herdr.dev/ ; https://github.com/herdrdev/herdr ; /docs/install/, /docs/agents/, /docs/persistence-remote/, /docs/configuration/, /docs/agent-automation/, /docs/integrations/, /docs/windows-beta/ ; https://github.com/herdrdev/herdr/discussions/515 ; https://herdr.dev/blog/herdr-is-joining-y-combinator/ ; https://www.bitdoze.com/herdr-agent-multiplexer/ ; https://flaviocopes.com/herdr/ ; https://dotzlaw.com/insights/claude-code-13-herdr-parallel-agent-sessions/ ; https://github.com/nikok6/herdr-mirror ; https://github.com/dcolinmorgan/herdr-remote ; https://github.com/amacsmith/her-di-dr ; https://github.com/AltanS/collie ; https://getmoshi.app/guides/tmux-or-herdr ; https://codetocloud.io/blog/omarchy-4-quattro-whats-new/ ; https://github.com/omacom/omarchy/pull/6231 ; https://github.com/carlotran4/omarchy-herdr ; https://x.com/dhh/status/2086539415682224565 ; https://x.com/dhh/status/2094780834767044690 ; https://lexfridman.com/dhh-2-transcript/
  - Comparables: https://github.com/agent-of-empires/agent-of-empires ; https://github.com/smtg-ai/claude-squad ; https://github.com/manaflow-ai/cmux ; https://docs.conductor.build/ ; https://github.com/coder/mux ; https://nimbalyst.com/blog/best-agent-management-tools-2026/
  - KVM: https://docs.gl-inet.com/kvm/en/faq/remote_access_via_tailscale/ ; https://docs.gl-inet.com/kvm/en/user_guide/gl-atx-board/ ; https://docs.gl-inet.com/kvm/en/user_guide/gl-rm1/console_guide/ ; https://docs.gl-inet.com/kvm/en/faq/remote_screen_goes_blank_no_hdmi_signal/ ; https://www.gl-inet.com/en-gb/products/gl-rm1 ; https://www.gl-inet.com/en-us/products/atx-board ; https://www.gl-inet.com/en-us/products/gl-rm4pe ; https://www.cnx-software.com/2025/07/13/review-of-gl-inet-comet-gl-rm1-kvm-over-ip-solution-and-atx-power-control-board/ ; https://www.cnx-software.com/2025/09/21/gl-inet-comet-poe-kvm-over-ip-solution-32gb-emmc-flash/ ; https://blog.lon.tv/2026/02/12/gl-inet-comet-remote-kvm-review-gl-rm1/ ; https://www.servethehome.com/gl-inet-comet-gl-rm1-remote-kvm-device-mini-review/ ; https://www.servethehome.com/gl-inet-comet-poe-4k-remote-kvm-review-gl-rm1pe/ ; https://forum.gl-inet.com/t/new-version-of-tailscale-v1-90-1-breaks-comet/64987 ; https://forum.gl-inet.com/t/comet-updating-tailscale/63686 ; https://forum.gl-inet.com/t/what-is-the-difference-between-rm1-v1-and-v2/69221 ; https://jetkvm.com/docs/networking/remote-access ; https://www.ikoolcore.com/products/jetkvm ; https://warpkvm.com/blog/jetkvm-review ; https://www.hackster.io/news/security-researcher-warns-on-sipeed-s-nanokvm-finds-vulnerabilities-and-a-cat-in-the-firmware-e1157a9ff0f4 ; https://www.sentinelone.com/vulnerability-database/cve-2026-32296/ ; https://thepihut.com/products/pikvm-v4-mini ; https://thepihut.com/products/pikvm-v4-plus ; https://docs.pikvm.org/tailscale/ ; https://tinypilotkvm.com/products/tinypilot-voyager-3 ; https://itproexpert.com/which-kvm-over-ip-in-2026/ ; https://computingforgeeks.com/best-ip-kvm-homelab/ ; https://psref.lenovo.com/syspool/Sys/PDF/ThinkStation/ThinkStation_P520/ThinkStation_P520_Spec.html ; https://software.intel.com/sites/manageability/AMT_Implementation_and_Reference_Guide/WordDocuments/kvmonaplatformwithdiscretegraphics.htm ; https://en.wikichip.org/wiki/intel/xeon_w/w-2145 ; https://github.com/Ylianst/MeshCentral ; https://x.com/dhh/status/2078247687128809812 ; https://finance.biggo.com/podcast/24748b357b42d559
  - Codex: https://learn.chatgpt.com/docs/app ; /docs/remote-connections ; /docs/app-server ; /docs/hooks ; /docs/non-interactive-mode ; /docs/models ; /docs/pricing ; /docs/changelog ; /docs/ide ; /docs/windows/wsl ; /docs/cloud ; /docs/mcp-server ; https://developers.openai.com/api/docs/pricing ; https://openai.com/index/introducing-the-codex-app/ ; https://codex.danielvaughan.com/2026/04/17/codex-remote-ssh-app-server-architecture/ ; https://codex.danielvaughan.com/2026/07/17/codex-chatgpt-unified-desktop-app-cli-migration-codex-app-detection-workarounds/ ; https://codex.danielvaughan.com/2026/06/02/codex-model-sunset-june-july-2026-deprecation-timeline-migration-paths-config-recipes/ ; https://codex.danielvaughan.com/2026/03/26/claude-code-codex-bidirectional-mcp/ ; https://www.techrepublic.com/article/news-openai-chatgpt-codex-linux-desktop-preview/ ; https://techcrunch.com/2026/07/09/openai-launches-its-new-family-of-models-with-gpt-5-6/ ; https://www.cnbc.com/2026/09/03/open-ai-astra-gpt-6-cyber.html ; openai/codex issues and discussions 29949, 29911, 33711, 30527, 30721, 30084, 26149, 25715, 18503, 29335, 28326, 14620, 26951, 27597, 32385, 10885, 23082, 11808, 34027
  - Claude Code: https://code.claude.com/docs/en/desktop ; https://claude.com/docs/third-party/claude-desktop/ssh-remote-sessions ; /docs/en/remote-control ; /docs/en/claude-code-on-the-web ; /docs/en/hooks ; /docs/en/hooks-guide ; /docs/en/terminal-config ; /docs/en/agent-view ; /docs/en/agents ; /docs/en/cross-session-messaging ; /docs/en/channels ; /docs/en/slack ; /docs/en/platforms ; /docs/en/sessions ; /docs/en/feature-availability ; /docs/en/mobile ; anthropics/claude-code issues 67551, 46845, 34626, 40633, 29045, 23227 ; https://www.hunk.dev/ ; https://github.com/modem-dev/hunk ; https://x.com/dhh/status/2062919431680852164
  - Local checks on hlab 2026-09-06: `nproc`, `lscpu`, `free`, `nvidia-smi`, `tailscale status`, `tailscale serve status`, `ps` for `ccd-cli` and `codex app-server`, `/proc/<pid>/environ` for the Codex bootstrap, `~/.codex/config.toml`, `/dev/mei0`, `dmidecode`, `ss -ltn` (port 9234 free), `npm view @openai/codex version` (0.153.4).
- Credits: transcript fetched via TranscriptAPI (2 credits in total for this video: one manual fetch, one via the skill script).

## Appendix: Full transcript (agent)


**[0:03]** I got to ask you about uh how is your setup uh programming setup changed? So, keyboard, voice, what's the IDE? >> It's crazy to think about now, but yeah, I used TextMate for almost 20 years. I used TextMate starting in 2005, I think. I helped get the first version out, and then I just wasn't interested. I wasn't in the market for an alternative. And it wasn't until the switch to Linux that I was forced out of my habitat. And now, with the switch to What are we calling it? Agentic engineering? I [ __ ] hate that term. We got to come up with something that sounds as plain as programming, but encapsulates the fact that it's with agents. But, >> I still think it should be called programming. >> let's just call it programming. >> Yeah. >> The programming with agents requires a different tool set. It really does. And the main change here is that you're going from single-thread programming in your head to parallel processing.

**[1:10]** When I was writing code, chiseling it by hand in TextMate or even Neovim uh not that long ago, I would just focus on one problem at the time. And I would methodically work my way through it, and that was actually the portal to flow. The portal to flow was deep immersion into a single problem, see it through to the end. >> Mhm. >> That's not how it works with agents. In part, because the agents are at once both too fast and too slow. They don't give you an immediate reply on something that you asked them to do that's the same as typing on a keyboard. So, you have to let the agent cook >> Mhm. >> for a bit. And therefore, you realize, well, if I just sit around waiting for them, first of all, that doesn't feel productive. Even if the agent, just one of them can be highly productive, it does not feel productive, it doesn't feel good. It feels actually like you're a little bit useless. >> Mhm.

**[2:07]** >> And maybe I had a moment when the first agentic moment was there and we I was running mostly one agent at a time where I felt like I don't know about this. But you can solve a lot of hard problems by just throwing more resources at it. This is the whole scaling law of AI itself, right? That if you paralyze these things and you're not running one agent, but you're running a handful, you can feel like you're in a flow state because you're constantly doing programming work in the sense that you're making decisions and you're helping either unblock an agent because it has a question about which direction to take or you're ready for a new task. And to do that, you need a different setup. I started first doing it in tmux and just having separate panes and having separate splits. Basically, a terminal with tabs is a good way to think about you open a bunch of tabs. I think most humans know exactly how that works. They don't work in just one tab.

**[3:06]** >> So, uh still sticking to the terminal CLI. >> Absolutely. >> So, you're not using cloud code app or the codex app or the >> I love the fact that this agent revolution was kicked off in the terminal because I was already a huge fan of TUI's, terminal user interfaces, and the terminal in general. That feels like a a really [clears throat] nice place to be. It's a beautiful place to be. The modern terminal is just a good looking place to work. So, >> >> I like that. And um and then this fact of having multiple agents, especially once it's not just multiple agents running on your own machine, but you start running multiple machines. Now, tmux alone is not enough to keep track of it. And that's why as of late I've switched to this thing called Herder. And Herder's essentially team mugs plus agent notifications. So, whenever your agent is done or needs something for you, it goes ding. A little a little bell telling you it's ready for its human uh Is it Is it master or servant? I'm not quite sure always.

**[4:15]** >> >> But, it is ready for a decision. And it also keeps track of these Is it is it working or not? So, I have this Herder set up. I have multiple Herder setups actually running on individual machines. I went on this crazy phase just about a month ago realizing that doing this work on a single machine is not fast enough. It's like I've discovered multi-core programming, but I only have two cores. I'm like, what if I had 16 cores? What if I had 32 cores? What if I had 64 cores? So, I instantly went out and I bought these amazing KVMs called gli.net comets. >> Mhm. >> And what they do is it's this little box. You plug in HDMI, you plug in USB, and connect it to the computer. It's like a KVM. So, KVM is a a remote way of controlling computer. But, what's special about this is just how easy it was. You connect this thing in, you go to a webpage, log in once at one password. Now, this thing can hop on your Telnet.

**[5:16]** >> Mhm. >> This has been the other revolution of the last year for me. It's discovering these WireGuard networks. Tailscale is essentially turning all the computers you have into a local network wherever you are. >> Mhm. >> Like right now on my phone, I have direct access to all the computers in my Malibu office. I also have access to all my computers in my Copenhagen office. And I can treat them as though I sat right next to them without having to punch holes in a firewall or set up complicated VPNs and what this does is it just decreases the friction it takes to get new compute online. So, as soon as I discovered this, I looked in my closet and I realized I had a bunch of mini PCs from prior experiments. I just said, "What if I just connected all of them?" And I just connected four of the computers in a closet. They all had their little comment and suddenly I could run agents on more computers at the same time and I could control them all with Herder.

**[6:20]** And it did get to a point where I maxed out my own processing power. That I think at about What do I want to put it? About four to five machines running I don't know, three agents. I have about 16 threads. That's what I can run. And the faster the agents run, of course, the fewer threads I can run. But at the current pace I can run about 16 threads. >> >> At at full acceleration. And that's part of why I've gone from just being excited about the agent moment to being delirious. Because I think I should say some of it is a little assaulting and again, we're on we're on the dial-up bandwidth wise with our computer. I mean, it's actually hilarious. So, you think of I'm sitting here a year ago, right? I'm chiseling my code. I'm writing my lines. And over the course of like an hour, I will have written one beautiful controller, one beautiful model. Like that's one file. And I really worked on it, right? So, maybe there's 60 lines left. So, maybe my bandwidth at this moment is like 30 lines an hour. I think that's even high. Maybe it's 20 lines an hour.

**[7:31]** Now I'm running 16 threads. I'm producing at sometimes hundreds of lines of hour or or hundreds of lines of code per hour. Now, let me pause myself there for a hot moment. I hate that metric, right? Like lines of code is a stupid metric in general to measure these things, and I think it's right from someone in the programming community to ridicule the AI psychosis when everyone talks about the number of lines of code they're writing, and then you ask them, "What did you build?" And then like, "Well, I didn't And then no good answer comes out, right? It's just a nice shorthand >> It is a nice shorthand. It is a representation and encapsulation of >> how much output that's coming out. Now, whether that output is good or bad is not a referendum on that. But, I was producing and producing so much more now, right? And therefore, I'm able to keep all these threads going. So, that's the setup. It's still Neovim, but at this point we're not writing a lot of code. So, I'm using Neovim as a project browser, and then as a way to kick off lazy get to see the change log for what's there. And even that, I'd say if GitHub was a little faster at showing you your pull request, the web is probably actually a nicer place to do that.

**[8:46]** I don't know. There's also this other tool I've been playing with a bit called hunk, which just produces diffs in a really nice way. So, you could look at that, too. But, I find that when I look at hunk, I only see the change set. And when I'm reviewing output from an agent, I often want to see the surrounding context. Oh, yeah, so it changed this file, but actually, what do we have in this other file that wasn't touched, but maybe should have been touched? So, that's why I still like Neovim as a way of doing it. Um, but it's all happening, by the way, of course, in Emacs. So, it's all happening on Linux. And this was the other major breakthrough with agents. Agents love the Unix philosophy. It loves individual tools that it can invoke through the command line. And there is no operating system on Earth of the majors. I'm counting three here: Mac, Windows, Linux, that works as well with that mechanism as Linux. Everything is in Linux it's either a config file or a CLI tool.

**[9:47]** Now, that was its main drawback 5 minutes ago. This was the reason people didn't like Linux. It's like it's all config files and CLI tools. >> Mhm. >> What great irony that the universe has played it upon us that now the drawbacks of Linux 5 minutes ago are now it's major selling points. This is one of the things I thought I was stuck for a weekend with a Mac uh 4 months ago. I thought I had a computer the place I was going that was a Linux machine so I didn't bring my laptop and I I found out when I arrived I only had a Mac Mini. So, I was going to make the best of a bad situation here and uh set up my Mac in some of the ways I've been thinking about with um with Linux. And you can actually do a lot now. Homebrew has gotten really quite good. Homebrew is the missing package manager for the Mac and no one has done more to move the Mac forward in terms of ease of setup. But, still something as simple as Raycast, I don't know if you've used that. That's the >> Yep.

**[10:54]** >> There's no config file that you can just access. You have to go into the GUI, export a file, then take that file, I don't know, in your freaking backpack on a USB key. >> Mhm. >> And then you can import it somewhere else. You cannot automate the entire setup of your machine. You can't automate at all the configuration of Mac's default key bindings. That has to be a manual process where you're clicking with a mouse like a caveman to set up your machine. >> I mean, there's ways around it. >> Not good ones. I looked. I tried hard. >> So, here's here's my been my journey. Obviously, I'm a Linux person, but because of Adobe Premiere, Adobe products, I'm also a Windows person. So, often times I would use WSL, Windows Subsystem for Linux. So, Linux inside Windows, which is in the agentic era, is not a good kind of Linux cuz it's just >> It's a sandbox. >> It's a sandbox and you want the Linux to be unleashed to be able to do everything.

**[11:50]** >> Correct. >> And so, I have now woken up to things like Grey Cat and have you know, I'm a keyboard person. Where is the config file? Can I Can I Can I basically do everything where an agent can can set everything up for me and save the configuration so I can replicate across systems and everything is automated. And so, I had to ask a lot of those questions and a lot of them are missing. >> have good answers. >> But often times you could actually just build the app yourself. >> But they're a hacks. >> They're hacks. >> They're hacks. You don't have to live like this, Lex.
