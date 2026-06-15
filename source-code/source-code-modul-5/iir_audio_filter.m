[audio,Fs] = audioread('a.wav');

audio = mean(audio,2);

audio_rs = resample(audio,10000,Fs);

noise = 0.2*randn(size(audio_rs));

audio_noise = audio_rs + noise;

[b,a] = butter(4,0.45);

audio_out = filter(b,a,audio_noise);

sound(audio_out,10000);

audiowrite('audio_filtered.wav',audio_out,10000);
