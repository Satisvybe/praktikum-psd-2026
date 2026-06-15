b = fir1(filter_order,2*cutoff_freq/FS_1,...
flattopwin(filter_order+1));

[H,w] = freqz(b,1,FS_1*analysis_time);
db3 = 20*log10(abs(H));

flattopwin_data_1 = filter(b,1,data_1);

audiowrite('flattop_1.wav',flattopwin_data_1,FS_1);
