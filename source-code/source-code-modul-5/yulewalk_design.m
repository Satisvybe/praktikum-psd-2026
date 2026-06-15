m = [1 1 1 1 1 0 0 0 0 0];
f = [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 1];

[b,a] = yulewalk(10,f,m);

[h,w] = freqz(b,a,256);

plot(f,m,w/pi,abs(h),'--','LineWidth',2);
legend('Ideal','Yulewalk Designed');
title('Comparison of Frequency Response Magnitudes');
xlabel('Normalized Frequency');
ylabel('Magnitude Response');
grid on;

figure;
zplane(b,a);
