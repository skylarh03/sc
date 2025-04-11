# Sharing is Caring Proposal

There's a game I'm working on right now where I'm making a semi-generative music system inside of FMOD. So for this project, I thought it might be cool to try and recreate what I currently have for this system in Supercollider, and try to see what I can do here that I can't really do in FMOD. Here's a [link to a video](https://github.com/skylarh03/sc/blob/main/Sharing%20is%20Caring/Proposal/Replicator%204-11%20Demo.mp4) showing the current state of the FMOD session.

The general idea is that there's an overall sense of progression indicated by new instruments coming in, then eventually what mode everything's playing in by adding an accidental on one of the notes in the scale. Towards the end, it'll return to the original mode with some sort of four-on-the-floor-esque drum groove that can randomly get offset by a 16th note, then leading to a fadeout.

In addition to user input determining overall progression, I'm thinking it'd be interesting to let user input also determine some of the timbral aspects of all the sounds by letting them manipulate the values of different effects. This'll probably end up involving both keyboard and mouse input, though if I get other ideas along the way I might incorporate those, too. 
 
