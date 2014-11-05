(
//add server
s = Server.local;
s.boot;
s.makeWindow;

Routine({loop{

//inits
var num = [1,1,2,2,4,4,8,8,8];
var base_freq = 55;
var octv = [1,2,3];
var base_bpm = 108.00;
var maxVol = 0.8;
var randomiz = 8.0;

var mkHarm, envAttack, envSustain, envRelease;
var sig, noise, sleepTime;
var base_beat = 60/base_bpm;
sleepTime  = base_beat * [1,2,2,4,4].choose;
num = num.choose;
octv = octv.choose;

envAttack  = exprand(0.1,0.9);
envRelease = exprand(0.2,0.4);
envSustain = sleepTime - 0.1;

//fix octave
i=0;
while(
	{i<octv},
	{
		i=i+1;
		base_freq = base_freq * 2;
	}
);
i=0;

// dump;
"--------".postln;
base_freq.post;
" Hz * ".post;
num.postln;
"bpm: ".post;
(sleepTime).postln;

//make harmonics
mkHarm = {
	arg a;
	a = a * [1.0, 4.0/3.0, 5.0/3.0].choose;
  a = a * [1.0, 4.0/3.0, 5.0/3.0].choose;
  a.postln;
	//a = a * [1.0, 3.0/2.0, 4.0/3.0].choose;
	//a = a * [1.0, 3.0/2.0, 4.0/3.0].choose;
};

// set Envelope
e = Env.new(
	[0, 0.3, envAttack, 0],//
	[0.1, envSustain, 1],//
	[-5, 2, -5]//
);

//synthesis
(sig = {Mix.arFill(
  num,{
    var freq;
    freq = mkHarm.value(base_freq)+ randomiz.rand;
    [
      SinOsc.ar([freq,freq], pi.rand, maxVol/num) * EnvGen.kr(e, doneAction: 2),
      SinOsc.ar([freq,freq], pi.rand, maxVol/num) * EnvGen.kr(e, doneAction: 2)
    ];
  }
)};
);

sig.play;
sleepTime.yield;

}}).play;

)
