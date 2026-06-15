b = fir1(filter_order,2*cutoff_freq/FS_1,...
hamming(filter_order+1));

[H,w] = freqz(b,1,FS_1*analysis_time);
db2 = 20*log10(abs(H));

hamming_data_1 = filter(b,1,data_1);

audiowrite('hamming_1.wav',hamming_data_1,FS_1);
