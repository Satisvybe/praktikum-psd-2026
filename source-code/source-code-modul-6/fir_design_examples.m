Fs = 2000;

tap = 50;
fc = 100;

b_lpf = fir1(tap,fc/(Fs/2),'low');
b_hpf = fir1(tap,fc/(Fs/2),'high');
b_bpf = fir1(tap,[100 800]/(Fs/2),'bandpass');

figure;
freqz(b_lpf,1,1024,Fs);
title('FIR Low Pass');

figure;
freqz(b_hpf,1,1024,Fs);
title('FIR High Pass');

figure;
freqz(b_bpf,1,1024,Fs);
title('FIR Band Pass');
