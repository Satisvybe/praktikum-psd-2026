% Generate noisyVoice.wav
fs = 44100;
t = 0:1/fs:5;
f = 440;
amplitude = 0.5;

tone = amplitude * sin(2*pi*f*t);

noise = 0.2 * randn(size(t));
noisyVoice = tone + noise;

noisyVoice = noisyVoice / max(abs(noisyVoice));

audiowrite('noisyVoice.wav', noisyVoice, fs);

figure;
subplot(3,1,1); plot(t,tone); title('Pure Tone');
subplot(3,1,2); plot(t,noise); title('Noise');
subplot(3,1,3); plot(t,noisyVoice); title('Noisy Signal');
