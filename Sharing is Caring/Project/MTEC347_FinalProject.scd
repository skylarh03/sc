s.meter;
s.plotTree;
s.boot;
s.options.memSize = 2.pow(20); // most likely needs more memory than the standard
s.reboot;
Server.killAll;
Buffer.freeAll; // taken from birb, thanks steftones

// SynthDefs cover lines 11-159, run that first. more detailed instructions on line 207

(
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

Pbindef(
	\a,
	\degree, Pxrand(~baseArpNotes, inf),
    \dur, 0.125,
    \instrument, \baseArp,
	\pan, Pxrand([-0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75], inf)
); // returns an EventStream

Pbindef( // duplicate copy of a to be layered
	\g,
	\degree, Pxrand([-4, -4, -3, -2, -2, 0, 0, 1, 1, 1, 2, 3, 3, 4, 5, 5, 7, 7, 8, 8, 8, 9, 10, 10, 11, 12, 12, -10000], inf),
	\dur, 0.125,
	\instrument, \baseArp,
	\pan, Pxrand([-0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75], inf)
);

~reversePiano_01=Buffer.read(s,thisProcess.nowExecutingPath.dirname++"/reversePiano_01.wav");
~reversePiano_02=Buffer.read(s,thisProcess.nowExecutingPath.dirname++"/reversePiano_02.wav");
~reversePiano_03=Buffer.read(s,thisProcess.nowExecutingPath.dirname++"/reversePiano_03.wav");
~reversePiano_04=Buffer.read(s,thisProcess.nowExecutingPath.dirname++"/reversePiano_04.wav");
~reversePiano_05=Buffer.read(s,thisProcess.nowExecutingPath.dirname++"/reversePiano_05.wav");
~reversePiano_06=Buffer.read(s,thisProcess.nowExecutingPath.dirname++"/reversePiano_06.wav");
~reversePiano_07=Buffer.read(s,thisProcess.nowExecutingPath.dirname++"/reversePiano_07.wav");
~reversePiano_08=Buffer.read(s,thisProcess.nowExecutingPath.dirname++"/reversePiano_08.wav");
~reversePiano_09=Buffer.read(s,thisProcess.nowExecutingPath.dirname++"/reversePiano_09.wav");
~reversePianoBufs = [~reversePiano_01, ~reversePiano_02, ~reversePiano_03, ~reversePiano_04];

~kick=Buffer.read(s,thisProcess.nowExecutingPath.dirname++"/kick.wav");
);

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
);

(
(
Pbindef(
	\b,
	\degree, Pxrand(~etherealNotes, inf),
	\dur, Pxrand(~etherealNoteLengths, inf),
	\instrument, \ethereal,
	\pan, Pxrand([-0.5, 0, 0.5], inf)
);
);

(
Pbindef(
	\c,
	\degree, Pxrand(~etherealNotes, inf),
	\dur, Pxrand(~etherealNoteLengths, inf),
	\instrument, \ethereal,
	\pan, Prand([-0.5, 0, 0.5], inf)
);
);
);


(
(
SynthDef(\reversePiano, {
	// buffers have an index, and the buffer index will be supplied later using

	|bufnum = 0|
	var snd;

	snd=PlayBuf.ar(
		numChannels:2,
		bufnum:bufnum,
		loop: 0,
		rate:BufRateScale.kr(bufnum) // BufRateScale will calculate the
	);                               // difference between the server sampling and the audio file

	Out.ar(0,snd*1.5);
}).add; // .add will add it to our server to be used anytime we want!
);
(
Pbindef(
	\d,
	\instrument, \reversePiano,
	\dur, Pxrand([4, 5, 6, 7, 8, 9, 10], inf),
	\bufnum, Pxrand([0, 1, 2, 3], inf)
);
);
);

(
(
~bassNotes = [-14, -13, -12, -11, -10, -9];
~bassNoteLengths = [2, 3, 4, 5, 6];
SynthDef(\bass, { arg i_out, freq = 360, gate = 1, pan, amp=0;
    var out, eg, fc, osc, a, b, w;
    fc = LinExp.kr(LFNoise1.kr(Rand(0.25, 0.4)), -1, 1, 500, 2000);
    osc = Mix.fill(8, {LFTri.ar(freq * [Rand(0.999, 1.0), Rand(0.999, 1.0)], 0, amp) });
	osc = osc + Saw.ar(freq, 0.5, 0.25, 0) + Formant.ar(freq, 3000, 1500, 0.125, -0.5);
    eg = EnvGen.kr(Env.asr(0.1, 0.3, 3.75), gate, doneAction: Done.freeSelf);
	out = eg * osc * 0.5;
    #a, b = out;
    Out.ar(0, Mix.ar(PanAz.ar(4, [a, b], [pan, pan]))) * 0.1;
}).add; // stolen from the patterns code along lol
);
Pbindef(
	\e,
	\instrument, \bass,
	\degree, Pxrand(~bassNotes, inf),
	\delta, Pxrand(~bassNoteLengths, inf)
);
);

(
(
SynthDef(\kick, {
	// buffers have an index, and the buffer index will be supplied later using

	|bufnum = 0|
	var snd;

	snd=PlayBuf.ar(
		numChannels:2,
		bufnum:~kick,
		loop: 0,
		rate:BufRateScale.kr(bufnum) // BufRateScale will calculate the
	);                               // difference between the server sampling and the audio file

	Out.ar(0,snd);
}).add; // .add will add it to our server to be used anytime we want!
);
(
Pbindef(
	\f,
	\instrument, \kick,
	\delta, 1
);
);
);
) // you can boot SynthDefs and Pbindefs here //////////////////////////////////////
//Pbindef(\f).play;

// live coding yippee
(
Pbindef(
	\f,
	\delta, 0.822
)
); // 3 8ths

(
Pbindef(
	\f,
	\delta, 1.096
)
); // 4 8ths

Pbindef(\a).play;
(
Pbindef(\b).play;
Pbindef(\c).play;
)
Pbindef(\d).play;
Pbindef(\e).play;
Pbindef(\f).play;

(
Pbindef(\a).stop;
Pbindef(\b).stop;
Pbindef(\c).stop;
Pbindef(\d).stop;
Pbindef(\e).stop;
Pbindef(\f).stop;
Pbindef(\g).stop;
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
// 1) if you haven't alread, boot the server
// 2) again, if you haven't already, run lines 11-159 for all the SynthDefs and Pbindefs
// 3) run 212-232 to define Routines
// 4) run 291-295 to start the piece. there is MouseX and MouseY input for some filtering and dynamics

(
( // performance order set here
k = Routine({
	Pbindef(\a).play.yield; //intro
	Pbindef(\b).play;
	Pbindef(\c).play.yield; // "ethereal" synth comes in
	Pbindef(\d).play.yield; // reverse piano comes in
})
);

( // main routine
r = Routine({
	3.do { // because 2.do didn't work i guess
        k.next;
		32.yield; // iterates through intro
	};
	//"we ball".postln;

	// set up bass coming in. first bass note must align with the peak of the reverse piano. reverse piano is a Dmadd9, so bass note is a D. after this point it randomizes again
	Pbindef(\d).stop; // stops previous reverse piano chords
	Pbindef( // sets up next reverse piano chord
		\d,
		\bufnum, ~reversePiano_05
	);
	Pbindef( // sets up bass entrance
		\e,
		\degree, -13
	);
	7.29776.yield; // gives time for the previous reverse piano chords to fade out.
	Pbindef(\d).play; // trigger transitioning reverse piano chord
	1.yield;
	Pbindef(\d).stop; // stop Synth from playing before it accidentally plays a second chord
	Pbindef( // resets reverse piano chords, include new Dmadd9
		\d,
		\bufnum, Pxrand([0, 1, 2, 3, 4], inf)
	);
	7.70224.yield; // lines 250 and 258 are really specific times to allow for things to line up rhythmically

	"bass comes in".postln;
	Pbindef(\e).play; // bass instrument
	Pbindef(\g).play; // layer another arp
	Pbindef(\d).play; // restarts reverse piano chords
	Pbindef( //expands Pbindef \a range, reduces frequency of rests
		\a,
		\degree, Pxrand([-4, -4, -3, -2, -2, 0, 0, 1, 1, 1, 2, 3, 3, 4, 5, 5, 7, 7, 8, 8, 8, 9, 10, 10, 11, 12, 12, -10000], inf)
	);
	0.5.yield;

	Pbindef( // changes bass notes to default
		\e,
		\degree, Pxrand(~bassNotes, inf),
	);
	31.5.yield;

	// begin setting up transition to changing the mode. change reverse piano to another new chord, align timings, change scale on the new downbeat for necessary Pbindefs, define downbeat bass note and new notes afterward
	Pbindef(\d).stop;
	1.yield;
	Pbindef( // change reverse piano to new chord
		\d,
		\bufnum, ~reversePiano_06
	);
	6.29776.yield; // give time for last reverse piano chords to play
	Pbindef(\d).play; // play new reverse piano chord
	1.yield;
	Pbindef(\d).stop; // prevent new chord from being played twice in a row
	Pbindef( // adjust set of possible reverse piano chords
		\d,
		\bufnum, Pxrand([~reversePiano_05, ~reversePiano_06, ~reversePiano_07, ~reversePiano_08, ~reversePiano_09], inf)
	);
	6.70224.yield;
	// adjust bass Pbindef for new section entrance
	Pbindef(
		\e,
		\scale, Scale.mixolydian,
		\degree, -15
	);
	Pbindef(\e).stop;
	1.yield;
	"Bb lydian time wahoo".postln;
	Pbindef(\e).play; // bass instrument with on low Bb for new section marking
	Pbindef(\d).play; // reverse piano with new chords
})
)
)

// live coding yippee
(
Pbindef( // three 8th-note spacing for kick
	\f,
	\delta, 0.75
)
)

(
Pbindef( // four 8th-note spacing for kick
	\f,
	\delta, 1
)
)

( // run this block of code AFTER defining SynthDefs, Pbindefs and Routines to start the entire piece. see instructions on line 217
t = TempoClock.new;
t.tempo_(1.096);
t.sched(0, r);
)

r.stop;

//////////////////////////////////////////////////////////

// testing (ignore)
(
Pbindef(\a).play;
Pbindef(\g).play;
)