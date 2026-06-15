figure;
subplot(1,2,1);
plot(linspace(-FS_1/2,FS_1/2,analysis_time*FS_1),20*log10(fft_data_1));
title('Original Signal');

subplot(1,2,2);
plot(linspace(-FS_1/2,FS_1/2,analysis_time*FS_1),...
20*log10(fftshift(abs(fft(rectwin_data_1)))));
title('Rectangular Window');

figure;
plot(w,db1,'b');
title('Rectangular Response');
grid on;
