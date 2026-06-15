Fs = 2000;
t = 0:1/Fs:1;

x1 = 0.5*sin(2*pi*10*t);
x2 = 0.2*sin(2*pi*100*t);
x3 = 0.1*sin(2*pi*800*t);

x = x1 + x2 + x3;

[b,a] = butter(4,100/(Fs/2),'low');

y = filter(b,a,x);

figure;
subplot(2,1,1);
plot(t,x);
title('Input Signal');

subplot(2,1,2);
plot(t,y);
title('Filtered Signal');
