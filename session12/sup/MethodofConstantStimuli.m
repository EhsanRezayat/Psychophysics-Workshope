% Copyright (c) 2013, Massachusetts Institute of Technology
% This program was presented in the book "Visual Psychophysics:
% From Laboratory to Theory" by Zhong-Lin Lu and Barbara Dosher.
% The book is available at http://mitpress.mit.edu/books/visual-psychophysics

%%% Program MethodofConstantStimuli.m2
function MethodofConstantStimuli(repeats)

%% Display Setup Module
% Define display parameters
whichScreen = max(Screen('screens'));
p.ScreenDistance = 30;  % in inches
p.ScreenHeight = 15;    % in inches
p.ScreenGamma = 2;  % from monitor calibration
p.maxLuminance = 100; % from monitor calibration
p.ScreenBackground = 0.5;
 
% Open the display window, setup lookup table, and hide the mouse cursor

if exist('onCleanup', 'class'), oC_Obj = onCleanup(@()sca); end % close any pre-existing PTB Screen window
%Prepare setup of imaging pipeline for onscreen window. 
% PsychImaging('PrepareConfiguration'); % First step in starting pipeline
% PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible');   % set up a 32-bit floatingpoint framebuffer
% PsychImaging('AddTask', 'General', 'NormalizedHighresColorRange'); % normalize the color range ([0, 1] corresponds to [min, max])
% PsychImaging('AddTask', 'General', 'EnablePseudoGrayOutput'); % enable high gray level resolution output with bitstealing
% PsychImaging('AddTask', 'FinalFormatting', 'DisplayColorCorrection', 'SimpleGamma');  % set up Gamma correction method using simple power function for all color channels 
% [windowPtr p.ScreenRect] = PsychImaging('OpenWindow', whichScreen, p.ScreenBackground,[1 1 1900 1000]);  % Finishes the setup phase for imaging pipeline, creates an onscreen window, performs all remaining configuration steps
 Screen('Preference', 'SkipSyncTests', 1); 
 [windowPtr, p.ScreenRect] = Screen('OpenWindow',max(Screen('Screens')),[128 128 128]); % open black window

% PsychColorCorrection('SetEncodingGamma', windowPtr, 1 / p.ScreenGamma);  % set Gamma for all color channels
HideCursor;  % Hide the mouse cursor
1
% Get frame rate and set screen font
p.ScreenFrameRate = FrameRate(windowPtr); % get current frame rate
Screen('TextFont', windowPtr, 'Times'); % set the font for the screen to Times
Screen('TextSize', windowPtr, 24); % set the font size for the screen to 24

%% Experimental Module

% Specify general experimental parameters
nContrast = 7;     % number of contrast levels in experiment
if nargin < 1, repeats = 5;  end   % number of trials to repeat for each contrast
nTrials = repeats * nContrast;  
                   % compute total number of trials
% p.randSeed = ClockRandSeed;     
                   % use clock to set random number generator
keys = {'1' '2' 'esc'};   % specify response keys for yes, 
                          % no and to break

% Specify the stimulus
p.stimSize = 6;    % image diameter in visual degree
p.sf = 1;          % spatial frequency in cycle/degree
conRange = [0.0025 0.04]; % lowest and highest tested 
                          % contrasts
p.stimDuration = 0.1;     % stimulus duration in seconds
p.ISI = 0.5;       % seconds between trials

% Compute stimulus parameters
ppd = pi/180 * p.ScreenDistance / p.ScreenHeight * ...
      p.ScreenRect(4);    % compute pixels per degree from
                   % p.ScreenDistance and p.ScreenHeight
m = round(p.stimSize * ppd /2) * 2;     
                   % stimulus size in pixels
fixRect = CenterRect([0 0 1 1] * 8, p.ScreenRect);  
                   % define an 8 x 8 pixel fixation 
% create another fixation stimulus of horizontal and vertical % cross hairs outside the area of the sine wave pattern
fixLen = 32;       % length of fixation in pixels
fixXY = [[-1 0 0 1]*fixLen + [-1 -1 1 1 ] * m/2 + ...
        p.ScreenRect(3)/2 [1 1 1 1] * p.ScreenRect(3)/2; ...
        [1 1 1 1]*p.ScreenRect(4)/2 [-1 0 0 1]*fixLen + ...
        [-1 -1 1 1 ]*m/2 + p.ScreenRect(4) / 2]; 

p.contrasts = logspace(log10(conRange(1)), log10(conRange(2)), nContrast);   
        % use logspace function to choose nContrast contrasts
        % (7) at log intervals between the minimum and 
        % maximum specified contrasts
sf = p.sf / ppd;   % compute spatial frequency in cycles 
                   % per pixel
tex = CreateProceduralSineGrating(windowPtr, m, m, ...
      [[1 1 1]*p.ScreenBackground 0], m/2, 0.5);
      % "CreateProceduralSineGrating" is a psychtoolbox 
      % function to create a procedural texture for drawing
      % sine grating stimulus patches on the GPU

% Initialize a table to set up experimental conditions
p.recLabel = {'trialIndex' 'contrastIndex' 'anserYes' ...
      'respTime'}; % labels of the columns of the data
                   %  recording array rec
rec = nan(nTrials, length(p.recLabel)); 
        % matrix rec is initialized as an nTrials x 5 of NaN
rec(:, 1) = 1 : nTrials;     
        % initialize trial numbers from 1 to nTrials
contrastIndex = repmat(1 : nContrast, repeats, 1); 
        % use repmat to cycle thru contrast #s
rec(:, 2) = Shuffle(contrastIndex(:)); 
        % shuffle contrast indexes to randomize
 
% Prioritize display to optimize display timing
Priority(MaxPriority(windowPtr));

% Start experiment with instructions
str = sprintf('Press 1 for stimulus present, 2 for absent.\n\n Press SPACE to start.');
DrawFormattedText(windowPtr, str, 'center', 'center', 1);
      % Draw Instruction text string centered in window
Screen('Flip', windowPtr); 
      % flip the text image into active buffer
WaitTill('space');      
      % wait till space bar is pressed
Screen('FillOval', windowPtr, 0, fixRect);   
      % create a black fixation dot
Secs = Screen('Flip', windowPtr);   
      % flip the fixation image into active buffer
p.start = datestr(now);        % record start time
 
% Run nTrials trials
for i = 1 : nTrials
    con = p.contrasts(rec(i, 2));  % use contrast index from 
                   % rec to set contrast for this trial    
    Screen('DrawTexture', windowPtr, tex, [], [], 0, [], ...
           [], [], [], [], [180 sf con 0]);
        % draw the sine grating with phase 180, spatial 
        % frequency, and contrast
    Screen('DrawLines', windowPtr, fixXY, 3, 0.3);  
        % add the fixation crosshairs
    t0 = Screen('Flip', windowPtr, Secs + p.ISI); 
        % show the stimulus and return the time 
    Screen('Flip', windowPtr, t0 + p.stimDuration);
        % turn off the stimulus by flipping to background
      % image after p.stimDuration secs        
      Screen('FillOval', windowPtr, 0, fixRect); 
      % draw the smaller centered fixation
    Screen('Flip', windowPtr, t0 + 0.25 + p.stimDuration);
      % show small fixation briefly to cue the observer to
      % respond with the interval        
    [key Secs] = WaitTill(keys);   
      % wait for response, return key and response time
    if iscellstr(key), key = key{1}; end 
      % take the first response in case of multiple 
      % key presses
    if strcmp(key, 'esc'), break; end 
      % check if response is <escape> to stop experiment
    rec(i, 3 : 4) = [strcmp(key, '1') Secs-t0]; 
      % record answer and respTime
end
 
p.finish = datestr(now); % record finish time


%% System Reinstatement Module

Priority(0);  % restore priority
sca; % close window and textures, restore color lookup table
path_ = cd;
path_ =[path_ '\sup\'];
save ([path_,'MethodofConstantStimuli_rst.mat'], 'rec', 'p');  % save results

%%
clear all
path_ = cd;
path_ =[path_ '\sup\'];
load ([path_,'MethodofConstantStimuli_rst.mat']);  % load results
 
cci = rec(:,2);
bhv = rec(:,3);
performance = [];
conditions = unique(cci);
for ci = 1: length(conditions)
    ind_h = ismember(rec(:,2),conditions(ci));
    
   performance(ci) = sum(ind_h&bhv)/sum(ind_h)*100 ;
   RT_cr (ci) = nanmean(rec(ind_h&bhv,4));
   RT_wr (ci) = nanmean(rec(ind_h&(~bhv),4));

end
figure
hold on
plot(p.contrasts,performance)
xlabel('Contrast (a.u.)')
ylabel('Performance (%)')

figure
hold on
plot(conditions,RT_cr,'g')
plot(conditions,RT_wr,'b')
xlabel('Contrast (a.u.)')
ylabel('RT (sec.)')
