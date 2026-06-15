Fs = 2000;

fc = 100;
Wn = fc/(Fs/2);

[b,a] = butter(2,Wn,'low');

freqz(b,a,1024,Fs);
title('Butterworth IIR Order 2');
