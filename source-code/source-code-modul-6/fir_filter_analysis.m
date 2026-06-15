clear; clc; close all;

% --- AKUISISI DATA ---
nama_file = 'sinyal_gabungan.dat';
tabel_data = readmatrix(nama_file,'NumHeaderLines',2);
data_mentah = tabel_data(:,2);

Fs = 2000;
Ts = 1/Fs;
N = length(data_mentah);
t = (0:N-1)*Ts;

% --- PARAMETER FILTER FIR ---
tap = 50;
fc = 50;
jenis_filter = 'low';

Wn = fc/(Fs/2);
koefisien_fir = fir1(tap,Wn,jenis_filter);

sinyal_terfilter = filter(koefisien_fir,1,data_mentah);

% --- FFT ---
fft_asli = fft(data_mentah);
P1_asli = abs(fft_asli/N);
P1_asli = P1_asli(1:floor(N/2)+1);
P1_asli(2:end-1) = 2*P1_asli(2:end-1);

f = Fs*(0:floor(N/2))/N;

fft_filter = fft(sinyal_terfilter);
P1_filter = abs(fft_filter/N);
P1_filter = P1_filter(1:floor(N/2)+1);
P1_filter(2:end-1) = 2*P1_filter(2:end-1);

% --- VISUALISASI ---
figure('Name','Analisis Filter FIR');

subplot(2,2,1);
plot(t,data_mentah,'b');
title('Sinyal Asli');
grid on;

subplot(2,2,2);
plot(t,sinyal_terfilter,'r');
title('Sinyal Terfilter');
grid on;

subplot(2,2,3);
plot(f,P1_asli,'b');
title('Spektrum Sinyal Asli');
grid on;

subplot(2,2,4);
plot(f,P1_filter,'r');
title('Spektrum Sinyal Terfilter');
grid on;
