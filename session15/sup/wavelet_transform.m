function [Power,Phase,freqs2use,time]= wavelet_transform(sig,freqs2use)
fs=1000; % Sampling frequency 
padding_pnt=500; %% zero Padding
t=1:size(sig,2);
if isempty(freqs2use)
freqs2use=[4:30, 33:3:130]; %% Frequency band can be defined based on your focuse in Hertz here
end
sig_h = [];
for trii=1:size(sig,1)
    sig_h = [sig_h [ zeros(1,padding_pnt) (sig(trii,:)) zeros(1,padding_pnt)]];  
end

timewindow = linspace(1,3,length(freqs2use)); % number of cycles on either end of the center point (1 means a total of 2 cycles))
pnts=size(sig,2)+2*padding_pnt;trials=size(sig,1);
% wavelet and FFT parameters
time          = -1:1/fs:1;
half_wavelet  = (length(time)-1)/2;

num_cycles    = 7*ones(1,length(freqs2use)); %% This code is for using fixed cycle parameter if you wnat to have low frequency uncomment below line 
% num_cycles    = logspace(log10(4),log10(8),length(freqs2use)); 
n_wavelet     = length(time);
n_data        = pnts*trials;
n_convolution = n_wavelet+n_data-1;

% data FFTs
data_fft1 = fft(reshape(sig_h,1,n_data),n_convolution);
Power_h=[]; Phase_h=[];
%% core
for fi=1:length(freqs2use)
    
    % create wavelet and take FFT
    s = num_cycles(fi)/(2*pi*freqs2use(fi));
    wavelet_fft = fft( exp(2*1i*pi*freqs2use(fi).*time) .* exp(-time.^2./(2*(s^2))) ,n_convolution);
    
    % phase angles from channel 1 via convolution
    convolution_result_fft = ifft(wavelet_fft.*data_fft1,n_convolution);
    convolution_result_fft = convolution_result_fft(half_wavelet+1:end-half_wavelet);
    Analytic_sig =[]; Analytic_sig = (reshape(convolution_result_fft,pnts,trials));
    
  
    
    % phase angle differences
    %  phase_diffs = phase_sig1-phase_sig2;
    Power_h(:,fi,:)=(abs(Analytic_sig).^2)';
    Phase_h(:,fi,:)=(angle(Analytic_sig))';
    
    %             end
end % end frequency loop

Power=Power_h(:,:,padding_pnt+1:end-padding_pnt);
Phase=Phase_h(:,:,padding_pnt+1:end-padding_pnt);
end
