figure;
plot(w,db2,'r'); hold on;
plot(w,db3,'g');
plot(w,db4,'b');
legend('Hamming','Flattop','Blackman');
grid on;
title('Window Comparison');
