(
var baseArpNotes = [-4, -4, -3, -2, -2, 0, 0, 1, 1, 1, 2, 3, 3, 4, 5, 5, 7, 8, -10000, -10000, -10000]; // -10000 is just a note that acts like a rest since it can't be heard
SynthDef(\baseArp, { arg i_out, freq = 360, gate = 1, pan, amp=0.1;
    var out, eg, fc, osc, a, b, w;
    fc = LinExp.kr(LFNoise1.kr(Rand(0.25, 0.4)), -1, 1, 500, 2000);
    osc = Mix.fill(8, {LFSaw.ar(freq * [Rand(0.999, 1.0), Rand(0.999, 1.0)], 0, amp) }).distort * 0.2;
	osc = osc + LFTri.ar(freq, 0.5, 0.5, 0.1) + Formant.ar(freq, 3000, 1500, 0.25, -0.5);
    eg = EnvGen.kr(Env.asr(0.25, 0.5, 0.25), gate, doneAction: Done.freeSelf);
	out = eg * osc;
    #a, b = out;
    Out.ar(i_out, Mix.ar(PanAz.ar(4, [a, b], [pan, pan])));
}).add; // stolen from the patterns code along lol

a = Pbind(
	\degree, Pxrand(baseArpNotes, inf),
    \dur, 0.137,
    \instrument, \baseArp
).play; // returns an EventStream
)

( // an interactive session
a.stop
a.play
a.reset
a.mute; // keeps playing, but replaces notes with rests
a.unmute;
)

// routines establish direction of the piece. k Routine is what controls starting and stopping of Pbinds, r Routine is what iterates through the k Routine



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