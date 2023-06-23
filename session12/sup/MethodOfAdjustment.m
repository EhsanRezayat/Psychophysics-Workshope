% Copyright (c) 2013, Massachusetts Institute of Technology
% This program was presented in the book "Visual Psychophysics:
% From Laboratory to Theory" by Zhong-Lin Lu and Barbara Dosher.
% The book is available at http://mitpress.mit.edu/books/visual-psychophysics

%%% Program MethodOfAdjustment.m
function MethodOfAdjustment()

%% Display Setup Module

% Define display parameters

whichScreen = max(Screen('screens'));
p.ScreenDistance = 30; 	% in inches
p.ScreenHeight = 15; 	% in inches
p.ScreenGamma = 2;	% from monitor calibration
p.maxLuminance = 100; % from monitor calibration
p.ScreenBackground = 0.5;

% Open the display window and hide the mouse cursor

if exist('onCleanup', 'class'), oC_Obj = onCleanup(@()sca); end % close any pre-existing PTB Screen window
%Prepare setup of imaging pipeline for onscreen window. 
% PsychImaging('PrepareConfiguration'); % First step in starting pipeline
% PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible');   % set up a 32-bit floatingpoint framebuffer
% PsychImaging('AddTask', 'General', 'NormalizedHighresColorRange'); % normalize the color range ([0, 1] corresponds to [min, max])
% PsychImaging('AddTask', 'General', 'EnablePseudoGrayOutput'); % enable high gray level resolution output with bitstealing
% PsychImaging('AddTask', 'FinalFormatting', 'DisplayColorCorrection', 'SimpleGamma');  % setup Gamma correction method using simple power function for all color channels 
% [windowPtr p.ScreenRect] = PsychImaging('OpenWindow', whichScreen, p.ScreenBackground,[1 1 1900 1000]);  % Finishes the setup phase for imaging pipeline, creates an onscreen window, performs all remaining configuration steps
% PsychColorCorrection('SetEncodingGamma', windowPtr, 1 / p.ScreenGamma);  % set Gamma for all color channels
 Screen('Preference', 'SkipSyncTests', 1); 
 [windowPtr, p.ScreenRect] = Screen('OpenWindow',max(Screen('Screens')),[128 128 128]); % open black window

HideCursor;  % Hide the mouse cursor

% Get frame rate and set screen font

p.ScreenFrameRate = FrameRate(windowPtr);
Screen('TextFont', windowPtr, 'Times'); 
Screen('TextSize', windowPtr, 24);

%% Experimental Module

% Specify the stimulus
p.stimSize = [6 6];          % horizontal and vertical 
                             % stimulus size in visual angle
p.sf = 1 ; % spatial frequency in cycles/degree
p.contrast = [1 2] * 0.3;    % target and test contrasts
p.dist = 2;                  % distance between edges of the 
                             % two stim in degrees
keys = {'up' 'down' 'esc'};  % keys to respond and break
 
% Compute stimulus parameters
 ppd = pi / 180 * p.ScreenDistance / p.ScreenHeight * ...
      p.ScreenRect(4);      % pixels per degree
ppc = round(ppd / p.sf);     % pixels per cycle
m(1) = round(p.stimSize(1) * ppd); % horizontal size in pixels
m(2) = round(p.stimSize(2) * ppd / ppc / 2) * ppc * 2; 
                             % vertical size in pixels
sf = p.sf / ppd;             % cycles per pixel
rect = CenterRect([0 0 m], p.ScreenRect);
xOffset = p.dist * ppd / 2 + m(1) / 2;
rect1 = OffsetRect(rect, -xOffset, 0); % target stim rect
rect2 = OffsetRect(rect, xOffset, 0);  % tesst stim rect
params1 = [0 sf p.contrast(1) 0]; 
        % parameters for target stim: phase, sf, contrast
params2 = [0 sf p.contrast(2) 0];  % parameters for test stim
% p.randSeed = ClockRandSeed;  % use clock to set random number
                             % generator
 
% Procedural sinewavegrating allows us to change its 
% parameters very quickly
 tex = CreateProceduralSineGrating(windowPtr, m(1), m(2), ...
       [1 1 1 0] * 0.5, [], 0.5);
 
% Prioritize display to optimize display timing
Priority(MaxPriority(windowPtr));
 
% Start experiment with instructions
str=['Use Up/Down arrow keys to increase/decrease the ' ...
     'contrast of the grating on right\n\n' 'Press ESC to ' ...
     'exit when both gratings have the same contrast.\n\n' ...
     'Press SPACE to start.'];
 DrawFormattedText(windowPtr, str, 'center', 'center', 1);
        % Draw Instruction text string centered in window
Screen('Flip', windowPtr);
WaitTill('space');           % wait till space is pressed
Screen('Flip', windowPtr);  % turn off instruction
p.start = datestr(now);     % record start time

% Run trials until user finds threshold
i = 1;                      % initial record #
while 1    
    Screen('DrawTexture', windowPtr, tex, [], rect1, 90, [], ...
           [], [], [], [], params1);
    Screen('DrawTexture', windowPtr, tex, [], rect2, 90, [], ...
           [], [], [], [], params2);
    t0 = Screen('Flip', windowPtr); % update contrast
    KbReleaseWait;          % avoid continous change by single 
                            % key press
    [key Secs] = WaitTill(keys);       % wait till response
    rec(i, :) = [i params2(3) Secs-t0]; 
    i = i + 1;
    if strcmp(key, 'up')
        params2(3) = params2(3) * 1.1; % increase contrast
    elseif strcmp(key, 'down')
        params2(3) = params2(3) / 1.1; % decrease contrast
    else
        break;
    end
end
p.finish = datestr(now);               % record finish time



%% System Reinstatement Module

Priority(0);  % restore priority
sca; % close window and textures, restore color lookup table
path_ = cd;
path_ =[path_ '\sup\'];
save ([path_,'MethodOfAdjustment_rst.mat'], 'rec', 'p');  % save results

%%
%%
clear all
path_ = cd;
path_ =[path_ '\sup\'];
load ([path_,'MethodOfAdjustment_rst.mat']);  % load results
 
figure
hold on
plot(rec(:,1),rec(:,2))
xlabel('trail number (#)')
ylabel('contrast (a.u.)')
line(xlim,[p.contrast(1) p.contrast(1)],'color','r')
% figure
% plot(rec(:,1),rec(:,3))
% xlabel('trail number (#)')
% ylabel('RT (sec.)')
