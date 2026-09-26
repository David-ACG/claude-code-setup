# Transcript: My Mobile AI Coding Setup: Tailscale, Herdr & Moshi

- Video: https://www.youtube.com/watch?v=9-tOItWRaiw
- Channel: imran
- Published: 2026-08-06T12:10:17-07:00
- Duration: 6:17
- Language: en
- Words: 1311
- Fetched: 2026-09-26T19:40:18+00:00 via TranscriptAPI.com

## Chapters

- [0:00](https://www.youtube.com/watch?v=9-tOItWRaiw&t=0s) My terminal setup
- [0:14](https://www.youtube.com/watch?v=9-tOItWRaiw&t=14s) Organizing workspaces with Herdr
- [0:42](https://www.youtube.com/watch?v=9-tOItWRaiw&t=42s) Useful keyboard shortcuts
- [1:20](https://www.youtube.com/watch?v=9-tOItWRaiw&t=80s) Running AI agents
- [1:45](https://www.youtube.com/watch?v=9-tOItWRaiw&t=105s) Connecting from my phone
- [3:01](https://www.youtube.com/watch?v=9-tOItWRaiw&t=181s) How Tailscale connects everything
- [3:59](https://www.youtube.com/watch?v=9-tOItWRaiw&t=239s) Why I prefer this over traditional SSH
- [5:03](https://www.youtube.com/watch?v=9-tOItWRaiw&t=303s) Current limitations
- [5:27](https://www.youtube.com/watch?v=9-tOItWRaiw&t=327s) Moshi and on-device speech-to-text

## Transcript

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
