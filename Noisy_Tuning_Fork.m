clear all
close all
clc

load('myTuningForkRecording');

Signal=myRecording(8000:16000);

N=length(Signal);
f=[0:N/Fs:N];

v=0.01; %noise variance
noise=randn(N,1)*v;
Noisy_Signal=noise+Signal(1:end);

Signal_PSD=((abs(fft(Signal))).^2)/N;
Noisy_Signal_PSD=((abs(fft(Noisy_Signal))).^2)/N;

figure(1)
subplot(2,1,1);
plot(f, 20*log10(Signal_PSD));
xlim([0 8000]);
title('PSD of Natural Tuning Fork Recording Signal')

figure(1)
subplot(2,1,2);
plot(f, 20*log10(Noisy_Signal_PSD));
xlim([0 8000]);
title('PSD of Unfiltered Noisy Tuning Fork Signal')

% Filter order parameters
M=4000; %Half of filter order, adjust this to improve filter
z=(2*M)+1; % Filter order
n=[0:1:z-1]; % Filter length
N=z-1;

% Blackman window
w=0.42-0.5*cos(2*pi*(0:z-1)/(z-1))+0.08*cos(4*pi*(0:z-1)/(z-1));

% Lower lowpass filter
FcL = 320; % cutoff frequency
hideal_nL = (2*FcL/Fs)*sinc((2*FcL/Fs)*(n-M)); % Ideal lowpass filter
h_nL = w.*hideal_nL; % Applying Blackman window
H_fL = fft(h_nL); % Convert window to frequency domain
H_fL_mag =abs(H_fL); % Magnitude
H_fL_phase =unwrap(angle(H_fL)); % Phase

% Upper lowpass filter
Fc_H=340;
hideal_nH=(2*Fc_H/Fs)*sinc((2*Fc_H/Fs)*(n-M)); % Ideal lowpass filter
h_nH=w.*hideal_nH; % Applying Blackman window
H_fH=fft(h_nH); % Convert window to frequency domain
H_fH_mag=abs(4*H_fH); % Magnitude
H_fH_phase=unwrap(angle(H_fH)); % phase

figure(2)

subplot(3,1,1)
plot(hideal_nL);
xlim([2000 6000])
ylim([-0.05 0.1])
xlabel('Sample (n)')
ylabel('h(n)')
title('Ideal filter, Impulse response')

subplot(3,1,2)
plot(w);
xlim([0 8000])
xlabel('Sample (n)')
ylabel ('w(n)')
title('Blackman window')

subplot(3,1,3)
plot(h_nL);
xlim([2000 6000])
ylim([-0.05 0.1])
xlabel('Sample (n)')
ylabel('h(n) x w(n)')
title('Blackman window applied to Ideal filter - Lower Lowpass filter 300Hz cutoff')

figure(3)

subplot(2,1,1)
plot(H_fL_mag);
xlim([300 350])
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')
title('Magnitude of Lower Lowpass Filter')

subplot(2,1,2)
plot(H_fL_phase);
xlim([0 500])
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')
title('Phase of Lower Lowpass Filter')

figure(4)

subplot(2,1,1)
plot(H_fH_mag);
xlim([300 350])
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')
title('Magnitude of Upper Lowpass Filter')

subplot(2,1,2)
plot(H_fH_phase);
xlim([0 500])
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')
title('Phase of Upper Lowpass Filter')

% Combining Lower and Upper Lowpass filters to create bandpass filter,
% allowing a range from 320Hz-340Hz
H_f=H_fH-H_fL;
H_f_mag=abs(H_f);
H_f_phase=unwrap(angle(H_f));

figure(5)
subplot(2,1,1)
plot(H_f_mag);
xlim([300 400])
title('Bandpass Filter Magnitude')
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')

subplot(2,1,2)
plot(H_f_phase);
xlim([0 500])
title('Bandpass Filter Phase')
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')

h_n=ifft(H_f);

% Filtering noise from the Noisy Tuning Fork Sample

% 'same' returns the central part of convolution the same size as
% Noisy_Signal
Noisy_Signal_Filtered=conv(Noisy_Signal, h_n, 'same');

Noisy_Signal_Filtered_DFT=fft(Noisy_Signal_Filtered);

Noisy_Signal_Filtered_PSD=(abs(Noisy_Signal_Filtered_DFT).^2)/N;

figure(6)
subplot(3,1,1)
plot(20*log10(Signal_PSD));
xlim([0 8000])
title('Original Signal PSD')
xlabel('Frequency (Hz)')
ylabel('PSD (dB)')

subplot(3,1,2)
plot(20*log10(Noisy_Signal_PSD));
xlim([0 8000])
title('Noisy Signal PSD')
xlabel('Frequency (Hz)')
ylabel('PSD (dB)')

subplot(3,1,3)
plot(20*log10(Noisy_Signal_Filtered_PSD));
xlim([0 8000])
title('Filtered Signal PSD')
xlabel('Frequency (Hz)')
ylabel('PSD (dB)')

Signal=Signal.*50
Noisy_Signal=Noisy_Signal.*50
Noisy_Signal_Filtered=Noisy_Signal_Filtered.*50

playSignal=audioplayer(Signal,Fs,Nbits,outputdev);
playNoisy_Signal=audioplayer(Noisy_Signal,Fs,Nbits,outputdev);
playNoisy_Signal_Filtered=audioplayer(Noisy_Signal_Filtered,Fs,Nbits,outputdev);

disp('Playing Original Tuning Fork Recording:')
play(playSignal);
pause(2);
disp('Playing Noisy Tuning Fork Signal:')
play(playNoisy_Signal);
pause(2);
disp('Playing Filtered Tuning Fork Signal:')
play(playNoisy_Signal_Filtered);