%% %%%%%%   In the name of God, the most gracious, the most merciful %%%%%%
%% MATLAB for Brain and Cognitive Psychology Workshope 2023
% Ehsan Rezayat, Ph.D.
% Faculty of Psychology and Education, University of Tehran,
% Institute for Research in Fundamental Sciences (IPM), School of Cognitive Sciences,
% rezayat@ut.ac.ir, rezayat@ipm.ir, erezayat.er@gmail.com 
% Contributed by: Amir.M Mousavi.H, Helia Thaghavi & Fatemeh Fallah
% Amir.harris@sru.ac.ir   heliabsb@gmail.com  fh.fallah90@gmail.com
% last edition : 02/11/2023

%% Session #Signal analysis 
close all;
clear all;
clc;

path_code = cd;
addpath(genpath([path_code '\sup']))

%% Rate coding Rater plot 
ndass_spiking_activity_01_raster_plot_dataset1();
%% Rate coding PSTH
ndass_spiking_activity_02_psth_dataset1();
%% Load smaple data EEG

load sampledata
timewin      = 2500; % in ms
lfp_data = lfp_data(:,1:timewin);


% extract a bit of EEG data
% sig = (squeeze(EEG.data(strcmpi(channel2plot,{EEG.chanlocs.labels}),:,10)));
sig = lfp_data (1,1:timewin);

% plot EEG data snippet

t = 1:timewin;
t = t-500;
figure 
plot(t,sig)
xlabel('Time from stim onset (ms)')
ylabel('Raw LFP (mV)')
axis([-500 2000 ylim])

%% plot ERP 
figure 
plot(t,nanmean(lfp_data))
xlabel('Time from stim onset (ms)')
ylabel('Raw LFP (mV)')
axis([-500 2000 ylim])
figure 
imagesc(t,[1:18],lfp_data)
xlabel('Time from stim onset (ms)')
ylabel('Channels (#)')

%% FFT No widows
fs= 1000;
figure 
L=length(sig);
  NFFT = 2^nextpow2(L); % Next power of 2 from length of y
    sig_fft = fft(sig,NFFT)/L;
    sig_fft =  sig_fft(1:NFFT/2+1);
f = fs/2*linspace(0,1,NFFT/2+1);
plot(f,2*abs(sig_fft)) 
title('Single-Sided Amplitude Spectrum of sig')
xlabel('Frequency (Hz)')
ylabel('|SIG(f)|')
axis([0 100 ylim])

%% Windowing FFT overlaped windows
stp =5; win_ = 100;
win_h = [1:stp:length(sig)-win_+1;win_:stp:length(sig);]';
windowed_fft =[];
for i= 1:size(win_h,1)
    var_h= [];
    var_h = sig(win_h(i,1):win_h(i,2));
    L =length(var_h); 

    NFFT = 2^nextpow2(L); % Next power of 2 from length of y
    Y = fft(var_h,NFFT)/L;
    windowed_fft(i,:) =  Y(1:NFFT/2);
    
end
t_h = mean(win_h,2);
t_h = t_h-500;
f = fs/2*linspace(0,1,NFFT/2);
figure 
subplot(4,1,1)
plot(t,sig)
xlabel('time (ms)')
ylabel('Raw LFP (mV)')
axis([-500 2000 ylim])
subplot(4,1,[2:4])
imagesc(t_h,f,abs(windowed_fft)')
xlabel('time (ms)')
ylabel('Frequency (Hz)')
axis([xlim 0 100])

%% Windowing FFT nonoverlaped windows
stp =100; win_ = 100;
win_h = [1:stp:length(sig)-win_+1;win_:stp:length(sig);]';
windowed_fft =[];
for i= 1:size(win_h,1)
    var_h= [];
    var_h = sig(win_h(i,1):win_h(i,2));
    L =length(var_h); 

    NFFT = 2^nextpow2(L); % Next power of 2 from length of y
    Y = fft(var_h,NFFT)/L;
    windowed_fft(i,:) =  Y(1:NFFT/2);
    
end
t_h = mean(win_h,2);
t_h = t_h-500;

f = fs/2*linspace(0,1,NFFT/2);
figure 
subplot(4,1,1)
plot(t,sig)
xlabel('time (ms)')
ylabel('Raw LFP (mV)')
axis([-500 2000 ylim])
subplot(4,1,[2:4])
imagesc(t_h,f,abs(windowed_fft)')
xlabel('time (ms)')
ylabel('Frequency (Hz)')
axis([xlim 0 100])

%% Windowing Multitapper
stp =5; win_ =100 ;
win_h = [1:stp:length(sig)-win_+1;win_:stp:length(sig);]';
win_l = win_h(1,2);

nw_product      = 3;  % determines the frequency smoothing, given a specified time window
timewinidx = win_l;
tapers = dpss(timewinidx,nw_product); % note that in practice, you'll want to set the temporal resolution to be a function of frequency
windowed_fft =[];
for i= 1:size(win_h,1)
    var_h= [];
    var_h = sig(win_h(i,1):win_h(i,2));
    for tp =1:size(tapers,2)
    var_h_ = var_h .*tapers(:,tp)';
    L =length(var_h); 

    NFFT = 2^nextpow2(L); % Next power of 2 from length of y
    Y = fft(var_h,NFFT)/L;
    windowed_fft(i,tp,:) =  Y(1:NFFT/2);
    end
end
mtp_fft = squeeze(nanmean(abs(windowed_fft),2));
t_h = mean(win_h,2);
t_h = t_h-500;
f = fs/2*linspace(0,1,64/2);
figure 
subplot(4,1,1)
plot(t,sig)
xlabel('time (ms)')
ylabel('Raw LFP (mV)')
axis([-500 2000 ylim])
subplot(4,1,[2:4])
imagesc(t_h,f,(mtp_fft)')
xlabel('time (ms)')
ylabel('Frequency (Hz)')
axis([xlim 0 100])

%% Wavelet over trials
s_1 =lfp_data(1,1:2500);
freqs2use  = 4:2:60;
[Power,Phase,freqs2use,time] = wavelet_transform(s_1,freqs2use);

figure 
subplot(121)
imagesc(t,freqs2use,squeeze((Power)))
xlabel('Time (ms)'), ylabel('Frequency')
title('Power')
subplot(122)
imagesc(t,freqs2use,squeeze((Phase)))
xlabel('Time (ms)'), ylabel('Frequency')
title('Phase')

%% Wavelet over trials
s_1 =lfp_data(:,1:2500);
freqs2use  = 4:2:60;
[Power,Phase,freqs2use,time] = wavelet_transform(s_1,freqs2use);

figure 
subplot(121)
imagesc(t,freqs2use,squeeze(nanmean(Power)))
xlabel('Time (ms)'), ylabel('Frequency')
title('Power')
subplot(122)
imagesc(t,freqs2use,squeeze(abs(nanmean(exp(1i*Phase)))))
title('Phase locking value')

