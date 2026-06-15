fs = 2000;
t = 0:1/fs:1;

sinyal = sin(2*pi*200*t);

noise = 0.2*randn(size(t));

sinyal_noise = sinyal + noise;

[b,a] = butter(4,0.45);

output = filter(b,a,sinyal_noise);

figure;
subplot(3,1,1);
plot(t,sinyal);
title('Original Signal');

subplot(3,1,2);
plot(t,sinyal_noise);
title('Signal + Noise');

subplot(3,1,3);
plot(t,output);
title('Filtered Output');
