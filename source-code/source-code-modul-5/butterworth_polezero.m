N = 2;
wc = 0.4;

[b,a] = butter(N,wc);

figure;
zplane(b,a);
title('Pole-Zero Plot');
