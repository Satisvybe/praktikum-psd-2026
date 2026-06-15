clear all;
N = 2;
wc = 0.4;

[b,a] = butter(N,wc);

[H,W] = freqz(b,a,256);

figure(1);
plot(W/pi,abs(H),'b','LineWidth',2);
grid on;
title('IIR based Butter');
xlabel('Normalized Frequency');
ylabel('Magnitude Linear Scale');
axis([0 1 0 1.1]);
