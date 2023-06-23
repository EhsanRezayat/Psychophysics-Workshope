function MethodOfConstantStimuli
%% Display Setup Module
% Define display parameters
Screen('Preference', 'SkipSyncTests', 1); 
whichScreen = max(Screen('screens'));
p.ScreenDistance = 30;  % in inches
p.ScreenHeight = 15;    % in inches
p.ScreenGamma = 2;  % from monitor calibration
p.maxLuminance = 100; % from monitor calibration
p.ScreenBackground = 0.5;

% Open the display window, setup lookup table, and hide the mouse cursor

if exist('onCleanup', 'class'), oC_Obj = onCleanup(@()sca); end % close any pre-existing PTB Screen window
%Prepare setup of imaging pipeline for onscreen window.
PsychImaging('PrepareConfiguration'); % First step in starting pipeline
PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible');   % set up a 32-bit floatingpoint framebuffer
PsychImaging('AddTask', 'General', 'NormalizedHighresColorRange'); % normalize the color range ([0, 1] corresponds to [min, max])
PsychImaging('AddTask', 'General', 'EnablePseudoGrayOutput'); % enable high gray level resolution output with bitstealing
PsychImaging('AddTask', 'FinalFormatting', 'DisplayColorCorrection', 'SimpleGamma');  % set up Gamma correction method using simple power function for all color channels
[windowPtr p.ScreenRect] = PsychImaging('OpenWindow', whichScreen, p.ScreenBackground);  % Finishes the setup phase for imaging pipeline, creates an onscreen window, performs all remaining configuration steps
PsychColorCorrection('SetEncodingGamma', windowPtr, 1 / p.ScreenGamma);  % set Gamma for all color channels
%  HideCursor;  % Hide the mouse cursor

% Get frame rate and set screen font
p.ScreenFrameRate = FrameRate(windowPtr); % get current frame rate
Screen('TextFont', windowPtr, 'Times'); % set the font for the screen to Times
Screen('TextSize', windowPtr, 24); % set the font size for the screen to 24

%% Experimental Module

% Specify general experimental parameters
nContrast = 7;     % number of contrast levels in experiment
repeats = 5 ;     % number of trials to repeat for each contrast
nTrials = repeats * nContrast;
% compute total number of trials
p.randSeed = ClockRandSeed;
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
save MethodofConstantStimuli_rst.mat rec p;
% save the results


%% System Reinstatement Module

Priority(0);  % restore priority
sca; % close window and textures, restore color lookup table
%% preview response
load MethodofConstantStimuli_rst.mat
rec = rec(~isnan(rec(:,3)),:);
cntr = unique(rec(:, 2));
prb = [];
for i = 1: length(cntr)
    prb(i) = sum(rec(:, 2) == cntr(i) & rec(:, 3) == 1) / sum(rec(:, 2) == cntr(i));
end
figure;
plot(cntr, prb , 'ro-', 'MarkerFaceColor', 'r');
% line(xlim,[params1(3) params1(3)])
%  axis([min(rec(:, 1)) rec(data(:, 1)) 0 1]);
xlabel('Intesisty');
ylabel('Precennt of correct');
title('Psychmetric function');
end