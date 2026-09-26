---
title: My Mobile AI Coding Setup: Tailscale, Herdr & Moshi
video_url: https://www.youtube.com/watch?v=9-tOItWRaiw
video_id: 9-tOItWRaiw
channel: imran
published: 2026-08-06
duration: 6:17
researched: 2026-09-26
focus: does this setup suit David and the way he works (third look at Herdr, after 6 Sep and 19 Sep)
tags: herdr, moshi, mosh, tailscale, ghostty, hermes agent, mobile coding, terminal multiplexer
---

# My Mobile AI Coding Setup: Tailscale, Herdr & Moshi

## Summary

A six-minute screen recording by a solo builder ("imran") showing how he keeps AI coding agents running on a Mac mini and picks them up from his iPhone. The pieces are Ghostty (a terminal), Herdr (a terminal multiplexer that knows about coding agents), Moshi (a phone terminal app built on the Mosh protocol), Tailscale (a private network joining his devices) and Hermes Agent (Nous Research's open-source agent). His point is that the session stays alive when he walks away, and that Herdr, unlike tmux, is usable with a thumb on a touchscreen. Research confirms the setup works as shown, and that Moshi now has an Android build, so it would run on your Pixel 9 Pro. The one limitation he mentions (Meta's Muse not detected) was fixed in Herdr 0.9.0 on 7 September. **Verdict for you: it solves a problem you mostly do not have, in a form you have already said you do not want (typing into terminals, reading long output on a phone).** Details under "Does it suit you?".

## Does it suit you?

This is the third time Herdr has come up, so this section builds on the two earlier write-ups rather than repeating them:

- **6 September, DHH's setup** (Claude): [the DHH research page](https://hlab.taila51191.ts.net:9459/dhh-setup/). Verdict: do not make Herdr your cockpit; it is a terminal, and you work in the Claude Code desktop app for its voice input, paste and session list.
- **19 September, Herdr under Codex and Claude** (Codex, bead `gwth-launch-1k1r`): [the decision brief](https://hlab.taila51191.ts.net:9459/herdr-codex-claude-decision.html). Verdict: a small pilot of Herdr on hlab as the place headless Codex and Claude sessions live, never as a replacement for Beads, the cockpit or the apps.

This video is a different angle from both: not "many agents" but "my phone". So the question is whether the phone half fits you.

### What the video does, set against what you already have

| What imran gets from the setup | What you have today | Gap? |
|---|---|---|
| Agents run on an always-on box, not the laptop [3:01] | Every Claude Code desktop session already runs its engine on hlab; the Codex app is SSH-connected to hlab | None |
| Phone, laptop and server on one private network [3:01] | Tailscale already joins hlab, x1eg3 and the Pixel 9 Pro (`pixel-9-pro` is on the tailnet today) | None |
| Session survives closing the laptop or losing signal [4:00] | Claude Code desktop's SSH engine keeps running through sleep, app quit and dropped SSH | None |
| Pick up a running agent from the phone [1:46] | Claude mobile app / Remote Control for Claude sessions; Codex Remote for Codex threads (both GA, both documented in the 6 Sep research) | Small: these show the conversation, not the raw terminal |
| Voice input on the phone [5:27] | Android dictation, and the cockpit's TALK dictation on HTTPS pages | None |
| One list of which agents are working, waiting or done | The cockpit Inbox (only what needs you and is still true), plus the desktop app's sidebar | Small |

### Where it clashes with how you have said you work

1. **You are committed to the GUI, not the terminal.** Your recorded preference (memory `gui-committed-workflow`) is that the desktop app's voice, paste and multi-session list are the point, and tmux-style tools are acceptable only as an invisible keep-alive on hlab. This whole video is a terminal workflow; Herdr's own shortcuts start with `ctrl+b` [0:42].
2. **You do not want to read or edit on the phone.** On 24 September you said you only edit on the desktop, and the phone is for alerts, video, listening and the published check (memory `pipeline-desktop-edit-phone-companion`). Moshi's whole purpose is reading and typing into a terminal on a phone screen.
3. **You pull, you do not want pushes.** You moved alerts into the cockpit because you were ignoring Telegram. Moshi's "Agents feed" and push notifications would be a second inbox competing with the cockpit.
4. **One machine, not five.** Herdr 0.9.0 now shows several machines in one window, which removes one of the 6 September objections. But the value of that grows with the number of agent machines, and you have one (hlab).

### Where it could still earn a place

- **The 19 September pilot is unchanged by this video.** If you do want Herdr, the sensible role is still the invisible one: hlab's keep-alive for headless and overnight Codex/Claude runs, which the cockpit could read through Herdr's socket API. Moshi then becomes an occasional way to peek at those raw sessions from the Pixel.
- **A true emergency on the move.** If an overnight run is stuck at a prompt that neither the Claude app nor the cockpit can answer (a raw shell, a `sudo` prompt, a test runner), a phone terminal is the only way in. Moshi's free tier does plain SSH over Tailscale, which is enough for that, at no cost.

### Cost if you did try it

- Herdr: free, Apache-2.0, a single binary on hlab. Current release 0.9.1 (16 September).
- Moshi on Android: free for SSH, push and the agents feed; **Pro** is needed for Mosh (the "survives losing signal" part) and automatic Herdr reattach: $7.99/month, $69.99/year or $199 lifetime (offer prices until 1 October; normally $9.99 and $89.99), shared across up to three devices.
- hlab would also need `mosh-server` installed and UDP 60000-61000 reachable over Tailscale for the Pro Mosh mode.
- Your time: about 30 minutes to try, more to learn the shortcuts.

### Recommendation

**Keep what you have.** The video's core promise (an agent that keeps running and that you can reach from the phone) is already true for you, through the desktop app and the Claude and Codex mobile apps, without asking you to read terminals on a phone. The only piece you lack is the raw terminal on the phone, and your own rules say you do not want to work that way. If a stuck overnight run ever needs a raw shell from the phone, install the free Moshi on the Pixel then; there is nothing to buy or set up in advance.

## Key takeaways

- The setup is five pieces: Ghostty terminal, Herdr multiplexer, Moshi phone app, Tailscale network, and whichever agent you run (he uses Hermes and Codex) [0:14], [3:01], [5:27].
- Herdr splits a terminal into named workspaces, panes and tabs, all of which stay running when you close the window [0:14].
- `ctrl+b` is Herdr's prefix key; `ctrl+b ?` lists every shortcut; `ctrl+b shift+N` makes a workspace and `ctrl+b shift+W` renames it [0:42].
- On the phone, Moshi lists the Herdr workspaces and you can tap between them; changes show on the Mac at the same time [1:46].
- His reason to prefer it over tmux is touch, not persistence: tmux also keeps sessions, but "it definitely was not touchscreen optimized" [4:00].
- For some jobs he still uses the ChatGPT app's Codex remote control rather than this setup [4:00].
- The one limit he hit, Meta's Muse not being recognised, was fixed in Herdr 0.9.0 on 7 September (now outdated) [5:03].
- Moshi's speech-to-text runs on the phone, so it is fast [5:27]; it offers Parakeet and Whisper local models.
- Moshi now ships on Android as well as iOS; the speaker's iPhone-only extras (Live Activities, Apple Watch) are the only platform gaps named.

## Who this is for and why it matters

The video is for people who already live in a terminal and want to keep working from a phone while away from the desk: a Mac mini at home, an iPhone in the pocket. It assumes you are comfortable with keyboard shortcuts and with an agent's raw terminal output.

For you, it matters mainly as a third data point on Herdr, and because it adds Moshi, which neither earlier write-up covered in depth. The honest connection to GWTH is thin: it would change how you reach running agents, not what they build.

## Chapter by chapter

### [0:00] My terminal setup
He made the video because someone asked about his setup. "The first part of the setup is this thing called Herder" [0:01] (the transcript's "Herder" is Herdr throughout).

### [0:14] Organizing workspaces with Herdr
Ghostty is the terminal; Herdr runs inside it. He is unsure how to classify Herdr, but for him it breaks the terminal into workspaces, each of which can hold split panes and tabs, and "I can leave that open" [0:30].

### [0:42] Useful keyboard shortcuts
`ctrl+b` opens Herdr's command layer; `?` then lists every key binding. The two he uses are `ctrl+b shift+N` (new workspace) and `ctrl+b shift+W` (rename workspace); he names one "Twitter" for the demo [1:10].

### [1:20] Running AI agents
Inside the workspace he starts an agent he calls "Prime Agent", which "just came out" [1:25]. We could not identify this; it may be a transcription error. Every agent appears in Herdr's side panel and can be clicked through [1:38].

### [1:45] Connecting from my phone
He opens Moshi on the phone, which lists the Herdr workspaces; he picks "Twitter" and types "hi", which appears on the Mac too [1:55]. He can walk away, lose signal and come back; he can tap between workspaces on the phone and the Mac follows; he creates a new workspace from the phone and starts Codex in it [2:47]. His claim: "Herder is completely mobile optimized" [2:20].

### [3:01] How Tailscale connects everything
Phone and Mac mini are on the same Tailscale network, which he explains as "a private club for all your devices" [3:25]; any device can reach any other from anywhere. He says you can add "a theoretically unlimited" number of devices [3:45].

### [3:59] Why I prefer this over traditional SSH
For some cases he still uses "the chat GPT app with codex and the remote control feature" [4:05], but day to day he runs Hermes Agent in this setup. The benefit over a plain SSH app is that the session survives walking away, "unless you had team mux set up" [4:20]; the benefit over tmux is that he no longer needs to remember hotkeys and it is touch-friendly [4:45].

### [5:03] Current limitations
Meta's new model, Muse, was not detected inside Herdr; he expects a fix. Fixed since: Herdr 0.9.0 added Muse detection.

### [5:27] Moshi and on-device speech-to-text
Moshi has a microphone button for dictation, which he compares to Wispr Flow and SuperWhisper, and it runs on the device so latency is low [5:40]. Moshi is "built on top of this thing called Mosh" [6:00].

## Claims and verification

| # | Claim (timestamp) | Status | Evidence | Source |
|---|---|---|---|---|
| 1 | Herdr's main hot key is `ctrl+b` [0:42] | Verified | Docs give the prefix as `ctrl+b`, tmux-style | [Herdr docs](https://herdr.dev/docs/) |
| 2 | `ctrl+b ?` lists all key binds; `shift+N` new workspace, `shift+W` rename [0:50] | Unverified | Shown on screen; not checked against the keybinding reference | [Herdr docs](https://herdr.dev/docs/) |
| 3 | Herdr is "completely mobile optimized" [2:20] | Partly true | Herdr is mouse-first (click panes, drag borders, right-click menus), which is what makes taps work through Moshi; there is no Herdr phone app | [Herdr docs](https://herdr.dev/docs/), [Moshi docs](https://getmoshi.app/docs) |
| 4 | Switching workspace on the phone is reflected on the Mac [2:30] | Outdated | True in August; since 0.9.0 several clients can view different workspaces independently | [Herdr v0.9.0 notes](https://github.com/herdrdev/herdr/releases/tag/v0.9.0) |
| 5 | Muse (Meta) is not detected in Herdr [5:03] | Outdated | 0.9.0 (7 Sep 2026) "Added Muse agent detection for idle, working, approval, and question states" | [Herdr v0.9.0 notes](https://github.com/herdrdev/herdr/releases/tag/v0.9.0) |
| 6 | Tailscale allows a theoretically unlimited number of devices [3:45] | Verified | Free Personal plan: up to 6 users, unlimited user devices | [Tailscale pricing](https://tailscale.com/pricing) |
| 7 | Plain SSH apps lose the session when you walk away unless you run tmux [4:20] | Partly true | Correct for SSH; Mosh and tmux/Herdr each solve a different half (network roaming vs process persistence) | [Moshi docs](https://getmoshi.app/docs) |
| 8 | The ChatGPT app has a Codex remote control feature [4:05] | Verified | Codex Remote (QR-paired phone) GA 26 June 2026, per the 6 Sep research | [6 Sep research](https://hlab.taila51191.ts.net:9459/dhh-setup/) |
| 9 | Hermes Agent is a usable daily coding agent [4:10] | Verified | Nous Research, MIT licence, released Feb 2026; Hermes Desktop in preview since 2 June | [Hermes Agent](https://hermes-agent.nousresearch.com/) |
| 10 | "Prime Agent" just came out [1:25] | Unverified | No product found under this name; likely a garble | none |
| 11 | Moshi's speech-to-text is on-device [5:40] | Verified | Engines: Parakeet, Whisper, Apple or cloud; local models are downloaded; free tier includes 3 min/month of cloud dictation | [Moshi](https://getmoshi.app/), [Moshi subscription](https://getmoshi.app/docs/subscription) |
| 12 | Moshi is built on Mosh [6:00] | Verified | Native Mosh transport, but Pro-only | [Moshi subscription](https://getmoshi.app/docs/subscription) |
| 13 | Moshi is the app to use (shown on iPhone) [5:27] | Verified, wider now | Android build on Google Play; Pro licence shared across iOS and Android, up to 3 devices | [Google Play](https://play.google.com/store/apps/details?id=app.getmoshi.android), [Moshi pricing](https://getmoshi.app/pricing) |

## Tools, products and people mentioned

| Name | What it is | Role in the video | Current status (as of 2026-09-26) | Official link |
|---|---|---|---|---|
| Herdr | Terminal multiplexer that detects coding agents and shows their state | The workspace layer | v0.9.1 (16 Sep 2026), preview builds to 21 Sep; Apache-2.0; ~40.9k GitHub stars, 365 open issues; multi-machine view since 0.9.0; "Herdr Cloud" announced as coming | [herdr.dev](https://herdr.dev/) |
| Moshi | SSH/Mosh terminal app for phones, aware of tmux, Zellij and Herdr | How he connects from the phone | iOS and Android; free tier; Pro $7.99/mo, $69.99/yr, $199 lifetime (offer to 1 Oct); host daemon `moshi-hook` for the agents feed | [getmoshi.app](https://getmoshi.app/) |
| Mosh | Mobile shell protocol over UDP that survives network changes | Underneath Moshi | Mature open-source; needs `mosh-server` on the host | [mosh.org](https://mosh.org/) |
| Tailscale | WireGuard-based private network | Joins phone and Mac mini | Free Personal plan: 6 users, unlimited devices | [tailscale.com](https://tailscale.com/) |
| Ghostty | Terminal emulator | His Mac terminal | Current, free | [ghostty.org](https://ghostty.org/) |
| Hermes Agent | Open-source agent by Nous Research with persistent memory and self-made skills | His daily agent | MIT; v0.15.x; Hermes Desktop preview | [hermes-agent.nousresearch.com](https://hermes-agent.nousresearch.com/) |
| Codex CLI | OpenAI's coding agent | Started from the phone as a demo | Current | [OpenAI Codex](https://developers.openai.com/codex) |
| Muse | Meta's new model/harness | The one agent Herdr missed | Detected since Herdr 0.9.0 | none checked |
| Wispr Flow, SuperWhisper | Desktop dictation apps | Comparison for Moshi's dictation | Not researched | none |

## What has changed since the video was published

- **Herdr 0.9.0 (7 Sep):** one window can now hold several machines over SSH, with a combined agent list and independent reconnects. This removes the "one host per client" objection in the 6 September research. [Release notes](https://github.com/herdrdev/herdr/releases/tag/v0.9.0)
- **Herdr 0.9.0:** Muse is now detected, which fixes the limitation in the video. Several clients (Mac and phone) can now look at different workspaces at once rather than mirroring each other.
- **Herdr 0.9.1 (16 Sep)** is the current stable release; "Herdr Cloud" (connect machines without configuring SSH) is announced. [Herdr docs](https://herdr.dev/docs/)
- **Moshi on Android:** a Google Play build exists and shares the Pro licence with iOS, so the setup is no longer iPhone-only. [Moshi docs](https://getmoshi.app/docs)

## Related material worth reading

- [Your 19 Sep Herdr decision brief](https://hlab.taila51191.ts.net:9459/herdr-codex-claude-decision.html): the pilot design for Herdr under Codex and Claude, with the alternatives compared.
- [Your 6 Sep DHH setup research](https://hlab.taila51191.ts.net:9459/dhh-setup/): why the cockpit is the desktop app, not Herdr; the Codex-on-laptop analysis; KVM options.
- [Herdr docs](https://herdr.dev/docs/): the official reference, including agents, socket API and the new multi-machine commands.
- [Moshi docs](https://getmoshi.app/docs): Herdr integration, `moshi-hook`, dictation engines and Tailscale guidance.
- [Coding agents in my pocket: Moshi on iOS with Herdr on the Macs](https://mariospina.com/blog/moshi-herdr-agents-from-my-phone/): a second first-hand account of the same combination.
- [Dave Ebbelaar, "How to set up Herdr for multi-agent coding"](https://www.youtube.com/watch?v=Shqtk_2Jd3c): a longer walkthrough already in your GWTH idea playlist.

## Open questions and caveats

- Whether Moshi's Android build has full parity. Its docs name only iOS extras (Live Activities, Apple Watch) and say the Pro entitlement is identical, but we have not run it on the Pixel.
- Whether the Claude mobile app / Remote Control is actually part of your routine today. The table above says it is available; if you never use it, the phone gap is a little bigger than it looks.
- "Prime Agent" could not be identified.
- The video is a personal demo, not a tutorial; it does not cover security (Moshi keeps SSH keys on the phone, and a phone terminal can do anything your hlab user can).

## Implementation notes (agent)

### Procedures shown

1. Open Ghostty; start Herdr inside it [0:14].
2. `ctrl+b` then `?` to see bindings [0:45].
3. `ctrl+b shift+N` new workspace; `ctrl+b shift+W` rename it (named "Twitter") [0:58].
4. Start an agent in the workspace; it appears in the side panel [1:25].
5. On the phone, open Moshi, connect to the Mac over Tailscale, pick the Herdr workspace from the session list [1:46].
6. Type in the phone; it appears on the Mac [1:55]. Create a workspace from the phone by touch; start `codex` [2:47].

### Code and configuration

Reconstructed from the docs, not shown in the video. Only relevant if David picks the trial option; nothing below has been run.

```bash
# hlab: install Herdr from a pinned release binary rather than piping install.sh to sh (19 Sep brief's advice)
# https://github.com/herdrdev/herdr/releases/tag/v0.9.1
```

```bash
# hlab: needed only for Moshi Pro's mosh transport
sudo apt install mosh
```

```bash
# hlab: Moshi's agents feed and push need its host daemon (from the Moshi docs)
curl -fsSL https://getmoshi.app/install.sh | sh
```

```bash
# Herdr 0.9.0+: add another machine to one Herdr window
herdr machine add workbox
```

### Decisions, trade-offs and gotchas

- Mosh and Herdr solve different halves: Mosh keeps the network link alive when the phone changes network or sleeps; Herdr (or tmux) keeps the processes alive when no client is attached. Moshi free tier without Mosh still works with Herdr, because Herdr keeps the agent running; you just reconnect by hand.
- Moshi Pro is required for Mosh and automatic Herdr reattach.
- A Mosh server needs UDP 60000-61000; over Tailscale this is fine without opening anything publicly.
- `moshi-hook` would add a second notification channel. David moved all alerts to the cockpit (`scripts/cockpit_alerts.py`, memory `alerts-cockpit-not-telegram`); do not wire Moshi push without his say-so.
- Herdr state for Claude Code and Codex is detected from the screen, so it is advisory (19 Sep brief).

### How to apply this in a codebase

Nothing to apply unless David chooses an option. If he picks the trial:
1. Install Herdr 0.9.1 on hlab from the release binary; do not change any existing tmux/systemd keep-alive.
2. Install Moshi free on `pixel-9-pro`; connect to `hlab.taila51191.ts.net` over SSH with a new phone-only key; add that key to `~/.ssh/authorized_keys` on hlab.
3. Try: start a Herdr workspace with `claude` in a test worktree, walk away, reattach from the phone.
4. Record the outcome on bead `gwth-launch-1k1r` (closed) or a new bead; do not touch cockpit alerts.
Repos touched: none (it is machine setup). If it becomes the 19 Sep pilot, the cockpit read-only integration lands in GWTH-launch-plan.

### Terminology and entities

- **Multiplexer**: a program that runs several terminal sessions inside one window and keeps them alive when you disconnect (tmux, Zellij, Herdr).
- **Mosh**: mobile shell; UDP-based replacement for the SSH transport that survives roaming and sleep.
- **Tailnet**: a Tailscale private network; David's is `taila51191.ts.net`.
- **moshi-hook**: Moshi's host-side daemon that reports agent approvals, questions and completions to the phone.
- **Hermes Agent**: Nous Research's open-source, memory-keeping agent.
- **Ghostty**: a GPU-accelerated terminal emulator.

### Notable quotes

- "What it does for me is that it lets me break up my terminal into different work spaces." [0:20]
- "If you're using Herder, the main hot key that you need to know is control B." [0:42]
- "If I say hi here, it's instantly available on my phone." [1:55]
- "I can close this at any given time. I can go for a walk." [2:05]
- "Hurder is completely mobile optimized." [2:20]
- "A private club for all your devices." [3:25]
- "It definitely was not touchscreen optimized like this one is." [4:50]
- "I was actually unable to get it to be detected inside of Herder." [5:10]
- "It's completely on device as well, so the latency is super low." [5:45]

### Research log

- 2026-09-26 TranscriptAPI transcript + /info (1 credit used).
- Local: `GWTH-launch-plan/docs/herdr-codex-claude-decision.md` (19 Sep brief, bead gwth-launch-1k1r, closed); `claude-code-setup/kanban/1_planning/RESEARCH_2026-09-06_dhh-herdr-kvm-tailscale-setup.md`; memories `gui-committed-workflow`, `pipeline-desktop-edit-phone-companion`, `alerts-cockpit-not-telegram`; `tailscale status` (pixel-9-pro on the tailnet, Android).
- WebSearch "Moshi app mosh terminal iOS Android herdr": App Store, Google Play, getmoshi.app, mariospina.com.
- WebFetch https://herdr.dev/docs/ : v0.9.1, prefix ctrl+b, mouse-first, multi-machine.
- WebFetch https://herdr.dev/docs/mobile/ : no dedicated mobile page content; multi-machine `herdr machine add`, Herdr Cloud announced.
- GitHub API herdrdev/herdr releases + repo: v0.9.1 16 Sep, v0.9.0 7 Sep, 40,871 stars, 365 open issues, Apache-2.0; v0.9.0 notes (multi-machine, Muse detection, independent clients).
- WebFetch https://getmoshi.app/docs , /docs/subscription , /pricing , homepage: platforms, free vs Pro, prices, dictation engines, moshi-hook.
- WebSearch "Hermes Agent Nous Research": MIT, Feb 2026, Hermes Desktop preview.
- WebFetch https://tailscale.com/pricing : Personal plan 6 users, unlimited devices.
- Google Play page fetch returned no content (not used).

## Appendix: Full transcript (agent)


### [0:00] My terminal setup

**[0:01]** Okay, I wanted to make a quick video going more in-depth on uh my actual terminal setup because like someone asked me to make a video explaining it. So, uh the first part of the setup is this thing called Herder.

### [0:14] Organizing workspaces with Herdr

**[0:14]** Um it's running inside of my terminal. So, this is Ghosty. Um Ghosty's the terminal I'm using. And Herder is I don't know exactly the point of like I don't know exactly how they classify Herder. But what it does for me is that it lets me break up my terminal into different work spaces. And I can create like, you know, a bunch of different work spaces. I can split the panes so I can have like two terminals running in one work space. I can leave that open. I can have tabs running in a work space and I can leave that open.

### [0:42] Useful keyboard shortcuts

**[0:42]** Um if you're using Herder, the main hot key that you need to know is control B. Control B will open up this thing right here. Um then you can hit the question mark and you can see all the different key binds. Um so, you can like if you want [clears throat] to be like the person that just does it completely with the keyboard and navigates around in your terminal with that, like you can also you can learn all the hot keys. Um pretty easy. The ones that I actually care about for me are um if I do control B and then shift N, that makes a new work space. And then control B and shift W, that renames the work space. So, let's make this one like Twitter or something.

### [1:20] Running AI agents

**[1:20]** Okay, so I have a work space here. And then inside the work space, I can fire off an agent. So, let's say I want to run um >> [clears throat] >> Prime Agent, right? This one just came out came out just now. So, let's say type in Prime Agent. You can see I have the agent loaded up. Um I can actually click through the agent in like I can click through all of the different agents on the side panel. And then when I connect to it on my phone,

### [1:45] Connecting from my phone

**[1:46]** so let's make a connection here. I can actually um connect to the specific Herder work space from my phone. So, let's see. You can see the Twitter one just came up, right? So, let's let's jump on this one. And now I have access to the same workspace. If I say hi here, it's instantly available on my phone. Um and I can just pick up where I left off. So, I can close this at any given time. I can go for a walk. Um let's say if I lose connection, right? Like I can always come back here. I can also, just using like the touchscreen on your phone, like you can switch between the different workspaces while you're inside mobile. So, Hurder is completely mobile optimized. So, I can click in here and I can jump to a different workspace and it'll reflect on my terminal on my computer as well. So, I can just say like whatever. I can just do my work here. Um and then I can do that like while I'm out and about and then I can like come back and also just like continue and pick up the session where I left off, right?

**[2:47]** Um and I can also just create from here. Let's say I want to create a new tab, new workspace. I can do it really easily just with the touchscreen. Let's go and make a new workspace. They got Codex installed. Let's fire up Codex. Cool. And you can see it's like it's here. Um

### [3:01] How Tailscale connects everything

**[3:01]** pretty cool. So, the way that like all of this is working is, of course, um my phone and my Mac mini, I'm on the Mac mini right now, they're on the same uh Tailscale network. So, you'll have to install Tailscale and basically what it does is it puts all of your devices on like its own VPN or like virtual private network. Basically, like if you can think of the internet as like this big network, a VPN is like a small subset network that's like gated from everyone else, but it's like a kind of like a private club for all your devices. So, uh Tailscale puts them all on their like on like a VPN together so that no matter where you are in the world, like you can access um all the different devices, right? So, my phone can access my Mac mini, my Mac mini can access my phone. Um my laptop can access all of these. So, you can just add like an unlimited amount of devices to your um to your Tailscale network or theoretically unlimited and you'll be able to like securely access all of them. So yeah, that's my setup. Um,

### [3:59] Why I prefer this over traditional SSH

**[4:00]** there are still use cases where this is like not the best. For those I tend to use the chat GPT app with codex and the remote control feature. Um, but for most things that I do day-to-day, I prefer to use Hermes agent inside of this setup. Um, and then you know, you can see like just it just keeps everything persistent. I can come back to this whenever I want. I can start some work while I'm on the go and I can come back and pick it up. Um, and I can and I think the the big the biggest benefit for me is like let's say before with like typical SSH apps, unless you had team mux set up, uh, if you like started a session and you walked away, um, you would have to restart all over again, right? You'd basically lose the connection. So this kind of keeps it alive and lets me come back to it whenever I want. Uh, the other big benefit of this for me like with something like team mux, there was like all these like hot keys that I would have to know. It definitely was not touchscreen optimized like this one is.

**[4:55]** Uh, so that was like super annoying, but this is all kind of solved. Uh, so yeah guys, hope that explained the setup.

### [5:03] Current limitations

**[5:03]** And you can see I even have the Oh yeah, one of the limitations I found is um, I actually just fired up Muse which is like the new Harness. No, no, the new model from Meta and I was actually unable to get it to be detected inside of Herder. So I imagine that in a future update, um, this will be fixed. But that was like the only limitation I found.

### [5:27] Moshi and on-device speech-to-text

**[5:27]** Also, you can't see it on my phone screen, but when you're on the Moshie app, oh, I forgot to mention the app that I'm using to connect is called Moshie and you can see I can just quickly, easily jump back and forth between all of my sessions. Um, and when you're using Moshie, there's like on your phone itself, uh, you can use like text to speech, no speech to text sorry. So you can just like turn on the microphone, you can talk to it the same way you talk to like WhisperFlow or SuperWhisper, and it works basically the same way. And it's completely on device as well, so the latency is super low. So I recommend you check out Moshi as well. Moshi is like built on top of this thing called Mosh. I don't know the specifics of it, but all together this just makes it a really really good setup and I'm able to just do a lot of things on the go. So yeah, thanks for watching guys.
