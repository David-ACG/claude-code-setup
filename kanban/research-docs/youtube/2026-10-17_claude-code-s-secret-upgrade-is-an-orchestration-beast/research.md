---
title: Claude Code's Secret Upgrade Is an Orchestration Beast
video_url: https://www.youtube.com/watch?v=mKjxGy6vCnY
video_id: mKjxGy6vCnY
channel: Chase AI
published: 2026-10-16
duration: 18:49
researched: 2026-10-17
focus: Claude Code Projects concepts for GWTH; usage/credit burn
tags: claude code, projects, multi-agent orchestration, coordinator, threads, usage limits
---

# Claude Code's Secret Upgrade Is an Orchestration Beast

## Summary

Chase AI introduces **Claude Code Projects**, which he calls "Claude projects". It puts one coordinator conversation in front of a set of persistent "threads": full Claude Code sessions, mostly in Anthropic's cloud. He explains when it is worth using, walks through the settings, and builds an "AI Creator Radar" dashboard in a 25-minute demo. The mechanics hold up against the official docs. The coordinator defaults to Opus at low effort, threads keep their own context, there are project instructions and project memory, usage comes out of your subscription, local threads are possible, and secrets live in a cloud environment.

He gets four things wrong or overstates them:

- He dates the launch ("a couple months ago"). It launched on 17 Sep 2026.
- He says the rollout is open to everyone. The docs still say gradual, with a waitlist.
- He says threads run "24/7, never shut off". Sandboxes pause between turns, and idle threads resolve after a week.
- He says threads "share context". They share instructions and memory, not context windows.

He also understates the usage risk. Threads default to Opus at **high** effort, and a thread that hits the limit continues automatically when it resets.

The full analysis for GWTH is in [the Claude Projects lessons report](../../claude-projects/2026-10-17_claude-projects-lessons.md).

## Key takeaways

- **One coordinator, many full sessions.** You talk to one agent. It runs "full-blown Claude sessions", not subagents. Each has its own context, and you can message it directly [1:30] [5:57].
- **Usage comes out of your plan, not API billing** [1:30]. This is verified, but projects use the plan "faster", and threads that hit the limit continue on their own at reset (see Verification).
- **Don't use it for quick tasks, or for work that has to touch files on your machine** [3:42]. Local threads exist but "that isn't what it's really built for" [4:20].
- **Leave the coordinator on low effort. Run threads on Opus medium, or Sonnet, to save usage** [8:20] [8:55]. The docs' default for threads is high.
- **Project instructions are read by every thread. Keep them short: "less is more"** [9:40].
- **Project auto memory works like Claude Code's auto memory** [10:05]. Verified: a `MEMORY.md` index that every cloud thread reads.
- **Each project needs a GitHub repo.** Secrets and API keys go in a custom cloud environment, whose network access ranges from none to full [10:20] [10:48].
- **Blocked threads come back to you to answer.** In the demo, three of five threads were blocked on keys or decisions [13:20].
- **Debug access lets one project look at another whose context has gone bad** [11:50]. Unverified in the docs.

## Who this is for and why it matters

It is aimed at Claude Code users on Pro or Max who run long, cloud-friendly projects and want them to keep going while their own machine is off. You need a GitHub repo and some comfort with cloud environments and secrets.

For David, Projects itself is a poor fit, because GWTH depends on hlab's GPU, local files, Coolify, Tailscale and his `~/.claude` rules. The concepts map well onto his existing board, cockpit and worker setup, though: a single coordinator, one set of states, shared project memory, resumable workers, and per-thread usage. The lessons report turns these into six ranked recommendations.

## Chapter by chapter

### [0:00] Intro
He frames Projects as one agent controlling "a fleet of fullyfledged Claude sessions that run 24/7", which "share context, they share memory and they never shut off". He pitches it at people building complicated applications outside their local environment.

### [0:36] What Projects Does
Normally you manage the terminals and agents yourself, and work stops when your machine is off. With Projects, Claude becomes the project manager, running in Anthropic's cloud on your subscription ("pulling from your max plan"). The workers are full sessions, not subagents. Access is through a waitlist, which he says now clears within 24 hours. Projects shows up as "Projects beta" in the desktop app's sidebar, and is distinct from the old chat Projects.

### [3:42] When To Use It
Don't use it:
- for quick single-session tasks;
- for work on local files that can't live in a GitHub repo;
- for teams (not yet on Team or Enterprise).

Use it for complicated, long-running work that splits into parts, and as a backlog for ideas. Against subagents, the difference is persistence: threads keep their own context, own PRs, can be messaged directly, and are managed by Claude rather than by you.

### [6:51] Demo + Setup
Settings he covers:
- **New project:** a name, an optional goal, optional context.
- **Project settings, General:** coordinator model (default Opus 5.5, low effort) and thread model. He advises Opus medium, or Sonnet.
- **Auto-continue when usage limits reset.**
- **Pause, restart or archive.**
- **Memory:** project instructions and auto memory.
- **Environment:** a project repository on GitHub, plus a cloud environment (network access from none to full, secrets).
- **Local settings:** "let Claude use your device" and pre-approved folders.
- **Usage tab.**
- **Debug access** between projects.

The demo prompt split into five threads: dashboard and hosting, X scanner, YouTube coverage, content packs, and Claude Code news. After 25 minutes, two were ready for review and three were blocked. He fixed the key blockers by adding a cloud environment with a YouTube key as a network secret and telling the coordinator. The X scanner ran locally using the in-app browser's logged-in session and created a local scheduled routine. The finished dashboard shows trending X stories with no YouTube coverage, content packs for each story, and a refresh log.

## Claims and verification

| # | Claim (timestamp) | Status | Evidence | Source |
|---|---|---|---|---|
| 1 | Projects uses your Max plan usage, not API billing [1:30] | Verified | "counts against the same plan limits as your other Claude Code sessions". It goes past them only if usage credits are on. | [Docs](https://code.claude.com/docs/en/claude-projects) |
| 2 | Workers are full sessions, not subagents [1:30] [5:57] | Verified | Threads are "a separate session with its own context window". | [Docs](https://code.claude.com/docs/en/claude-projects) |
| 3 | Threads "share context" and memory [0:00] [4:50] | Partly true | They share project instructions and project memory (`MEMORY.md`). The coordinator "sees what threads report back, not every step". Context windows are separate. | [Docs](https://code.claude.com/docs/en/claude-projects) |
| 4 | Runs 24/7, "never shut off" [0:00] | Partly true | Cloud threads continue with the laptop closed. Sandboxes pause between turns, a lost sandbox can drop uncommitted work, and idle threads resolve after a week. | [Docs](https://code.claude.com/docs/en/claude-projects), [Cloud envs](https://code.claude.com/docs/en/cloud-environments) |
| 5 | "First came out a couple months ago" [2:36] | Wrong | Launched 17 Sep 2026, a month before the video. | [Launch post](https://claude.com/blog/projects-redesigned) |
| 6 | "They let everybody off the wait list" [2:36] | Partly true | The docs still say "rolling out gradually" and link a waitlist. | [Docs](https://code.claude.com/docs/en/claude-projects) |
| 7 | Not on Team or Enterprise yet [4:29] | Verified | "They aren't available on Team or Enterprise plans yet." | [Docs](https://code.claude.com/docs/en/claude-projects) |
| 8 | Boris Cherny uses Projects as his backlog [4:50] | Unverified | No primary source found. | n/a |
| 9 | Coordinator defaults to Opus 5.5 at low effort [8:20] | Verified | "Opus everywhere, with high effort for threads and low effort for the conversation". | [Docs](https://code.claude.com/docs/en/claude-projects) |
| 10 | Projects can burn usage quickly; Opus medium for threads "should be totally fine" [8:55] | Verified (with a caveat) | The docs say it "uses them faster", and the default thread setting (Opus high) "draws on your plan fastest". The only hard cap is 200 new threads a day. | [Docs](https://code.claude.com/docs/en/claude-projects) |
| 11 | Auto-continues when usage limits reset [9:11] | Verified | A thread "waits and continues on its own when the limit resets". Routine-started threads stop instead. He presents it as a setting; the docs describe it as default behaviour. | [Docs](https://code.claude.com/docs/en/claude-projects) |
| 12 | Project instructions are read in every thread [9:40] | Verified | Sent to each new thread and to the coordinator, up to 16,000 characters. | [Docs](https://code.claude.com/docs/en/claude-projects) |
| 13 | Auto memory works like Claude Code auto memory [10:05] | Verified | Project memory is files with a `MEMORY.md` index, separate from local auto memory. Local threads don't load it. | [Docs](https://code.claude.com/docs/en/claude-projects) |
| 14 | Needs a GitHub repo [10:05] | Verified | GitHub.com only, and the Claude GitHub App is required. | [Docs](https://code.claude.com/docs/en/claude-projects) |
| 15 | Cloud environment network access from none to full, plus secrets [10:48] | Verified | The levels are None, Trusted (default), Custom and Full. Network secrets are injected by a proxy. | [Cloud envs](https://code.claude.com/docs/en/cloud-environments) |
| 16 | Threads can run on your machine in pre-approved folders [11:20] [15:00] | Verified | "Work locally" goes through Remote Control. The thread runs only while the machine is awake and doesn't get project memory. | [Docs](https://code.claude.com/docs/en/claude-projects), [Remote Control](https://code.claude.com/docs/en/remote-control) |
| 17 | Debug access between projects [11:50] | Unverified | Not found in the Projects docs page as checked. | n/a |
| 18 | Earlier Anthropic cloud options drew on the API [17:32] | Unverified | Cloud sessions (Claude Code on the web) have used subscription limits; the claim is not supported as stated. | [Costs](https://code.claude.com/docs/en/costs) |
| 19 | Opus 5.5 is more token-efficient than Fable 5.1 [18:26] | Unverified | Opinion. No benchmark cited. | n/a |

## Tools, products and people mentioned

| Name | What it is | Role in the video | Current status (as of 2026-10-17) | Official link |
|---|---|---|---|---|
| Claude Code Projects | A coordinator plus parallel threads for Claude Code | The subject | Public beta, Pro and Max, gradual rollout | https://code.claude.com/docs/en/claude-projects |
| Claude Code cloud environments | Sandboxed Ubuntu VMs for cloud sessions | Holds the secrets and network settings | Current | https://code.claude.com/docs/en/cloud-environments |
| Remote Control | Connects claude.ai to a session on your own machine | How local threads run | Current; local threads need v2.1.280 or later | https://code.claude.com/docs/en/remote-control |
| Routines | Scheduled Claude Code runs | The X scanner created a local routine | Research preview | https://code.claude.com/docs/en/routines |
| Opus 5.5 / Sonnet / Fable 5.1 | Claude models | Coordinator and thread model choices | Current | https://docs.anthropic.com |
| Boris Cherny | Creator of Claude Code | Said to use Projects as a backlog | n/a | n/a |
| GitHub | Code hosting | Required repo for threads and PRs | GitHub.com only (no GHES, GitLab or Bitbucket) | https://github.com |

## What has changed since the video was published

- Nothing material found in the single day between publication and research. Since launch, the "Work locally" option has been added; the press at launch called it "coming very soon" ([Implicator](https://www.implicator.ai/anthropic-claude-code-projects-opus-default/)).
- Open GitHub issues as of 17 Oct affect local threads and reliability: [#101398](https://github.com/anthropics/claude-code/issues/101398), [#101539](https://github.com/anthropics/claude-code/issues/101539), [#101368](https://github.com/anthropics/claude-code/issues/101368) and [#99091](https://github.com/anthropics/claude-code/issues/99091).

## Related material worth reading

- [Claude Code Projects docs](https://code.claude.com/docs/en/claude-projects). The authoritative reference; the "Usage and cost" section matters most.
- [Launch post: projects redesigned](https://claude.com/blog/projects-redesigned). Anthropic's framing.
- [Run agents in parallel](https://code.claude.com/docs/en/agents). Compares subagents, agent teams, workflows and Projects.
- [Costs](https://code.claude.com/docs/en/costs). Plan limits, usage credits and cache lifetime.
- [VentureBeat launch coverage](https://venturebeat.com/orchestration/anthropic-launches-claude-code-projects-an-always-on-conversation-that-remembers-and-delegates-your-long-running-dev-work)
- [The Register: "work and pay in parallel"](https://www.theregister.com/a/5297532). A sceptical take on cost.
- [GWTH lessons report](../../claude-projects/2026-10-17_claude-projects-lessons.md). How these patterns apply to David's setup.

## Open questions and caveats

- No credible third-party measurement of how much a project uses (weekly % per thread) was found.
- Whether a headless Linux box such as hlab can serve local threads through `claude remote-control` is undocumented.
- The "debug access" panel and the "auto-continue" toggle the video shows were not found in the docs as checked. They may be UI the docs don't cover.

## Implementation notes (agent)

### Procedures shown
1. Desktop app, Code tab: **Projects (beta)** in the left sidebar → archive old chat projects if asked → **New project** → name, optional goal, optional context → **Create project** [6:51].
2. Gear icon → **Project settings**. Under General: Coordinator model and effort (default Opus, low), Thread model and effort (default Opus, high; the video advises Opus medium or Sonnet) [7:46].
3. Usage-limit behaviour, Pause, Restart Claude, Archive [9:11].
4. Memory: project instructions (≤16,000 characters, sent to every thread) and auto memory (the `MEMORY.md` index) [9:40].
5. Environment: select the project repository (GitHub.com, Claude GitHub App) [10:05]. Cloud environment: **Add cloud environment** → name → network access (None, Trusted, Custom, Full) → add secrets [10:48] [14:34].
6. Local: "Let Claude use your device" = yes, plus pre-approved folders. Local threads use Remote Control (Claude Code ≥ v2.1.280) [11:20].
7. Usage tab: tokens per thread and model. Debug access: allow another project to inspect this one [11:50].
8. Unblock a thread: add the secret to the environment, then tell the coordinator ("I just updated the cloud environment with the YouTube key as a network secret") [14:34].

### Code and configuration
No code is shown. The settings live only in the UI ("not in `settings.json`", per the docs).

### Decisions, trade-offs and gotchas
- Coordinator on low effort is fine, because it routes and does not build (video and docs agree).
- Thread default is Opus high, the fastest burn. Lower it, or name a smaller model per task.
- Soft caps: "Run at most two threads" is not enforced. The hard cap is 200 new threads a day.
- Auto-continue spends the next usage window. Use Stop or Pause to prevent it.
- Idle threads watching a PR wake on CI failures and review comments.
- Reviving a thread idle for more than an hour re-reads its whole conversation. Prefer a fresh thread.
- Cloud threads don't load `~/.claude` user-level settings, skills or MCP servers.
- Local threads don't load project memory. Instructions are cut off at 8 KB ([#101398](https://github.com/anthropics/claude-code/issues/101398)).

### How to apply this in a codebase
See [../../claude-projects/2026-10-17_claude-projects-lessons.md](../../claude-projects/2026-10-17_claude-projects-lessons.md), section 7 (R1–R6). It touches GWTH-launch-plan (scripts, CLAUDE.md, memory/), firstmate (resume pattern) and the cockpit.

### Terminology and entities
- **Project conversation / coordinator:** the routing session.
- **Thread:** a worker session (cloud or local).
- **Project instructions:** standing text for every thread.
- **Project memory:** a `MEMORY.md` index plus files.
- **Cloud environment:** VM network and secrets config.
- **Remote Control:** the local-machine bridge.
- **Routine:** a scheduled run.
- **Landing:** a thread whose PR is approved or queued to merge.

### Notable quotes
- "You just talk to one agent and it controls a fleet of fullyfledged Claude sessions" [0:00]
- "It's not a cloud situation where now we're paying API cost. This is pulling from your max plan." [1:30]
- "These are not sub agents. It's controlling full-blown Claude sessions" [1:30]
- "If it's manipulating files and folders that quite literally live on our computer … we aren't going to want to use cloud code projects" [3:42]
- "It's not really the one doing the work. It's just the one coordinating" [8:20]
- "Usage is something that projects can burn up pretty quickly" [8:55]
- "Similar to how we approach agents.md these days, less is more." [9:40]
- "Sessions with the sub agents is best when we're just doing one task at a time … projects are great if we have a stream of work we just don't want to babysit." [6:30]

### Research log
- 2026-10-17. Fetched https://code.claude.com/docs/en/claude-projects (twice; verified the quotes on defaults, limits, states, memory and tuning).
- 2026-10-17. Subagent research: claude.com/blog/projects-redesigned; docs pages cloud-environments, remote-control, self-hosted-environments, costs, agents, routines; VentureBeat, The Register, Implicator, SSD Nodes, note.com; GitHub issues #101398, #101539, #102395, #96775, #101369, #97947, #99091, #101368, #98355; HN Algolia. Queries are listed in the lessons report session log.
- Credits: transcript fetched through TranscriptAPI (1 credit used).

## Appendix: Full transcript (agent)


### [0:00] Intro

**[0:00]** Claude has a secret feature hidden behind a weight list that turns it into a master of cloud orchestration. You just talk to one agent and it controls a fleet of fullyfledged Claude sessions that run 24/7. They share context, they share memory and they never shut off. It's called Claude projects and it's the ultimate hack if you're someone who is working on complicated applications and you need to do so outside of your local environment. So today I'm going to show you how to get access to this feature, how it actually works, and then we're going to run through a quick demo so you can start using it right away. Now

### [0:36] What Projects Does

**[0:36]** before I show you how to get access to Cloud Code projects, let me explain why you should even care about this at all. The big cell is that with Claude projects, Claude is now the project manager. You talk to one agent and it controls everything versus the normal setup. When we are normally inside of claude, when you're just sitting there on the desktop app or inside of the terminal, you are in charge of everything. And that means you are in charge of managing all of these different terminals and all of these different agents and you're also in charge of keeping them all on the same page. On top of that, unless you are running something either in the cloud or you have some sort of like Mac Mini setup that's always on, when you start shutting things down, whether that's your laptop or your computer, your machine just literally is not on, your work stops. Compare that to clawed projects, which runs in Anthropics Cloud and importantly also uses your usage.

**[1:30]** It's not a cloud situation where now we're paying API cost. This is pulling from your max plan. So we get pretty much all the advantages of the cloud with all the advantages of the subscription plan which hasn't always been the case when we talk about Enthropic in the cloud. So instead of you being in charge of managing all of these separate threads, guess who does it? Well, Claude does it. We just talk to one orchestrator and it then does said orchestration. On top of that, these are not sub agents. It's controlling full-blown Claude sessions that also share context and memory between each other and the orchestrator. And because it's in the cloud, it's always going to run no matter where we are, whether that's overnight. I can check in remotely from my phone. So, if you are someone who deals with complicated projects that you want access to 24/7, no matter where you are at, well, this Cloud project makes total sense. It makes it super easy to manage multiple agents. So, how do you get access? Well, right now, you need to submit an application on this page right here, and I will put a link to it in the description. It puts you on a wait list.

**[2:36]** Now, when this first came out a couple months ago and it was like very limited release, it was kind of hard to get off the wait list, but as of now, if you put your name in on this wait list, you're going to get access to it probably within 24 hours. I know it was less than 24 hours for me. And a couple weeks ago, they let everybody off the wait list. So, there's really no excuse not to get this up and running on your Claude. Now, once you get access, it will populate inside of your desktop app over here on the left, and it says projects beta. Remember, we used to have projects back in the day, especially with the chat app, where those were essentially just like folders and you'd have conversations that were all about some specific subject. This is much different than that. Like I said, this is running in the cloud. This is all about multi-agent orchestration. So, before we jump into the next part, a quick word from today's sponsor, me. I just released an updated cloud code masterass, and it is the number one way to go from zero to AI dev, no matter your technical background. So, it doesn't matter where you are starting from your technical journey. It could be literally zero. I will bring you up to speed on the most powerful AI tools in the game today. I update this every single week. So, if you want to get your hands on this, you can find it inside of Chase AI Plus. I will put a link in the

### [3:42] When To Use It

**[3:42]** pin comment. So, if Cloud Code Projects is all about multi-agent orchestration in the cloud, when should we actually use this and when shouldn't we use this? Well, starting with the don'ts, if we're just talking about quick tasks that you can just knock out in a single chat session, then obviously no. We don't need to use cloud code projects for this. We also need to be wary if we're talking about work that needs to be done on our machine. If it's manipulating files and folders that quite literally live on our computer, it's not something that can be in the cloud. It's not something that can be in a GitHub repo, then we aren't going to want to use cloud code projects because this is all again operating inside of the cloud. Ideally, it's connected to some sort of GitHub repo. Now caveat I will say you do have the ability to spawn sessions you know that your orchestrator controls that do live on your local machine but that isn't what it's really built for.

**[4:29]** Also this isn't something that's on team or enterprise yet. So when we talk about you know team projects this isn't what it's really built for either. So what should we use it for? Well we want to use it if we have some sort of project or an area that we're going to continue to feed. If it's a complicated build that we can split into different parts. Think of all these sub sessions controlled by the orchestrator being in charge of certain sections of a task. And Boris Churnney, the guy who actually created Cloud Code, pretty much said he stopped managing sessions inside of his Cloud Code desktop app and really just uses projects as like this backlog, this dumping ground of any ideas or tasks that come into his head. He dumps it into projects because remember projects and all of the subsessions beneath it that the orchestrator controls all share memory, all share context. So if it's complicated, it's long running, and is it something that can work best in a cloud environment, we're going to want to use projects. Otherwise, we probably don't need it. So just keep that in mind. And lastly, before we jump into the demo and we actually see projects in action, what is really the difference between projects and sub aents? We keep talking about we have these sub sessions with context and memory. How is that any different than just one session with sub aents being spawned? Well, a lot of it has to do with persistence. When we spawn some sort of sub agent in a normal cloud code session, it's going to do whatever it's been tasked to do. It's going to create a summary of all the work it's done. It's going to send it back to that main session you're working in, and it's just going to continue to fill up the context of that one session.

**[5:57]** Versus in a project, that single session, that orchestrator up top that we're talking to, these quote unquote sub aents it's creating. And they're not really sub agents. They're full sessions because they have their own context window. Furthermore, they're persistent. They'll own their own pull requests. And because these workers are persistent and they maintain context throughout, we can also message them as much as we want. I can actually go in there and talk to worker one or worker two as if I'm talking to the primary orchestrator. So, there's a lot of things listed here in terms of the differences. The biggest ones you need to remember is in terms of who is managing it. Normally you do all the management in terms of projects. Claude is managing it all and dealing out the work accordingly. Secondly, persistence projects. Those sub workers are never shutting off. And so ultimately sessions with the sub aents is best when we're just doing one task at a time. And these projects are great if we have a stream of work we just

### [6:51] Demo + Setup

**[6:51]** don't want to babysit. So now let's hop into the demo. If you go into your cloud desktop on the top left, you will see something that says projects beta. We simply click on this and you will see this page pop up. Now, if you have projects that have been sitting in Claude for the past several years, potentially back from like just the chat days and they were just projects were basically just folders, it's going to ask you, hey, do you want to delete these or you want to archive all these? You can just archive all of them till you get to, you know, essentially a clean slate. So, we are going to click new projects. Then, we're going to give it a name. We will call this projects demo. You have the ability to give it a goal. So some sort of overarching thing it's trying to achieve. In this case, we will leave it blank. And I also have the ability to give it context. So if I already had, you know, certain documentation or files and folders that I want this project to already sort of bring on board, I can do that here as well. Then I'm just going to hit create project.

**[7:46]** And we're going to get a page that looks like this. Now the first thing I want you to do is come up here to the top where we have this little gear icon. And we're going to take a look at our project settings. So again, we can edit the goal at any point in time. We also have the models that we can choose from. And the big things we want to pay attention to are the coordinator model and the thread model. So the threads are essentially the workers that the coordinator spins up. In reality, threads themselves can have multiple workers, but just think of it as like coordinator and then threads/workers underneath it. So, the coordinator model is going to by default go to Opus 5.5 on a low effort setting. You might be like, "Hey, do I really want it on a low effort setting? What do I want to put it on at least like medium or high if it's doing all these things?" Well, in reality, it's not really the one doing the work. It's just the one coordinating and diving out the work. So, not really an issue to keep it on low. If for whatever reason you feel like it's not doing a good job of coordinating, you could always bump this up to medium or high. But if usage starts to become a problem because usage is something that projects can burn up pretty quickly because we could be you know similar to dynamic workflows you could have 5 10 15 sessions or threads or workers all doing stuff at the same time 24/7. So we want to keep an eye on that thread model opus 5.5 on medium should be totally fine for you. But if you even want to switch this to something like sauna that works too.

**[9:11]** We also have the ability to have it auto continue when usage limits resets. So let's say you burn through all 100%. When the week rolls over and we get a fresh reset, well, it's just going to pick up from where it left off. We also can pause the project, restart Claude or archive the project from here, too. Then we have memory. So the big one we want to pay attention to is project instructions. This is similar to agents or claw.md. This can be very powerful because they're pretty much going to read this in every single thread. But, you know, I wouldn't blow this. Like, similar to how we approach agents.mmd these days, less is more. If there's something where you're like, I really want it to always do the specific thing in a specific way every single thread, then maybe this makes sense to fill it up here. Otherwise, if you're not sure, just leave it blank. It also has auto memory, and that works pretty much the same way as automemory inside of clawed code. as you tell it to do things throughout your sessions, it has its own little scratch pad where if it thinks it's something it should remember, it will just automatically add essentially a little sticky note to its memory. Next, we have the environment tab. So, the first thing we need to do is designate a project repository. All these workers, all these sessions are going to be in the cloud and they need a GitHub repo where they can communicate and send their PRs. So, to do that, we just need to select a particular GitHub repo. Mine is going to be AI Creator Radar because I'm creating this thing that goes out on the web, goes out on Twitter, sees trending AI news, and then turns that into a dashboard which says, "Hey, here's things that haven't been talked about on YouTube. Here's how we can turn them into short form. Here's how we turn to

**[10:39]** carousels." That type of thing. So, you can either create this manually inside of GitHub or just hop into a normal cloud code session and say, "Can you create a GitHub repository for me that I'm going to use inside my project?" Next, we have the cloud environment. So if you just keep this as is where it says select the cloud environment, it's just going to use the default anthropic cloud environment, you also have the ability to add a cloud environment. So I could give it some sort of name. I can define the network access everywhere from none to full. And then I can start uploading secrets and environmental variables. So if I am doing something that requires, you know, API keys and secrets, I'm going to need to add a cloud environment for it to be able to work there. Now, we are going to leave it on select a cloud environment. And you will see later it's going to prompt us to essentially change our cloud environment to add some keys. And I'll walk you through that. Next, we have some local settings. Let cloud use your device. Yes. Pre-approved folders. If you have a session or a worker that is going to need to work on your local computer or access access it, that's something we can do. By default, it's always going to be in the cloud, but it can actually, you know, go on your machine. And so to do that, you just need to select this to yes. And then we want to give it some sort of folder it can work in. In this case, I set my radar-local folder. Then we have a usage tab followed by debug access. So let's say you have two projects, project A, project B totally doing different things. You can let project B take a look at project A and vice versa to help debug because perhaps you're running into problems where maybe project A can't debug on its own. Maybe we have like some issue with the memory. Like

**[12:13]** something is poisoning its context. Well, how about we get a fresh set of bias to take a look at what's going on. We can do that by simply giving it access via the debug access panel. Probably won't use this a lot, but know it's there. So, let's go ahead and give it our prompt. So, we're saying we're creating the AI creator radar. We've given it kind of an end state we're looking for. Again, I want it to be able to scrape things off of X, and then I want it to be able to take a look at YouTube, see what's working, see what hasn't been touched on, see where there's some sort of gaps, and I wanted to do it on a dashboard where I can just see it all in one place. So, let's go ahead and put it to work. and see what happens. And as this is working, you'll kind of see this has begun to populate over here are the threads. So coordinator main page right here, I can talk to everything and like do everything from this one window. But if I want to kind of like click inside of here and see what's going on at individual thread or even worker level, I have that ability too. So after letting it run for about 25 minutes, here is where we are at. First of all, after we gave it the prompt, it split into five parallel threads, and each thread was given some piece of the pie that it needed to execute on. We had something working on the dashboard and hosting, one working on the Xcanner, one on YouTube coverage, one on content packs, and one on cloud code news. If we go over here to the right on the threads, we can see I have two that are now ready for review. I have three that have some sort of blocker that require me to come in and either make some sort of decision or give it some more information. And then we also have the idle thread. Now at any point in time I can click on any of these threads and

**[13:48]** see what this particular worker is doing at a more granular level. I can click here and see the blockers. And so it's really easy me to go really easy for me to go into each individual session and actually talk to it because as you see when I click into here I do have an ability to steer that thread. I also can view these threads from the orchestrator panel right here in the middle. So I just click view thread and it pops up. Also I can just handle everything through here through the orchestrator. So instead of going into each individual thread like I would with sessions, you know, when I'm sort of just normally operating inside of cloud code, I can just talk to the single agent and it will handle it all for me. And the whole time they're operating inside of my GitHub repo, which we see right here. If I hop into the pull requests, we can see what all these individual threads, individual workers are actually sending.

**[14:34]** So let's handle some of these blockers. The first one is related to the cloud environment. Remember I mentioned how earlier if we need API keys as part of our project, we need to edit the actual environment. Well, let's go ahead and do that. So go up to project settings, go to environments, and we're going to add a cloud environment. Going to call this demo environment. For network access, we'll throw it to full. And now we need to add a network secret. And so I put in all the correct information and then I just hit add. And now it's working in a cloud environment that has my particular secret. So then I can say, hey, I just updated the cloud environment with the YouTube key as a network secret. And the coordinator is going to send that information to that particular thread. And now I'm just going to repeat this process for the rest of the blockers. And that's kind of how you would run this. All right. So we got rid of the blockers and right now it's finishing up. One thing that's kind of cool is like I said, you can tell certain sessions that you want it to be local. We did that with the session that had to do with scanning X because X was actually logged into my account on my cookies. So it used the inapp browser inside of cloud code desktop to do that.

**[15:41]** And so it actually built a local scheduled routine. So you can see on theuler it created this routine. It's inside of that folder that we designated earlier is like the local folder it can play around with. And you can see kind of the instructions it gave it. And so here's a look at the dashboard it created. It shows me which stories are trending on Twitter but really have no coverage in the YouTube space. For each of these, like, hey, Claude writes about 90% of Claude Code's code. It shows me potential content pack, what the video could look like, what a short could look like, what a carousel could look like, as well as what an X post could also look like. It also gives me kind of a breakdown of what's going on with X. So like the top story right now is DeepSeek version 4.1 Flash and GLM 5.3 Flash go free in open code. So it shows me like the posts per hour, the views. I can actually click on the posts themselves and it will bring it up. And it also gives me more stats about my channel as well as like some Clawude Code specific news. Lastly, at the bottom, I can see kind of a refresh log. And so overall, this is pretty solid work considering it was kind of a oneshot and this is just the first pass that Claude Code Projects has done on this. And the real cell for projects at this point isn't the singular thing it created. It's the fact that this is now something that is living in the cloud. I can access it at any time and I have all of these threads that still are sharing and maintaining context. So I can work on this whenever I want. I can constantly feed it new information. it can run even when my computer is shut down and I can continue to add more and more complexity to it all through a single orchestrator. So while I do have the ability to you know click on individual threads and handle

**[17:32]** it one at a time I can just talk to one agent from any place and have it control everything. The last thing I'll mention and I will also link this in the description is the documentation on cloud code projects. It is very extensive. So, if there's anything you feel like I didn't cover enough or you want to go deeper and I highly suggest you take a look at the documentation, but besides that, that's all I have for you today. Highly suggest if nothing else, you hop on that weight list because you will get access very, very quick. I think this is a really cool feature inside of Cloud Code. Kind of niche, really depends on the type of projects you're working on. And if you're someone who really does need that 247 access, if that's not you, no problem. But if it is, it's great because you know in the past when we've had these sort of anthropic cloud options, they've always been draining from the API. Now it just comes straight from usage, which for many of us, I feel like we have a lot of usage remaining.

**[18:26]** Like Opus 5.5 has been pretty token efficient, especially compared to something like Fable 5.1. So having the option to go into the cloud, stay on usage, and always have complicated projects running is a great value ad. So as always, let me know what you thought. Make sure to check out Chase AI Plus if you want to get your hands on my cloud code masterass.
