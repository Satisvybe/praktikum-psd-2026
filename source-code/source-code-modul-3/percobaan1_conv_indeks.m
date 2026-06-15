% Bagian Utama
x1 = [1, 2, 3];
n1 = -1:1;

x2 = [2, 4, 3, 5];
n2 = -2:1;

[x3, n3] = conv_m(x1, n1, x2, n2);

disp('Hasil konvolusi:');
disp(x3);

disp('Rentang waktu hasil:');
disp(n3);

function [y, n] = conv_m(x1, n1, x2, n2)
y = conv(x1, x2);
n_start = n1(1) + n2(1);
n_end = n1(end) + n2(end);
n = n_start:n_end;
end
