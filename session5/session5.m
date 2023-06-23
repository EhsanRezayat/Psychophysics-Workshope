%% %%%%%%   In the name of God, the most gracious, the most merciful %%%%%%
%% MATLAB for Brain and Cognitive Psychology Workshope 2023
% Ehsan Rezayat, Ph.D.
% Faculty of Psychology and Education, University of Tehran,
% Institute for Research in Fundamental Sciences (IPM), School of Cognitive Sciences,
% rezayat@ut.ac.ir, rezayat@ipm.ir, erezayat.er@gmail.com 
% Contributed by: Amir.M Mousavi.H, Helia Thaghavi & Fatemeh Fallah
% Amir.harris@sru.ac.ir   heliabsb@gmail.com  fh.fallah90@gmail.com
% last edition : 02/11/2023

%% session #5 Generating Stimuli  

path_code = cd;
addpath(genpath([path_code '\sup']))
%%

%% Example of sin wave

close all
srate = 1000;           % sampling rate in Hz
time = 0:1/srate:1;     % units of seconds
f = 4;                  % units of Hz
a = 2;                  % arbitrary units
th = pi/2;              % in radians
sinewave = a*sin(2*pi*f*time+th);
figure
hold on
plot(time,sinewave)
plot(time,0.5*sinewave,'r')

%% Ferqunecy

f=10;
figure
hold on

plot(time,sinewave)

sinewave = a*sin(2*pi*f*time+th);
plot(time,sinewave,'r')

%% Phase

sinewave = a*sin(2*pi*f*time+th);
sinewave2 = a*sin(2*pi*f*time+th/2);

figure
hold on

plot(time,sinewave)
plot(time,sinewave2,'r')
%%
%% FFT of sin waves

Fs = 1000;                    % Sampling frequency
T = 1/Fs;                     % Sample time
L = 1000;                     % Length of signal
t = (0:L-1)*T;                % Time vector
figure 

subplot(421)
hold on
A= 5;                                             % Amplitude
fe=15;                                          %frequency
w = 2*pi*fe;                              % Angular frequency
phi = 0;                                       % Phase shift
x1 = A*sin(w*t+phi);
plot(t,x1)
xlabel('t')
ylabel('x1(t)')
legend('15 Hz')


subplot(422)
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(x1,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);
% Plot single-sided amplitude spectrum.
plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of x1(t)')
xlabel('Frequency (Hz)')
ylabel('|X1(f)|')
axis([0 100 ylim])

subplot(423)
A= 5; 
w = 2*pi*35; 
phi =3*pi/2 ;
x2 = A*sin(w*t+phi);
plot(t,x2)
xlabel('t')
ylabel('x2(t)')
legend('35 Hz')


subplot(424)
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(x2,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);
% Plot single-sided amplitude spectrum.
plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of x2(t)')
xlabel('Frequency (Hz)')
ylabel('|X2(f)|')
axis([0 100 ylim])

subplot(425)
hold on
A= 7; 
w = 2*pi*1.5;
phi =2.5*pi/2 ;
x3 = A*sin(w*t+phi);
plot(t,x3)
legend('1.5 Hz')
xlabel('t')
ylabel('x3(t)')

subplot(426)
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(x3,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);
% Plot single-sided amplitude spectrum.
plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of x3(t)')
xlabel('Frequency (Hz)')
ylabel('|X3(f)|')
axis([0 100 ylim])


subplot(427)
hold on
x4 = x1+x2+x3;
plot(t,x4)
xlabel('t')
ylabel('x4(t)')
legend('x1+x2+x3')

subplot(428)
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(x4,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);
% Plot single-sided amplitude spectrum.
plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of x4(t)')
xlabel('Frequency (Hz)')
ylabel('|X4(f)|')
axis([0 100 ylim])
%% FFT of squre waves

Fs = 1000;                    % Sampling frequency
T = 1/Fs;                     % Sample time
L = 1000;                     % Length of signal
t = (0:L-1)*T;            % Time vector
figure 

subplot(421)
hold on
A= 5; 
w = 2*pi*15; 
phi = 0;
x1 = A*sin(w*t+phi);
x1(x1>0)=1;x1(x1<0)=-1;  % OR ==>  y = square(w*t)
hold on
plot(t,x1)
xlabel('t')
ylabel('x1(t)')
legend('15 Hz')


subplot(422)
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y1 = fft(x1,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);
% Plot single-sided amplitude spectrum.
plot(f,2*abs(Y1(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of x1(t)')
xlabel('Frequency (Hz)')
ylabel('|X1(f)|')

subplot(423)
hold on
A= abs(Y1(find((abs(f-15)<0.5)))); 
w = 2*pi*15;
phi =0 ;
x2 = A*sin(w*t+phi);
plot(t,x2)
xlabel('t')
ylabel('x2(t)')
legend('15 Hz')


subplot(424)
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(x2,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);
% Plot single-sided amplitude spectrum.
plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of x2(t)')
xlabel('Frequency (Hz)')
ylabel('|X2(f)|')

subplot(425)
hold on
A= abs(Y1(find((abs(f-45)<0.5)))); w = 2*pi*3*15; phi =0 ;
x3 = A*sin(w*t+phi);
plot(t,x3)
legend('45 Hz')
xlabel('t')
ylabel('x3(t)')

subplot(426)
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(x3,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);
% Plot single-sided amplitude spectrum.
plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of x3(t)')
xlabel('Frequency (Hz)')
ylabel('|X3(f)|')


subplot(427)
hold on
x4 = x2+x3;
plot(t,x4)
plot(t,x1)
xlabel('t')
ylabel('x4(t)')
legend('x2+x3')

subplot(428)
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(x4,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);
% Plot single-sided amplitude spectrum.
plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of x4(t)')
xlabel('Frequency (Hz)')
ylabel('|X4(f)|')

%% Reading from wav files
figure
[applauseData, applauseFreq] = psychwavread('Applause.wav');
plot(applauseData)
sound(applauseData,48000);

%% Reading from audio files
figure
[melodyData, melodyFreq ] = audioread('melody.mp3');
plot(melodyData)
sound(melodyData,48000);

%% Creating noise sound file
figure
samplingFreq = 48000;
duration = 5;
whitenoise = rand(1,(samplingFreq * duration));
sound(whitenoise,samplingFreq);
plot(whitenoise)
axis([1 length(whitenoise) -2 2 ])

%% Creating Beep sound file
figure
beep2000 = MakeBeep(2000,3,48000);
sound(beep2000,48000);
plot(beep2000)

%% Creating Beep sound file
figure
beep200 = MakeBeep(200,3,48000);
sound(beep200,48000);
plot(beep200)

%% playing audio file

[melodyData, melodyFreq] = audioread('melody.mp3');
pahandle=PsychPortAudio('Open');

% loads data into buffer
PsychPortAudio('FillBuffer', pahandle, melodyData');
% how many repititions of the sound
repetitions=1;
%starts sound immediatley
PsychPortAudio('Start', pahandle, repetitions,0);
% stop
PsychPortAudio('Stop', pahandle, 1,0);
PsychPortAudio('Close',pahandle);

%% Visual stimuli 

%% Checkboard1
M = [1 2 1 2 1 2 1 2
    2 1 2 1 2 1 2 1
    1 2 1 2 1 2 1 2
    2 1 2 1 2 1 2 1
    1 2 1 2 1 2 1 2
    2 1 2 1 2 1 2 1
    1 2 1 2 1 2 1 2
    2 1 2 1 2 1 2 1];
%% Checkboard2
M=[];
for i = 1:8
    for j = 1:8
        M(i,  j) = mod(i + j,  2) + 1;      % mod(v, 2) returns the residual of v divided by 2
    end
end

%% Checkboard 3
[x, y] = meshgrid(-4:3,  4:-1:-3);
M = mod(x + y,  2) + 1;

%% Preview Checkboard
figure;            % set up a new figure window
image(M);          % display an image described in matrix M
axis('square');    % make the aspect ratio of the image
% square
axis('off');       % turn off all axis lines and markings

lut1 = [0 0 0;  1 1 1]; % define a two row lookup table for
% the color translation of 1,2
colormap(lut1);    % apply the lut to the displayed image

%% Random WhiteNoiseImage
M = 127 + 42*randn(64);
M = uint8(M)  +  1;
showImage(M,   'grayscale');

%% FixationCross
[x,  y] = meshgrid(-128:127,  128:-1:-127);
M = 127*(1- ((y == 0 & x > -8 & x < 8) ...
    |(x == 0 & y > -8 & y < 8))) + 1;
showImage(M,   'grayscale');

%% FixationDot
[x,  y] = meshgrid(-128:127,  128:-1:-127);
M = (x.^2 + y.^2  >= 15^2)*127 + 1;
showImage(M, 'grayscale');

%% Show Image
close all
[M,  map] = imread('\sup\milad.jpg'); %use the function imread to reads the image
showImage(M,   'grayscale');               %use the showImage function to show the image (it is not matlab built-in function)

%% ThreeCLUT
[x, y] = meshgrid(-4:3,  4:-1:-3);
M = mod(x + y,  2) + 1;    % Checkboard

figure;            % set up a new figure window
image(M);          % display an image described in matrix M
axis('square');    % make the aspect ratio of the image
% square
axis('off');       % turn off all axis lines and markings
lut1 = [0 0 0;  1 1 1]; % define a two row lookup table for
% the color translation of 1,2
colormap(lut1);    % apply the lut to the displayed image
% gives control to the user's keyboard
% type "dbcont" at the "K>>" prompt,

figure;            % set up a new figure window
image(M);          % display an image described in matrix M
axis('square');    % make the aspect ratio of the image
% square
axis('off');       % turn off all axis lines and markings
% the program will continue
lut2 = [1 0 0;  0 1 0];  % a new lookup table
colormap(lut2);


figure;            % set up a new figure window
image(M);          % display an image described in matrix M
axis('square');    % make the aspect ratio of the image
% square
axis('off');       % turn off all axis lines and markings
lut3 = [0.6 0.6 0.6;  0.4 0.4 0.4]; %another lookup table
colormap(lut3);

%% RGB to gray converter for image
[M,  map] = imread('\sup\milad.jpg'); %use the function imread to reads the image

M1 = rgb2gray(M);                          %convert RGB image to a grayscale image
showImage(M1,   'grayscale');

%% read Image
close all
img = imread('milad.jpg');
showImage(img, 'grayscale');

%% Image size

[rows, columns, numberOfColorChannels] = size(img);

%% Image resize
figure
Image1 = imread('milad.jpg');
Image2 = imresize(Image1, 0.3);

imshow(Image2)
title('Resized Image')

%% Image crop

figure
IMG1 = imread('milad.jpg');
IMG2 = imcrop(IMG1,[300 400 500 600]); %crop the image in given position
subplot(1,2,1)
imshow(IMG1)
title('Original Image')
subplot(1,2,2)
imshow(IMG2)
title('Cropped Image')
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 1 0.5 0.5]);

%% Image Location

close all
fontSize = 20;
% Make 2 images.
Image1 = imread('cameraman.tif');
Image2 = imread('moon.jpg');

% Display image 1 .
subplot(1, 2, 1);
imshow(Image1);
title('cameraman.tif', 'FontSize', fontSize, 'Interpreter', 'None');
% Set up figure properties:
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% Display image 2.
subplot(1, 2, 2);
imshow(Image2);
title('moon.jpg', 'FontSize', fontSize, 'Interpreter', 'None');

%% Merging two image
close all

Image3 = imfuse(Image1,Image2,'blend','Scaling','joint');


subplot(1, 2, 1);
imshow(Image3)

Image3 = imfuse(Image1,Image2,'falsecolor','Scaling','joint','ColorChannels',[2 1 2]);
subplot(1, 2, 2);
imshow(Image3)

%%  NoiseMasking
close all

M = imread('milad.jpg');
M1 = rgb2gray(M);
Mn = mean2(M1);
Sz = size(M);
% Generating a white Gaussian noise image with standard deviation s

s = 3;
noiseI = s*randn(Sz(1),  Sz(2));
M2 = uint8(double(M1) + noiseI);  % noise is double, so make M1
% double, too
showImage(M2,'grayscale');

s = 50;
noiseI = s*randn(Sz(1),  Sz(2));
M3 = uint8(double(M1) + noiseI);
showImage(M3,'grayscale');

%% Pixel scrambled
close all
M = imread('milad.jpg');

M1 = rgb2gray(M); %convert RGB image to a grayscale image
showImage(M1,   'grayscale');
[xs,ys] = size(M1);
object_ = M1(:);
object_=object_(randperm(size(object_,1),size(object_,1)));
reconstruct_img =reshape(object_,xs,ys);


imshow(reconstruct_img,[]);

%% Phase scrambled
close all
M = imread('milad.jpg');

M1 = rgb2gray(M);                          %convert RGB image to a grayscale image
showImage(M1,   'grayscale');
object_fft = fft2(M1);
mag = abs(object_fft);
phase = angle(object_fft);
phase = -pi + (pi+pi) * rand(size(phase)); % Between -pi and pi
clear i 
reconstruct_img = mag.* exp(1i * phase);

phase_scrambled_img = abs(ifft2(reconstruct_img));
imshow(phase_scrambled_img,[]);

%% Texture scrambled
close all
M1 = rgb2gray(M);
if mod(size(M1,1),2)~=0
    M1=  M1(1:end-1,:);
end
if mod(size(M1,2),2)~=0
        M1=  M1(:,1:end-1);

end
Sz = size(M1);

divider = 8;

sp = round(Sz/divider);

imalist= [];
cnt =0;
for i= 1:divider
    for j= 1:divider
    cnt = cnt +1; 
    
      imalist(cnt,:,:) =  M1((i-1)*sp(1)+1:i*sp(1),(j-1)*sp(2)+1:j*sp(2)) ;
    end 
    
end 
imalist = imalist(randperm(size(imalist,1),size(imalist,1)),:,:);
M2 =[];cnt =0;
for i= 1:divider
    for j= 1:divider
    cnt = cnt +1; 
    
      M2((i-1)*sp(1)+1:i*sp(1),(j-1)*sp(2)+1:j*sp(2)) =  squeeze(imalist(cnt,:,:));
    end 
    
end 

showImage(M2,'grayscale');

%% SHINE Toolbox
SHINE

%% SinewaveGratingGabor
figure
c = 0.25;            % contrast of the Gabor
f = 1/32;            % spatial frequency in 1/pixels
t = 15*pi/180;       % tilt of 35 degrees into radians
s = 24;              % standard deviation of the spatial
% window of the Gabor
[x,  y] = meshgrid(-128:127, 128:-1:-127);
M1 = uint8(127*(1 + c*sin(2.0*pi*f*(y*sin(t) + x*cos(t)))));
% uint8 converts the elements of the array into unsigned
% 8-bit integers. Values outside this range are mapped
% to 0 or 255.
showImage(M1,  'grayscale');

%% Gabor
M2 = uint8(127*(1 + c*sin(2.0*pi*f*(y*sin(t) + x*cos(t))) ...
    .*exp(-(x.^2 + y.^2)/2/s^2)));
showImage(M2,   'grayscale');

%%
c = 0.25;            % contrast of the Gabor
f = 2/32;            % spatial frequency in 1/pixels
t = 170*pi/180;       % tilt of 35 degrees into radians
s = 24;              % standard deviation of the spatial
% window of the Gabor
[x,  y] = meshgrid(-128:127, 128:-1:-127);
M1 = uint8(127*(1 + c*sin(2.0*pi*f*(y*sin(t) + x*cos(t)))));
% uint8 converts the elements of the array into unsigned
% 8-bit integers. Values outside this range are mapped
% to 0 or 255.
showImage(M1,  'grayscale');

c = 0.25;            % contrast of the Gabor
f = 2/32;            % spatial frequency in 1/pixels
t = 0*pi/180;       % tilt of 35 degrees into radians
s = 24;              % standard deviation of the spatial
% window of the Gabor
[x,  y] = meshgrid(-128:127, 128:-1:-127);
M2 = uint8(127*(1 + c*sin(2.0*pi*f*(y*sin(t) + x*cos(t)))));
% uint8 converts the elements of the array into unsigned
% 8-bit integers. Values outside this range are mapped
% to 0 or 255.
M3 =M2+M1;
showImage(M3,  'grayscale');


%%
close all
M1 = rgb2gray(M);
fM = fftshift(fft2(M1 - mean2(M1))); %Fourier transformation
Sz = size(M1);
m_fM = abs(fM);     % extract the magnitudes spectrum

%% ContrastModulatedGrating
c = 0.50;
f = 1/32;
[x,  y] = meshgrid(-64:63,  64:-1:-63);
N = 2*(rand(128,128) > 0.5) - 1;
M = uint8(127*(1 + N.*(0.5 + c*sin(2.0*pi*f*x))));
showImage(M, 'grayscale');

