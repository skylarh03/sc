s.meter;
s.freqscope;
s.plotTree;
s.boot; // STEP 1: boot the server lmao
s.options.memSize = 2.pow(20); // most likely needs more memory than the standard
s.reboot;
Server.killAll;
Buffer.freeAll; // taken from birb, thanks steftones

/////// READ PLEASE ///////
// SynthDefs cover lines 12-233, run that block first. MORE DETAILED INSTRUCTIONS AT BOTTOM OF CODE

( // STEP 2: run this block of code
(
~baseArpNotes = [-4, -4, -3, -2, -2, 0, 0, 1, 1, 1, 2, 3, 3, 4, 5, 5, 7, 8, -10000, -10000]; // -10000 is just a note that acts like a rest since it can't be heard
SynthDef(\baseArp, { arg i_out, freq = 360, gate = 1, pan, amp=0;
    var out, eg, fc, osc, a, b, w;
    fc = LinExp.kr(LFNoise1.kr(Rand(0.25, 0.4)), -1, 1, 500, 2000);
    osc = Mix.fill(8, {LFSaw.ar(freq * [Rand(0.999, 1.0), Rand(0.999, 1.0)], 0, amp) }).distort * 0.2;
	osc = osc + LFTri.ar(freq, 0.5, 0.5, 0.1) + Formant.ar(freq, 3000, 1500, 0.25, -0.5);
    eg = EnvGen.kr(Env.asr(0.25, 0.5, 0.25), gate, doneAction: Done.freeSelf);
	out = eg * osc * LPF.ar(osc, MouseX.kr(100, 2500), MouseY.kr(0.5, 3)) * 0.25;
    #a, b = out;
	out = out * 0.5;
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
	out = eg * osc * LPF.ar(osc, MouseX.kr(100, 2500), MouseY.kr(0.5, 3)) * 0.25;
    #a, b = out;
	out = out * 0.25;
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

	Out.ar(0,snd*1.75);
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
	out = out * 0.5;
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
SynthDef(\bass2, { arg i_out, freq = 360, gate = 1, pan, amp=0;
    var out, eg, fc, osc, a, b, w;
    fc = LinExp.kr(LFNoise1.kr(Rand(0.25, 0.4)), -1, 1, 500, 2000);
    osc = Mix.fill(8, {LFTri.ar(freq * [Rand(0.999, 1.0), Rand(0.999, 1.0)], 0, amp) });
	osc = osc + Saw.ar(freq, 0.5, 0.25, 0) + Formant.ar(freq, 3000, 1500, 0.125, -0.5);
    eg = EnvGen.kr(Env.asr(0.1, 0.25, 0.01), gate, doneAction: Done.freeSelf);
	out = eg * osc * 0.5;
    #a, b = out;
	out = out * 0.5;
    Out.ar(0, Mix.ar(PanAz.ar(4, [a, b], [pan, pan]))) * 0.1;
}).add; // stolen from the patterns code along lol
);
Pbindef(
	\j,
	\instrument, \bass2,
	\scale, Scale.mixolydian,
	\degree, Pseq([-13, -6], inf),
	\dur, 0.6,
	\delta, 0.5
);
);

(
(
~sineNotes = [7, 8, 10, 11, 12, 13, 14, 15];
~sineNoteLengths = [1, 2, 2, 3, 4, 4, 4, 6, 6];
SynthDef(\sine, { arg i_out, freq = 360, gate = 1, pan, amp=0;
    var out, eg, osc, a, b, w;
    //fc = LinExp.kr(LFNoise1.kr(Rand(0.25, 0.4)), -1, 1, 500, 2000);
    osc = Mix.fill(8, {SinOsc.ar(freq * [Rand(1.0, 1.0), Rand(1.0, 1.0)], 0, amp) });
	osc = osc + SinOsc.ar(freq, 0.5, 0.25, 0);
    eg = EnvGen.kr(Env.asr(0.1, 4, 4), gate, doneAction: Done.freeSelf);
	out = eg * osc * 0.015625;
    #a, b = out;
	out = out * 0.5;
    Out.ar(0, Mix.ar(PanAz.ar(4, [a, b], [pan, pan]))) * 0.1;
}).add; // stolen from the patterns code along lol
);
Pbindef(
	\h,
	\instrument, \sine,
	\scale, Scale.mixolydian,
	\degree, Pxrand(~sineNotes, inf),
	\dur, Pxrand(~sineNoteLengths, inf),
	\pan, Pxrand([-0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75], inf)
);
Pbindef( // for live coding purposes
	\i,
	\instrument, \sine,
	\scale, Scale.mixolydian,
	\degree, Pxrand(~sineNotes, 1),
	\dur, Pxrand(~sineNoteLengths, 1),
	\pan, Pxrand([-0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75], inf)
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

	Out.ar(0,snd*2);
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
) // STEP 2: run this block of code

/////////////////////////////////////////////////////////////////

// routines establish direction of the piece. k Routine is what controls starting and stopping of Pbinds, r Routine is what iterates through the k Routine

// ================================================ //

( // STEP 3: run this block of code
( // intro order set here
k = Routine({
	Pbindef(\a).play.yield; //intro
	Pbindef(\b).play;
	Pbindef(\c).play.yield; // "ethereal" synth comes in
	Pbindef(\d).play.yield; // reverse piano comes in
})
);

// Bb lydian section arp layer, randomly adjusting arpPattern index

( // main routine
r = Routine({
	3.do { // because 2.do didn't work i guess
        k.next;
		32.yield; // iterates through intro
	};
	// moving on from intro

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
	1.5.yield;

	Pbindef( // changes bass notes to default
		\e,
		\degree, Pxrand(~bassNotes, inf),
	);
	30.5.yield;

	// begin setting up transition to changing the mode. change reverse piano to another new chord, align timings, change scale on the new downbeat for necessary Pbindefs, define downbeat bass note and new notes afterward
	Pbindef(\d).stop;
	1.yield;
	Pbindef( // change reverse piano to new chord
		\d,
		\bufnum, ~reversePiano_06
	);

	// remove B natural from \b and \c Pbinds so there isn't a m2 on the transition
	Pbindef(
		\b,
		\degree, Pxrand([-4, -3, -2, 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12], inf)
	);
	Pbindef(
		\c,
		\degree, Pxrand([-4, -3, -2, 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12], inf)
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
	"\nBb lydian introduced, run line 622 whenever you feel like it until the next console message pops up".postln;
	Pbindef(\e).play; // bass instrument with on low Bb for new section marking
	Pbindef(\d).play; // reverse piano with new chords

	// time to change the scale of everything else that's tonal lol
	Pbindef(
		\a,
		\scale, Scale.mixolydian,
		\degree, Pxrand([-4, -4, -3, -2, -2, -1, -1, -1, 0, 0, 1, 1, 1, 2, 3, 3, 4, 5, 5, 7, 7, 7, 8, 8, 8, 9, 10, 10, 11, 12, 12, 13, 13, 13, 14, 14], inf)
	);
	Pbindef(
		\g,
		\scale, Scale.mixolydian,
		\degree, Pxrand([-4, -4, -3, -2, -2, -1, -1, -1, 0, 0, 1, 1, 1, 2, 3, 3, 4, 5, 5, 7, 7, 7, 8, 8, 8, 9, 10, 10, 11, 12, 12, 13, 13, 13, 14, 14], inf)
	);
	Pbindef(
		\b,
		\scale, Scale.mixolydian,
		\degree, Pxrand(~etherealNotes, inf),
		\dur, Pxrand([0.25, 0.25, 0.125, 0.125, 0.125, 0.0625], inf),
		\amp, 0.125
	);
	Pbindef(
		\c,
		\scale, Scale.mixolydian,
		\degree, Pxrand(~etherealNotes, inf),
		\dur, Pxrand([0.25, 0.25, 0.125, 0.125, 0.125, 0.0625], inf),
		\amp, 0.125
	);

	2.yield;
	Pbindef( // change bass notes to fit new section
		\e,
		\degree, Pxrand([-15, -14, -13, -11, -10, -8], inf)
	);
	20.yield;
	Pbindef(\h).play; // last layer before we start changing this pretty significantly
	40.yield;

	// move to section that just plays D in various octaves.
	Pbindef(\d).stop; // stop reverse piano early
	10.yield;
	"\nstop running line 622 at this point, await further instructions".postln;
	Pbindef( // change base arps to just D
		\a,
		\degree, Prand([-6, 1, 8, 15], inf)
	);
	Pbindef(
		\g,
		\degree, Prand([-6, 1, 8, 15], inf)
	);
	Pbindef( // change ethereal notes to Dmadd9
		\b,
		\degree, Pxrand([-4, -2, 0, 1, 3, 5, 7, 8, 10, 12, 14, 15, 17], inf)
	);
	Pbindef(
		\c,
		\degree, Pxrand([-4, -2, 0, 1, 3, 5, 7, 8, 10, 12, 14, 15, 17], inf)
	);
	Pbindef( // change bass to just low D
		\e,
		\degree, -13
	);
	Pbindef( // change sine to just Ds and As
		\h,
		\degree, Pxrand([1, 5, 8, 12], inf)
	);
	12.yield;
	Pbindef(\e).stop;
	8.yield;
	Pbindef(\h).stop;
	2.yield; // slow, staggered fade out of ethereal notes
	Pbindef(
		\b,
		\amp, 0.095
	);
	Pbindef(
		\c,
		\amp, 0.095
	);
	2.yield;
	Pbindef(
		\b,
		\amp, 0.065
	);
	Pbindef(
		\c,
		\amp, 0.065
	);
	2.yield;
	Pbindef(
		\b,
		\amp, 0.035
	);
	Pbindef(
		\c,
		\amp, 0.035
	);
	2.yield;
	Pbindef(\b).stop;
	Pbindef(\c).stop;
	15.yield;

	// final section, introduces kick. build up like before, though no need to worry about reverse piano stuff anymore
	"\nkick entrance. lines 638 and 639 manipulate the spacing between the kick notes, with the \nfirst setting it to a spacing of three 16ths, and the second \nsetting it to its default of four 16ths. swap back and forth \nbetween the two as much as you want, just remember to \nuse command+enter!".postln;
	Pbindef(\f).play; // KICK TIME
	8.yield;
	Pbindef(\j).play; // new bass, shorter release this time so i can have a more moving line
	Pbindef( // change base arps to Ds and As
		\a,
		\degree, Prand([-6, -2, 1, 5, 8, 12, 15], inf)
	);
	Pbindef(
		\g,
		\degree, Prand([-6, -2, 1, 5, 8, 12, 15], inf)
	);
	20.yield;
	Pbindef(\b).play;
	Pbindef(\c).play;
	2.yield; // slow, staggered fade IN of ethereal notes
	Pbindef(
		\b,
		\amp, 0.065
	);
	Pbindef(
		\c,
		\amp, 0.065
	);
	2.yield;
	Pbindef(
		\b,
		\amp, 0.095
	);
	Pbindef(
		\c,
		\amp, 0.095
	);
	2.yield; // climax, bring back full note ranges for everything
	Pbindef(
		\a,
		\degree, Pxrand([-4, -4, -3, -2, -2, -1, -1, -1, 0, 0, 1, 1, 1, 2, 3, 3, 4, 5, 5, 7, 7, 7, 8, 8, 8, 9, 10, 10, 11, 12, 12, 13, 13, 13, 14, 14, 15, 15], inf)
	);
	Pbindef(
		\g,
		\degree, Pxrand([-4, -4, -3, -2, -2, -1, -1, -1, 0, 0, 1, 1, 1, 2, 3, 3, 4, 5, 5, 7, 7, 7, 8, 8, 8, 9, 10, 10, 11, 12, 12, 13, 13, 13, 14, 14, 15, 15], inf)
	);
	Pbindef(
		\b,
		\degree, Pxrand(~etherealNotes, inf),
		\amp, 0.125
	);
	Pbindef(
		\c,
		\degree, Pxrand(~etherealNotes, inf),
		\amp, 0.125
	);
	60.yield;
	"\nset kick to four 16th-note spacing, leave it alone now".postln;
	8.yield;

	// set up \e to only play once
	Pbindef(
		\e,
		\degree, Pseq([-13], 1)
	);

	// ending time
	"\n kick stops, music fades out. just let it go to the end, you're chilling now".postln;
	// play longer bass synth on downbeat only
	Pbindef(\e).play;
	Pbindef(\j).stop; // stops bass2
	1.yield;
	Pbindef(\f).stop; // stops kick

	Pbindef( // give \a its initial notes back
		\a,
		\scale, Scale.ionian,
		\degree, Pxrand(~baseArpNotes, inf)
	);
	Pbindef( // give \g its initial notes back
		\g,
		\scale, Scale.ionian,
		\degree, Pxrand(~baseArpNotes, inf)
	);
	Pbindef( // slow, staggered fade OUT of ethereal notes
		\b,
		\amp, 0.095
	);
	Pbindef(
		\c,
		\amp, 0.095
	);

	5.yield;
	Pbindef(
		\b,
		\amp, 0.065
	);
	Pbindef(
		\c,
		\amp, 0.065
	);
	5.yield;
	Pbindef(
		\b,
		\amp, 0.035
	);
	Pbindef(
		\c,
		\amp, 0.035
	);
	5.yield;
	Pbindef(\b).stop;
	Pbindef(\c).stop;
	Pbindef(\g).stop; // stops secondary arp layer

	// start fading out initial arp layer
	Pbindef(
		\a,
		\amp, 0.9
	);
	3.yield;
	Pbindef(
		\a,
		\amp, 0.8
	);
	3.yield;
	Pbindef(
		\a,
		\amp, 0.7
	);
	3.yield;
	Pbindef(
		\a,
		\amp, 0.6
	);
	3.yield;
	Pbindef(
		\a,
		\amp, 0.5
	);
	3.yield;
	Pbindef(
		\a,
		\amp, 0.4
	);
	3.yield;
	Pbindef(
		\a,
		\amp, 0.3
	);
	3.yield;
	Pbindef(
		\a,
		\amp, 0.2
	);
	3.yield;
	Pbindef(
		\a,
		\amp, 0.1
	);
	3.yield;
	Pbindef(\a).stop; // the end of the piece
})
)
) // STEP 3: run this block of code

////////////////////////////////////////////////////

// PERFORMANCE HERE
// 1) if you haven't already, boot the server
// 2) again, if you haven't already, run lines 12-233 for all the SynthDefs and Pbindefs
// 3) run 241-596 to define Routines
// 4) run 607-612 to start the piece. there is MouseX and MouseY input for some filtering and dynamics throughout the piece
// 5) perform and enjoy! follow the post window for any live coding prompts

( // STEP 4: run this block of code AFTER defining SynthDefs, Pbindefs and Routines to start the entire piece. see instructions on line 217
s.volume_(-12); // just so we don't absolutely fucking destroy the speakers
t = TempoClock.new;
t.tempo_(1.096);
t.sched(0, r);
)
// after running the above, DON'T SCROLL ANYWHERE ELSE. follow instructions from the post window as they come up :)

r.stop;

/////////////////////////////////////////////////////

// live coding //

// first live coding section, will be prompted at Bb Lydian section marker. just run this line as often or as little as you want
Pbindef(\i).play;

/////////////////////

// live coding blocks for when the kick is playing
( // run this block for three 16th-note spacing on kick
Pbindef(
	\f,
	\delta, 0.75
);
Pbindef(
	\j,
	\degree, Pxrand([-13, -11, -10, -9, -8, -7, -6], inf),
	\dur, 0.75,
	\delta, 0.75
);
)
( // run this block for four 8th-note spacing on kick
Pbindef(
	\f,
	\delta, 1
);
Pbindef(
	\j,
	\degree, Pseq([-13, -6], inf),
	\dur, 0.6,
	\delta, 0.5
);
)