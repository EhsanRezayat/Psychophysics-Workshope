%% %%%%%%   In the name of God, the most gracious, the most merciful %%%%%%
%% MATLAB for Brain and Cognitive Psychology Workshope 2023
% Ehsan Rezayat, Ph.D.
% Faculty of Psychology and Education, University of Tehran,
% Institute for Research in Fundamental Sciences (IPM), School of Cognitive Sciences,
% rezayat@ut.ac.ir, rezayat@ipm.ir, erezayat.er@gmail.com 
% Contributed by: Amir.M Mousavi.H, Helia Thaghavi & Fatemeh Fallah
% Amir.harris@sru.ac.ir   heliabsb@gmail.com  fh.fallah90@gmail.com
% last edition : 02/11/2023

%% session #8 Presentation Stimuli  

path_code = cd;
addpath(genpath([path_code '\sup']))

%% Read in the image data using imread()
A = imread('mypicture.jpg');
[A, map] = imread('mypicture.jpg');
[A, map, alpha] = imread('mypicture.jpg');

%% Read in the image data using imread()
faceData = imread('sadface.jpg');
size(faceData)

%% Displaying images

Screen('Preference', 'SkipSyncTests', 1);
%Open the screen
 [wPtr,rect]=Screen('Openwindow',max(Screen('Screens')),[128 128 128 ]);
%  [wPtr,rect]=Screen('Openwindow',max(Screen('Screens')),[128 128 128 ]);

%Create texture
faceData=imread('sadface.jpg');
faceTexture=Screen('MakeTexture',wPtr,faceData);

%Draw it
Screen('DrawTexture',wPtr,faceTexture);
Screen('Flip',wPtr);
 
%Wait for keypress and clear
KbWait();

clear Screen;

 %% Moving images

Screen('Preference', 'SkipSyncTests', 1);
%Open the screen 
 [wPtr,rect]=Screen('Openwindow',max(Screen('Screens')),[128 128 128 ]);
% [wPtr,rect]=Screen('Openwindow',ma x(Screen('Screens')),[128 128 128 ]);

xCenter=rect(3)/2;
yCenter=rect(4)/2;

%Create texture
faceData=imread('sadface.jpg');
faceTexture=Screen('MakeTexture',wPtr,faceData);

%Get size of image
[imageHeight,imageWidth,colorChannels]=size(faceData);

%Define image rect
imageRect=[0 0 imageWidth imageHeight];

%Draw it
Screen('DrawTexture',wPtr,faceTexture,[],imageRect);
Screen('Flip',wPtr);

%Wait for keypress
KbWait();

%Move the image to 50,100
xOffset=xCenter; 
yOffset=yCenter;
imageRect=[xOffset-imageWidth/2,yOffset-imageHeight/2, ...
    xOffset+imageWidth/2,yOffset+imageHeight/2];

%Draw new version
Screen('DrawTexture',wPtr,faceTexture,[],imageRect);
Screen('Flip',wPtr);

%Wait for keypress and clear
WaitSecs(0.5);
KbWait();
clear Screen;

 %% Scaling images

Screen('Preference', 'SkipSyncTests', 1);

%Open the screen 
 [wPtr,rect]=Screen('Openwindow',max(Screen('Screens')),[128 128 128 ]);
% [wPtr,rect]=Screen('Openwindow',max(Screen('Screens')),[128 128 128 ]);

xCenter=rect(3)/2;
yCenter=rect(4)/2;

%Create texture
faceData=imread('sadface.jpg');
faceTexture=Screen('MakeTexture',wPtr,faceData);

%Get size of image
[imageHeight,imageWidth,colorChannels]=size(faceData);

%Define image rect
imageRect=[0 0 imageWidth imageHeight];

%Center it
destinationRect=CenterRect(imageRect,rect);

%Draw it
Screen('DrawTexture',wPtr,faceTexture,[],destinationRect);
Screen('Flip',wPtr);

%Wait for keypress
KbWait();
 
%Shrink by a factor of 2
imageRect=imageRect./2;
destinationRect=CenterRect(imageRect,rect);

%Draw shrunken version
Screen('DrawTexture',wPtr,faceTexture,[],destinationRect);
Screen('Flip',wPtr);

%Wait for keypress and clear
WaitSecs(0.5);
KbWait();
clear Screen;

%% Rotating images

Screen('Preference', 'SkipSyncTests', 1);
%Open the screen
 %[wPtr,rect]=Screen('Openwindow',max(Screen('Screens')),[128 128 128 ],[1 1 900 800]);
 [wPtr,rect]=Screen('Openwindow',max(Screen('Screens')),[128 128 128 ]);

%Creat texture
faceData=imread('sadface.jpg');
faceTexture=Screen('MakeTexture',wPtr,faceData);

%Draw it
Screen('DrawTexture',wPtr,faceTexture);
Screen('Flip',wPtr);

%Wait for keypress and clear
KbWait();

angle=0;

start=GetSecs();
duration=5;

while GetSecs < start + duration
    Screen('DrawTexture',wPtr,faceTexture,[],destinationRect,angle);
    Screen('Flip',wPtr);
    angle= angle+10;
end
    
clear Screen;

%% Multiple images
Screen('Preference', 'SkipSyncTests', 1);

%Open the screen
% [wPtr,rect]=Screen('Openwindow',max(Screen('Screens')),[128 128 128 ],[1 1 900 800]);
 [wPtr,rect]=Screen('Openwindow',max(Screen('Screens')),[128 128 128 ]);

xCenter=rect(3)/2;
yCenter=rect(4)/2;

%Create textures
sadFaceData=imread('sadface.jpg');
sadFaceTexture=Screen('MakeTexture',wPtr,sadFaceData);

angryFaceData=imread('angryface.jpg');
angryFaceTexture=Screen('MakeTexture',wPtr,angryFaceData);

%Get size of image(both images are the same size in this example)
[imageHeight,imageWidth,colorChannels]=size(sadFaceData);

%Define upper left hand corner of image rect
distanceFromCenter=50;
sadX=xCenter - imageWidth - distanceFromCenter;
sadY=yCenter - imageHeight/2;
angryX=xCenter + distanceFromCenter;
angryY=yCenter - imageHeight/2;

%Define destination rects
sadRect=[sadX,sadY,sadX+imageWidth,sadY+imageHeight];
angryRect=[angryX,angryY,angryX+imageWidth,angryY+imageHeight];
 
%Draw them 
Screen('DrawTexture',wPtr,sadFaceTexture,[],sadRect);
Screen('DrawTexture',wPtr,angryFaceTexture,[],angryRect);
Screen('Flip',wPtr);

%Wait for keypress and clear
KbWait();
clear Screen;

%% Alpha blending
 
%open screen
Screen('Preference', 'SkipSyncTests', 1);
%  [wPtr,rect]=Screen('Openwindow',max(Screen('Screens')),[128 128 128 ],[1 1 900 800]);
[wPtr,rect]=Screen('Openwindow',max(Screen('Screens')),[128 128 128 ]);

% Turn on alpha blending
Screen('BlendFunction',wPtr,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);

%Create texture
faceData=imread('sadface.jpg');
faceTexture=Screen('MakeTexture',wPtr,faceData);

%Draw it
Screen('DrawTexture',wPtr,faceTexture,[],[],[],[],0.1);

%Get size of image
[imageHeight,imageWidth,colorChannels]=size(faceData);

%Define image rect
imageRect=[0 0 imageWidth imageHeight];

%Draw it
Screen('DrawTexture',wPtr,faceTexture,[],imageRect);


%show them    
Screen('Flip',wPtr)

KbWait(); %wait until key pressed

clear Screen;

  %% Movies
playMovie()


%% play sound

%Mark script start time
scriptStart = GetSecs();
%Initialize the sound driver
InitializePsychSound;
%Read in the sound data from file 
wavfilename=[cd '/sup/Applause.wav']
[soundData, freq] = audioread(wavfilename);
%Prepare sound data (make it two rows for stereo playback)
soundData = [soundData, soundData];
numChannels=2;
%Open the audio driver
pahandle = PsychPortAudio('Open',[], [], 0, freq,numChannels);
%Fill the buffer
PsychPortAudio('FillBuffer',pahandle,soundData');
%Play the sound
playTime = PsychPortAudio('Start',pahandle);
fprintf('\nSound started playing %.2f seconds after start of script\n',playTime,scriptStart);
%Close the audio driver
PsychPortAudio('Stop', pahandle, 1,0);
PsychPortAudio('Close',pahandle);

%% recording sound

%Initialize sound driver
InitializePsychSound;
duration = 5;
%Open audio channel for recording using mode 2
freq = 44100;
pahandle = PsychPortAudio('Open', [], 2, 0, freq, 2);
%Set up buffer for recording
PsychPortAudio('GetAudioData', pahandle, duration);
%Start recording
PsychPortAudio('Start', pahandle, 0, 0, 1);
%Go until keypress
fprintf('Recording...\n'); 
WaitSecs(duration);
fprintf('Done recording.\n');
%Stop Recording
PsychPortAudio('Stop', pahandle);
%Get the audio data we recorded
audioData = PsychPortAudio('GetAudioData',pahandle);

%Close the audio channel
PsychPortAudio('Close',pahandle);
%% play recorded sound
soundData = audioData';
numChannels=2;
%Open the audio driver
pahandle = PsychPortAudio('Open',[], [], 0, freq,numChannels);
%Fill the buffer
PsychPortAudio('FillBuffer',pahandle,soundData');
%Play the sound
playTime = PsychPortAudio('Start',pahandle);
fprintf('\nSound started playing %.2f seconds after start of script\n',playTime,scriptStart);
%Close the audio driver
PsychPortAudio('Stop', pahandle, 1,0);
PsychPortAudio('Close',pahandle);


%% DAQ toolbox example
%
% %Find the DAQ device number
% devices = PsychHID('devices');
% USBdeviceNum = 0;
% DAQFound = 0;
% for i = 1:length(devices)
%     if strcmp(devices(i).product,'USB-1024LS')
%         USBdeviceNum = i;
%     end
% end
% %Let the user know if we've found it
% if (USBdeviceNum < 1)
% fprintf('ERROR: Could not locate USB device.\n');
% else
%     fprintf('FOUND DAQ DEVICE AT DEVICE %d',USBdeviceNum);
%     DAQFound = 1;
% end
% %Initialize USB box to zero
% if (DAQFound), Daq0ConfigPort(USBdeviceNum,4,0), end;
% %find key code for trigger key, which is a 5
% triggerCode =KbName('5%');
% keyIsDown = 0;
% %Make sure no keys are disabled
% DisableKeysForKbCheck([]);
% %wait for trigger
% while 1
% [ keyIsDown, pressedSecs, keyCode ] = KbCheck(-1);
% if keyIsDown
%     if find(keyCode)==triggerCode
%         break;
%     end
% end
% end
% %Send a pulse to the biopac
% if (DAQFound)
%     DaqDOut(USBdeviceNum,4,255);
%     DaqDOut(USBdeviceNum,4,0);
% end
% %Record trigger time for future reference
% triggerTime = pressedSecs;
% fprintf('Trigger detected\n');

%% IO Port Initialization
try
    fclose(instrfind)
catch
end

porta = serial('COM1', 'BaudRate', 57600, 'DataBits', 8);

fopen(porta);

% when you  want to send event
 eve = 1;    % a number in [0 :255]
 fwrite(porta,eve);

fclose ('all');

%% Eye tracking
%% Connect to Tobii
tobPath='D:\TobiiPro.SDK.Matlab_1.9.0.59';
addpath(genpath(tobPath));
Tobii = EyeTrackingOperations();
eyetracker_address = 'tet-tcp://169.254.122.102';
eyetracker = Tobii.get_eyetracker(eyetracker_address);
if isa(eyetracker,'EyeTracker')
    disp(['Address:',eyetracker.Address]);
    disp(['Name:',eyetracker.Name]);
    disp(['Serial Number:',eyetracker.SerialNumber]);
    disp(['Model:',eyetracker.Model]);
    disp(['Firmware Version:',eyetracker.FirmwareVersion]);
    disp(['Runtime Version:',eyetracker.RuntimeVersion]);
else
    disp('Eye tracker not found!');
end