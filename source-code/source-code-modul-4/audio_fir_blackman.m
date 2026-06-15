b = fir1(filter_order,2*cutoff_freq/FS_1,...
blackman(filter_order+1));

[H,w] = freqz(b,1,FS_1*analysis_time);
db4 = 20*log10(abs(H));

blackman_data_1 = filter(b,1,data_1);

audiowrite('blackman_1.wav',blackman_data_1,FS_1);
