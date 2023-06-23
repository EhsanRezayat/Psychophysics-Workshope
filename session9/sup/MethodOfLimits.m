function MethodOfLimits(descending)
% Screen('Preference', 'SkipSyncTests', 1);

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
PsychImaging('PrepareConfiguration'); % First step in starting pipeline
PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible');   % set up a 32-bit floatingpoint framebuffer
PsychImaging('AddTask', 'General', 'NormalizedHighresColorRange'); % normalize the color range ([0, 1] corresponds to [min, max])
PsychImaging('AddTask', 'General', 'EnablePseudoGrayOutput'); % enable high gray level resolution output with bitstealing
PsychImaging('AddTask', 'FinalFormatting', 'DisplayColorCorrection', 'SimpleGamma');  % setup Gamma correction method using simple power function for all color channels 
[windowPtr p.ScreenRect] = PsychImaging('OpenWindow', whichScreen, p.ScreenBackground);  % Finishes the setup phase for imaging pipeline, creates an onscreen window, performs all remaining configuration steps
PsychColorCorrection('SetEncodingGamma', windowPtr, 1 / p.ScreenGamma);  % set Gamma for all color channels
HideCursor;  % Hide the mouse cursor

% Get frame rate and set screen font

p.ScreenFrameRate = FrameRate(windowPtr);
Screen('TextFont', windowPtr, 'Times'); 
Screen('TextSize', windowPtr, 24);

%% Experimental Module
p.stimSize = [6 6];      % horizontal and vertical stimulus 
                         % size in visual angle
p.stimDuraion = 0.1;     % stimulus duration in seconds
p.sf = 2 ;               % spatial frequency in cycles/degree
p.ITI = 0.5;             % seconds between trials
if nargin < 1, descending = true; end 
if descending
    respKey = 'down';
    p.startContrast = 0.02; % starting visible grating contrast
    inc = -0.001;        % contrast increment 
else
    respKey = 'up';
    p.startContrast = 0; % starting invisible grating contrast
    inc = 0.001; 
end
keys = {respKey 'esc'};  % allowed response keys
 
% Compute stimulus parameters
ppd = pi / 180 * p.ScreenDistance / p.ScreenHeight * ...
      p.ScreenRect(4);   % pixels per degree
ppc = round(ppd / p.sf); % pixels per cycle
m(1) = round(p.stimSize(1) * ppd / ppc / 2) * ppc * 2; 
                         % horizontal size in pixels
m(2) = round(p.stimSize(2) * ppd); % vertical size in pixels
fixRect = CenterRect([0 0 1 1] * 8, p.ScreenRect); 
                         % 8 x 8 fixation square
p.randSeed = ClockRandSeed; % use clock to set the seed of the
                            % random number generator
 
img = ones(1, m(1) / ppc) * 0.5;
img(1 : 2 : end) = -0.5;
img = Expand(img, ppc, m(2));
 
% Prioritize display to optimize display timing
Priority(MaxPriority(windowPtr));

% Start experiment with instructions
str = ['Use  respKey  arrow to change contrast.\n\n' ...
       'ESC to exit when the stimulus becomes barely ' ...
       'visible.\n\n' 'Press SPACE to start.'];
 DrawFormattedText(windowPtr, str, 'center', 'center', 1);
        % Draw Instruction text string centered in window
Screen('Flip', windowPtr);
WaitTill('space');          % wait till space is pressed
Screen('FillOval', windowPtr, 0, fixRect);   
        % create a black fixation box 
Secs = Screen('Flip', windowPtr);   
        % flip the fixation image into active buffer
p.start = datestr(now);     % record start time

% Run trials until user finds threshold
i = 1;                      % for record
thre = p.startContrast;
while 1
    tex = Screen('MakeTexture', windowPtr, img * thre + 0.5, ...
          0, 0, 2);
    Screen('DrawTexture', windowPtr, tex);
    Screen('FillOval', windowPtr, 0, fixRect); % black fixation
    t0 = Screen('Flip', windowPtr, Secs + p.ITI);  % stim on
    Screen('FillOval', windowPtr, 0, fixRect);
    Screen('Flip', windowPtr, t0 + p.stimDuraion); % stim off
    Screen('Close', tex);
    [key Secs] = WaitTill(keys);    % wait till response
    rec(i, :) = [i thre Secs-t0];   % trial #, contrast,  RT
    i = i + 1;
    if strcmp(key, 'esc'), break; end
    thre = thre + inc;       % increase or decrease contrast
end
p.finish = datestr(now);     % record finish time
save MethodOfLimits_rst.mat rec p;  % save results


%% System Reinstatement Module

Priority(0);  % restore priority
sca; % close window and textures, restore color lookup table
 %%
figure;
plot(rec(:, 1), rec(:, 2) , 'ro-', 'MarkerFaceColor', 'r');
% axis([min(data(:, 1)) max(data(:, 1)) 0 1]);
xlabel('Trials');
ylabel('Thereshold');
title('MethodOfLimits');
end