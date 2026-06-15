clear; clc;

analysis_time = 5;
filter_order = 5;
cutoff_freq = 6000;

[data_1, FS_1] = audioread('noisyVoice.wav');

data_1 = data_1(1:FS_1*analysis_time);
data_1 = data_1*(1/max(abs(data_1)));

fft_data_1 = fftshift(abs(fft(data_1)));

b = fir1(filter_order,2*cutoff_freq/FS_1,rectwin(filter_order+1));

[H,w] = freqz(b,1,FS_1*analysis_time);
db1 = 20*log10(abs(H));

rectwin_data_1 = filter(b,1,data_1);

audiowrite('rectwin_1.wav',rectwin_data_1,FS_1);
