var snd_chan:SoundChannel = new SoundChannel(); //channel (controls all)

function play_sound(snd){
	snd_chan.stop();
	//here
	snd_chan = snd.play();
}

function play_sound_array(arr:Array){
	play_sound(arr[Math.ceil(Math.random()*arr.length)-1]);
}