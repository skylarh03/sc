s.meter;
s.plotTree;
s.boot;
s.options.memSize = 2.pow(20); // most likely needs more memory than the standard
s.reboot;
Server.killAll;
Buffer.freeAll; // taken from birb, thanks steftones

// testing, actual performance logic is later

(
~baseArpNotes = [-4, -4, -3, -2, -2, 0, 0, 1, 1, 1, 2, 3, 3, 4, 5, 5, 7, 8, -10000, -10000]; // -10000 is just a note that acts like a rest since it can't be heard
SynthDef(\baseArp, { arg i_out, freq = 360, gate = 1, pan, amp=0;
    var out, eg, fc, osc, a, b, w;
    fc = LinExp.kr(LFNoise1.kr(Rand(0.25, 0.4)), -1, 1, 500, 2000);
    osc = Mix.fill(8, {LFSaw.ar(freq * [Rand(0.999, 1.0), Rand(0.999, 1.0)], 0, amp) }).distort * 0.2;
	osc = osc + LFTri.ar(freq, 0.5, 0.5, 0.1) + Formant.ar(freq, 3000, 1500, 0.25, -0.5);
    eg = EnvGen.kr(Env.asr(0.25, 0.5, 0.25), gate, doneAction: Done.freeSelf);
	out = eg * osc * LPF.ar(osc, MouseX.kr(100, 15000), MouseY.kr(0.5, 3)) * 0.25;
    #a, b = out;
    Out.ar(0, Mix.ar(PanAz.ar(4, [a, b], [pan, pan])));
}).add; // stolen from the patterns code along lol

a = Pbind(
	\degree, Pxrand(~baseArpNotes, inf),
    \dur, 0.137,
    \instrument, \baseArp,
	\pan, Pxrand([-0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75], inf)
).play; // returns an EventStream

~reversePiano_01=Buffer.read(s,thisProcess.nowExecutingPath.dirname++"/reversePiano_01.wav");
~reversePiano_02=Buffer.read(s,thisProcess.nowExecutingPath.dirname++"/reversePiano_02.wav");
~reversePiano_03=Buffer.read(s,thisProcess.nowExecutingPath.dirname++"/reversePiano_03.wav");
~reversePiano_04=Buffer.read(s,thisProcess.nowExecutingPath.dirname++"/reversePiano_04.wav");
~reversePianoBufs = [~reversePiano_01, ~reversePiano_02, ~reversePiano_03, ~reversePiano_04];
)

~reversePiano_01.play;

(
~etherealNotes = [-4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
~etherealNoteLengths = [2, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6, 6.5, 7];
SynthDef(\ethereal, { arg i_out, freq = 360, gate = 1, pan, amp=0;
    var out, eg, fc, osc, a, b, w;
    fc = LinExp.kr(LFNoise1.kr(Rand(0.25, 0.4)), -1, 1, 500, 2000);
    osc = Mix.fill(8, {SinOsc.ar(freq * [Rand(0.999, 1.0), Rand(0.999, 1.0)], 0, amp) });
	osc = osc + SinOsc.ar(freq, 0.5, 0.25, 0) + Formant.ar(freq, 3000, 1500, 0.125, -0.5);
    eg = EnvGen.kr(Env.asr(2.5, 0.3, 5), gate, doneAction: Done.freeSelf);
	out = eg * osc * LPF.ar(osc, MouseX.kr(100, 15000), MouseY.kr(0.5, 3)) * 0.25;
    #a, b = out;
	out = out * 0.5;
    Out.ar(0, Mix.ar(PanAz.ar(4, [a, b], [pan, pan]))) * 0.1;
}).add; // stolen from the patterns code along lol
)

(
(
b = Pbind(
	\degree, Pxrand(~etherealNotes, inf),
	\dur, Pxrand(~etherealNoteLengths, inf),
	\instrument, \ethereal,
	\pan, Pxrand([-0.5, 0, 0.5], inf)
).play;
);

(
c = Pbind(
	\degree, Pxrand(~etherealNotes, inf),
	\dur, Pxrand(~etherealNoteLengths, inf),
	\instrument, \ethereal,
	\pan, Pxrand([-0.5, 0, 0.5], inf)
).play;
)
)


(
SynthDef(\reversePiano, {
	// buffers have an index, and the buffer index will be supplied later using

	|bufnum = 0|
	var snd;

	snd=PlayBuf.ar(
		numChannels:2,
		bufnum:bufnum,
		loop: 0,                     // loop forever
		rate:BufRateScale.kr(bufnum) // BufRateScale will calculate the
	);                               // difference between the server sampling and the audio file

	Out.ar(0,snd*2);
}).add; // .add will add it to our server to be used anytime we want!
)
(
d = Pbind(
	\instrument, \reversePiano,
	\dur, Pxrand([4, 5, 6, 7, 8, 9, 10], inf),
	\bufnum, Pxrand([0, 1, 2, 3], inf)
).play;
)

(
a.stop;
b.stop;
c.stop;
d.stop;
)

( // an interactive session
a.stop
a.play
a.reset
a.mute; // keeps playing, but replaces notes with rests
a.unmute;
)

// routines establish direction of the piece. k Routine is what controls starting and stopping of Pbinds, r Routine is what iterates through the k Routine

// ================================================ //
// PERFORMANCE HERE

(
k = Routine.({
	a.play.yield;
	a.stop.yield;

})
)

(
r = Routine({
    loop {
        k.next;
		5.yield;
    }
});


TempoClock.default.sched(0, r); // run this to start the entire piece
)

r.stop;