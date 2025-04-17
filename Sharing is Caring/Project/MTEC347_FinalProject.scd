// sample for base arpeggiation
~baseArp=Buffer.read(s,thisProcess.nowExecutingPath.dirname++"/baseArp.wav");

~baseArp.play;

(
SynthDef("baseArp", {
	// buffers have an index, and the buffer index will be supplied later using

	|bufnum = 0|
	var snd;

	snd=PlayBuf.ar(
		numChannels:2,
		bufnum:bufnum,
		loop: 2,                     // loop forever
		rate:BufRateScale.kr(bufnum) // BufRateScale will calculate the
	);                               // difference between the server sampling and the audio file

	Out.ar(0,snd);
}).add; // .add will add it to our server to be used anytime we want!
)

~baseArpSynth=Synth("baseArp", [\bufnum,~baseArp]);
~baseArpSynth.free;