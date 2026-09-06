[00:03] I got to ask you about uh how is your
[00:05] setup uh
[00:07] programming setup changed? So,
[00:10] keyboard, voice,
[00:12] what's the IDE?
[00:14] >> It's crazy to think about now, but yeah,
[00:15] I used TextMate for almost 20 years. I
[00:19] used TextMate starting in
[00:21] 2005, I think. I helped get the first
[00:24] version out, and then I just wasn't
[00:26] interested. I wasn't in the market for
[00:28] an alternative. And it wasn't until
[00:31] the switch to Linux that I was forced
[00:34] out of my habitat. And now, with the
[00:38] switch to
[00:40] What are we calling it? Agentic
[00:42] engineering? I [ __ ] hate that term.
[00:44] We got to come up with something that
[00:45] sounds as plain as programming, but
[00:48] encapsulates the fact that it's with
[00:50] agents. But,
[00:51] >> I still think it should be called
[00:52] programming.
[00:53] >> let's just call it programming.
[00:54] >> Yeah.
[00:54] >> The programming with agents requires a
[00:56] different tool set. It really does. And
[00:59] the main change here is that
[01:04] you're going from single-thread
[01:06] programming in your head to parallel
[01:08] processing.
[01:10] When I was writing code, chiseling it by
[01:12] hand in TextMate or even Neovim
[01:15] uh not that long ago, I would just focus
[01:18] on one problem at the time. And I would
[01:20] methodically work my way through it, and
[01:21] that was actually the portal to flow.
[01:23] The portal to flow was
[01:25] deep
[01:26] immersion into a single problem, see it
[01:29] through to the end.
[01:30] >> Mhm.
[01:31] >> That's not how it works with agents. In
[01:34] part, because the agents are at once
[01:37] both too fast and too slow. They don't
[01:39] give you an immediate
[01:42] reply on something that you asked them
[01:45] to do that's the same as typing on a
[01:48] keyboard. So, you have to let the agent
[01:50] cook
[01:51] >> Mhm.
[01:51] >> for a bit.
[01:52] And therefore, you realize, well,
[01:55] if I just sit around waiting for them,
[01:57] first of all, that doesn't feel
[01:59] productive. Even if the agent, just one
[02:01] of them can be highly productive, it
[02:03] does not feel productive, it doesn't
[02:04] feel good. It feels actually like you're
[02:05] a little bit useless.
[02:06] >> Mhm.
[02:07] >> And maybe I had a moment when the first
[02:10] agentic moment was there and we I was
[02:12] running mostly one agent at a time where
[02:14] I felt like
[02:15] I don't know about this.
[02:16] But you can solve a lot of hard problems
[02:19] by
[02:20] just throwing more resources at it. This
[02:22] is the whole scaling law of AI itself,
[02:25] right? That if you paralyze these things
[02:29] and you're not running one agent, but
[02:30] you're running a handful,
[02:32] you can
[02:34] feel like you're in a flow state because
[02:36] you're constantly doing
[02:39] programming work in the sense that
[02:40] you're making decisions and you're
[02:42] helping either unblock an agent because
[02:44] it has a
[02:45] question about which direction to take
[02:47] or you're ready for a new task. And to
[02:49] do that, you need a different setup. I
[02:51] started first doing it in tmux and just
[02:54] having separate panes
[02:56] and having separate splits. Basically, a
[02:58] terminal with tabs is a good way to
[03:00] think about you open a bunch of tabs. I
[03:02] think most humans know exactly how that
[03:04] works. They don't work in just one tab.
[03:06] >> So, uh still sticking to the terminal
[03:08] CLI.
[03:09] >> Absolutely.
[03:10] >> So, you're not using cloud code app or
[03:12] the codex app or the
[03:13] >> I love the fact that this agent
[03:16] revolution was kicked off in the
[03:18] terminal because I was already a huge
[03:19] fan of TUI's, terminal user interfaces,
[03:23] and the terminal in general. That feels
[03:25] like a
[03:26] a really [clears throat] nice place to
[03:28] be. It's a beautiful place to be. The
[03:29] modern terminal is just a good looking
[03:32] place to work. So,
[03:34] >> [laughter]
[03:34] >> I like that.
[03:35] And um
[03:37] and then
[03:38] this fact of having multiple agents,
[03:41] especially once it's not just multiple
[03:43] agents running on your own machine, but
[03:45] you start running multiple machines.
[03:47] Now, tmux alone is not enough to keep
[03:51] track of it. And that's why as of late
[03:54] I've switched to this thing called
[03:55] Herder.
[03:57] And Herder's essentially team mugs plus
[04:00] agent notifications. So, whenever your
[04:02] agent is done or needs something for
[04:04] you, it goes ding.
[04:06] A little a little bell telling you it's
[04:09] ready for its human uh
[04:11] Is it Is it master or servant? I'm not
[04:13] quite sure always.
[04:14] >> [laughter]
[04:15] >> But, it is ready for a decision. And it
[04:18] also keeps track of these Is it is it
[04:19] working or not? So, I have this Herder
[04:21] set up. I have multiple Herder setups
[04:24] actually running on individual machines.
[04:26] I went on this crazy
[04:28] phase just about a month ago realizing
[04:31] that
[04:32] doing this work on a single machine is
[04:35] not fast enough. It's like I've
[04:36] discovered multi-core programming, but I
[04:38] only have two cores. I'm like, what if I
[04:40] had 16 cores? What if I had 32 cores?
[04:42] What if I had 64 cores? So, I instantly
[04:45] went out and I bought these amazing
[04:47] KVMs called gli.net
[04:50] comets.
[04:51] >> Mhm.
[04:52] >> And what they do is it's this little
[04:53] box. You plug in HDMI, you plug in
[04:57] USB, and connect it to the computer.
[04:59] It's like a KVM. So, KVM is a a remote
[05:02] way of controlling computer. But, what's
[05:04] special about this is just how easy it
[05:06] was. You connect this thing in, you go
[05:08] to a webpage, log in once at one
[05:11] password. Now, this thing can hop on
[05:13] your
[05:14] Telnet.
[05:15] >> Mhm.
[05:16] >> This has been the other revolution of
[05:18] the last year for me. It's discovering
[05:22] these WireGuard networks.
[05:24] Tailscale
[05:26] is essentially turning all the computers
[05:29] you have into a local network wherever
[05:31] you are.
[05:32] >> Mhm.
[05:32] >> Like right now on my phone, I have
[05:34] direct access to all the computers in my
[05:37] Malibu office. I also have access to all
[05:40] my computers in my Copenhagen office.
[05:42] And I can treat them as though I sat
[05:44] right next to them
[05:45] without having to punch holes in a
[05:47] firewall or set up complicated VPNs and
[05:51] what this does is it just decreases the
[05:53] friction it takes to get new compute
[05:56] online. So,
[05:58] as soon as I discovered this, I looked
[06:00] in my closet and I realized I had a
[06:02] bunch of mini PCs from prior
[06:04] experiments. I just said, "What if I
[06:06] just connected all of them?"
[06:07] And I just connected four of the
[06:09] computers in a closet. They all had
[06:11] their little comment and suddenly I
[06:14] could run agents on more computers at
[06:16] the same time and I could control them
[06:18] all with Herder.
[06:20] And it did get to a point where I maxed
[06:22] out my own processing power. That I
[06:26] think at about
[06:28] What do I want to put it? About four to
[06:30] five machines running
[06:33] I don't know, three agents. I have about
[06:35] 16 threads. That's what I can run. And
[06:37] the faster the agents run, of course,
[06:39] the fewer threads I can run. But at the
[06:41] current pace I can run about 16 threads.
[06:43] >> [laughter]
[06:43] >> At at full acceleration.
[06:46] And
[06:47] that's part of why I've gone from just
[06:50] being excited about the agent moment to
[06:52] being delirious.
[06:54] Because
[06:55] I think I should say some of it is a
[06:57] little
[06:58] assaulting and again,
[07:00] we're on we're on the dial-up bandwidth
[07:02] wise with our computer. I mean,
[07:05] it's actually hilarious. So, you think
[07:06] of I'm sitting here a year ago, right?
[07:08] I'm chiseling my code. I'm writing my
[07:10] lines. And over the course of like an
[07:13] hour, I will have written one beautiful
[07:16] controller, one beautiful model. Like
[07:18] that's one file.
[07:19] And I really worked on it, right? So,
[07:21] maybe there's 60 lines left. So, maybe
[07:23] my bandwidth at this moment is like
[07:27] 30 lines an hour. I think that's even
[07:28] high. Maybe it's 20 lines an hour.
[07:31] Now I'm running 16 threads.
[07:33] I'm producing at sometimes hundreds of
[07:36] lines of hour or or hundreds of lines of
[07:38] code per hour. Now,
[07:41] let me pause myself there for a hot
[07:42] moment. I hate that metric, right? Like
[07:45] lines of code is a stupid metric in
[07:47] general to measure these things, and I
[07:49] think it's right from someone in the
[07:51] programming community to ridicule the AI
[07:54] psychosis when everyone talks about the
[07:56] number of lines of code they're writing,
[07:58] and then you ask them, "What did you
[07:59] build?" And then like, "Well, I didn't
[08:02] And then no good answer comes out,
[08:03] right? It's just a nice shorthand
[08:05] >> It is a nice shorthand. It is a
[08:07] representation and encapsulation of
[08:09] >> how much output that's coming out. Now,
[08:11] whether that output is good or bad
[08:14] is not a referendum on that. But, I was
[08:15] producing and producing so much more
[08:17] now, right? And therefore, I'm able to
[08:20] keep all these threads going. So,
[08:22] that's the setup. It's still Neovim, but
[08:24] at this point
[08:26] we're not writing a lot of code. So, I'm
[08:27] using Neovim as a project browser, and
[08:30] then as a way to kick off lazy get to
[08:33] see the change log for what's there. And
[08:36] even that, I'd say
[08:39] if GitHub was a little faster at showing
[08:41] you your pull request, the web is
[08:43] probably actually a nicer place to do
[08:44] that.
[08:45] I don't know. There's also this other
[08:46] tool I've been playing with a bit called
[08:48] hunk, which just produces diffs in a
[08:52] really nice way. So, you could look at
[08:53] that, too. But, I find that when I look
[08:55] at hunk, I only see the change set. And
[08:57] when I'm reviewing output from an agent,
[09:00] I often want to see the surrounding
[09:01] context. Oh, yeah, so it changed this
[09:03] file, but actually, what do we have in
[09:04] this other file that wasn't touched, but
[09:06] maybe should have been touched? So,
[09:08] that's why I still like Neovim as a way
[09:10] of doing it.
[09:11] Um, but it's all happening, by the way,
[09:13] of course, in Emacs. So, it's all
[09:15] happening on Linux. And this was the
[09:17] other major breakthrough with agents.
[09:20] Agents love the Unix philosophy. It
[09:23] loves individual tools that it can
[09:26] invoke through the command line. And
[09:28] there is no operating system on Earth
[09:32] of the majors. I'm counting three here:
[09:34] Mac, Windows, Linux, that works as well
[09:37] with that
[09:39] mechanism as Linux. Everything is in
[09:42] Linux it's either a config file or a CLI
[09:45] tool.
[09:46] Now, that was its main drawback 5
[09:49] minutes ago. This was the reason people
[09:51] didn't like Linux. It's like it's all
[09:53] config files and CLI tools.
[09:55] >> Mhm.
[09:56] >> What great irony
[09:58] that the universe has played it upon us
[10:00] that now the drawbacks of Linux 5
[10:03] minutes ago are now it's major selling
[10:05] points.
[10:07] This is one of the things I thought I
[10:08] was stuck for a weekend with a Mac
[10:13] uh 4 months ago.
[10:15] I thought I had a computer the place I
[10:16] was going
[10:17] that was a Linux machine so I didn't
[10:19] bring my laptop and I
[10:21] I found out when I arrived I only had a
[10:23] Mac Mini.
[10:24] So,
[10:25] I was going to make the best of a bad
[10:26] situation here and uh set up my Mac in
[10:30] some of the ways I've been thinking
[10:32] about with
[10:33] um
[10:34] with Linux. And you can actually do a
[10:36] lot now. Homebrew has gotten really
[10:38] quite good. Homebrew is the missing
[10:40] package manager for the Mac and no one
[10:43] has done more to move the Mac forward in
[10:45] terms of ease of setup. But,
[10:48] still something as simple as Raycast, I
[10:50] don't know if you've used that. That's
[10:51] the
[10:51] >> Yep.
[10:53] >> There's no config file that you can just
[10:55] access. You have to go into the GUI,
[10:58] export a file, then take that file, I
[11:01] don't know, in your freaking backpack on
[11:03] a USB key.
[11:04] >> Mhm.
[11:05] >> And then you can import it somewhere
[11:06] else. You cannot automate the entire
[11:08] setup of your machine. You can't
[11:09] automate at all the configuration of
[11:13] Mac's default key bindings. That has to
[11:16] be a manual process where you're
[11:18] clicking with a mouse like a caveman
[11:21] to set up your machine.
[11:22] >> I mean, there's ways around it.
[11:24] >> Not good ones. I looked. I tried hard.
[11:27] >> So, here's here's my been my journey.
[11:29] Obviously, I'm a Linux person, but
[11:31] because of Adobe Premiere, Adobe
[11:33] products, I'm also a Windows person. So,
[11:34] often times I would use WSL, Windows
[11:37] Subsystem for Linux. So, Linux inside
[11:40] Windows, which is in the agentic era, is
[11:42] not a good kind of Linux cuz it's just
[11:45] >> It's a sandbox.
[11:46] >> It's a sandbox and you want the Linux to
[11:48] be unleashed to be able to do
[11:49] everything.
[11:50] >> Correct.
[11:50] >> And so, I have now woken up to things
[11:53] like Grey Cat and have
[11:55] you know, I'm a keyboard person. Where
[11:57] is the config file? Can I Can I
[12:00] Can I basically do everything where an
[12:02] agent can can set everything up for me
[12:05] and save the configuration so I can
[12:06] replicate across systems and everything
[12:08] is automated. And so, I had to ask a lot
[12:11] of those questions and a lot of them are
[12:12] missing.
[12:13] >> have good answers.
[12:14] >> But often times you could actually just
[12:16] build the app yourself.
[12:18] >> But they're a hacks.
[12:19] >> They're hacks.
[12:20] >> They're hacks. You don't have to live
[12:21] like this, Lex.
