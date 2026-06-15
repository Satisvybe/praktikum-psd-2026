fs = 2000;
t = 0:1/fs:1;

A1 = 1;
f1 = 200;

A2 = 0.25;
f2 = 600;

sinyal1 = A1*sin(2*pi*f1*t);
sinyal2 = A2*sin(2*pi*f2*t);

sinyal_out = sinyal1 + sinyal2;

[b,a] = butter(4,0.45);

hasil_filter = filter(b,a,sinyal_out);

figure;
subplot(2,1,1);
plot(t,sinyal_out);
title('Input Signal');

subplot(2,1,2);
plot(t,hasil_filter);
title('Filtered Signal');
