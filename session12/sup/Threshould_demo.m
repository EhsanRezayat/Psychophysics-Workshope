% Copyright (c) 2013, Massachusetts Institute of Technology
% This program was presented in the book "Visual Psychophysics:
% From Laboratory to Theory" by Zhong-Lin Lu and Barbara Dosher.
% The book is available at http://mitpress.mit.edu/books/visual-psychophysics


function Threshould_demo()


% Clear the workspace
clear vars;
sca;

% Setup PTB with some default values
PsychDefaultSetup(2);
p.ScreenDistance = 30;  % in inches
p.ScreenHeight = 15;    % in inches
p.ScreenGamma = 2;  % from monitor calibration
p.maxLuminance = 100; % from monitor calibration
p.ScreenBackground = 0.5;
 
% Seed the random number generator. Here we use the an older way to be
% compatible with older systems. Newer syntax would be rng('shuffle'). Look
% at the help function of rand "help rand" for more information
rand('seed', sum(100 * clock));

% Set the screen number to the external secondary monitor if there is one
% connected
screenNumber = max(Screen('Screens'));

% Define black, white and grey
white = WhiteIndex(screenNumber);
grey = white / 2;
black = BlackIndex(screenNumber);

% Open the screen
% [window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey, [], 32, 2,...
%     [], [],  kPsychNeed32BPCFloat);

 Screen('Preference', 'SkipSyncTests', 1); 
 [window, windowRect] = Screen('OpenWindow',max(Screen('Screens')),[128 128 128]); % open black window
%  [window, windowRect] = Screen('OpenWindow',max(Screen('Screens')),[128 128 128],[1,1,800, 800]); % open black window

% Flip to clear
Screen('Flip', window);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% Set the text size
Screen('TextSize', window, 40);

% Query the maximum priority level
topPriorityLevel = MaxPriority(window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

%--------------------
% Gabor information
%--------------------

% Dimension of the region where will draw the Gabor in pixels
gaborDimPix = 300;

% Sigma of Gaussian
sigma = gaborDimPix / 7;

% Obvious Parameters
orientation = 90;
contrast = 0.5;
aspectRatio = 1.0;


% Spatial Frequency (Cycles Per Pixel)
% One Cycle = Grey-Black-Grey-White-Grey i.e. One Black and One White Lobe
numCycles = 8;
freq = numCycles / gaborDimPix;

% Build a procedural gabor texture
gabortex = CreateProceduralGabor(window, gaborDimPix, gaborDimPix, [],...
    [0.5 0.5 0.5 0.0], 1, 0.5);

% We will be displaying our Gabors either above or below fixation by 250
% pixels. We therefore have to determine these two locations in screen
% coordianates.
pixShift = 250;
xPos = [xCenter xCenter];
yPos = [yCenter - pixShift yCenter + pixShift];

% Count how many Gabors there are (two for this demo)
nGabors = numel(xPos);

% Make the destination rectangles for  the Gabors in the array i.e.
% rectangles the size of our Gabors cenetred above an below fixation.
baseRect = [0 0 gaborDimPix gaborDimPix];
allRects = nan(4, nGabors);
for i = 1:nGabors
    allRects(:, i) = CenterRectOnPointd(baseRect, xPos(i), yPos(i));
end

% Randomise the phase of the Gabors and make a properties matrix.
phaseLine = rand(1, nGabors) .* 360;
propertiesMat = repmat([NaN, freq, sigma, contrast,...
    aspectRatio, 0, 0, 0], nGabors, 1);
propertiesMat(:, 1) = phaseLine';

% Set the orientations for the methods of constant stimuli. We will center
% the range around zero (vertical) and give it a range of 1.8 degress, this
% will mean we test between -(1.8 / 2) and +(1.8 / 2). Finally we will test
% seven points linearly spaced between these extremes.
baseOrientation = 0;
orRange = 1.9;
numSteps = 7;
stimValues = linspace(-orRange / 2, orRange / 2, numSteps) + baseOrientation;

% Now we set the number of times we want to do each condition, then make a
% full condition vector and then shuffle it. This will randomly order the
% orientation we present our Gabor with on each trial.
numRepeats = 10;
condVector = Shuffle(repmat(stimValues, 1, numRepeats));

% Calculate the number of trials
numTrials = numel(condVector);

% Make a vector to record the response for each trial
respVector = zeros(1, numSteps);

% Make a vector to count how many times we present each stimulus. This is a
% good check to make sure we have done things right and helps us when we
% input the data to plot anf fit our psychometric function
countVector = zeros(1, numSteps);

%----------------------------------------------------------------------
%                       Timing Information
%----------------------------------------------------------------------

% Presentation Time for the Gabor in seconds and frames
presTimeSecs = 0.2;
presTimeFrames = round(presTimeSecs / ifi);

% Interstimulus interval time in seconds and frames
isiTimeSecs = 1;
isiTimeFrames = round(isiTimeSecs / ifi);

% Numer of frames to wait before re-drawing
waitframes = 1;


%----------------------------------------------------------------------
%                       Keyboard information
%----------------------------------------------------------------------

% Define the keyboard keys that are listened for. We will be using the left
% and right arrow keys as response keys for the task and the escape key as
% a exit/reset key
escapeKey = KbName('ESCAPE');
leftKey = KbName('LeftArrow');
rightKey = KbName('RightArrow');


%----------------------------------------------------------------------
%                       Experimental loop
%----------------------------------------------------------------------

% Animation loop: we loop for the total number of trials
for trial = 1:numTrials

    % Get the Gabor angle for this trial (negative values are to the right
    % and positive to the left)
    theAngle = condVector(trial);

    % Randomise the side which the Gabor is displayed on
    side = round(rand) + 1;
    thisDstRect = allRects(:, side);

    % Change the blend function to draw an antialiased fixation point
    % in the centre of the screen
    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

    % If this is the first trial we present a start screen and wait for a
    % key-press
    if trial == 1
        DrawFormattedText(window, 'Press Any Key To Begin', 'center', 'center', black);
        Screen('Flip', window);
        KbStrokeWait;
    end

    % Flip again to sync us to the vertical retrace at the same time as
    % drawing our fixation point
    Screen('DrawDots', window, [xCenter; yCenter], 10, black, [], 2);
    vbl = Screen('Flip', window);

    % Now we present the isi interval with fixation point minus one frame
    % because we presented the fixation point once already when getting a
    % time stamp
    for frame = 1:isiTimeFrames - 1

        % Draw the fixation point
        Screen('DrawDots', window, [xCenter; yCenter], 10, black, [], 2);

        % Flip to the screen
        vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    end

    % Now we draw the Gabor and the fixation point
    for frame = 1:presTimeFrames

        % Set the right blend function for drawing the gabors
        Screen('BlendFunction', window, 'GL_ONE', 'GL_ZERO');

        % Draw the Gabor
        Screen('DrawTextures', window, gabortex, [], thisDstRect, theAngle, [], [], [], [],...
            kPsychDontDoRotation, propertiesMat');

        % Change the blend function to draw an antialiased fixation point
        % in the centre of the array
        Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

        % Draw the fixation point
        Screen('DrawDots', window, [xCenter; yCenter], 10, black, [], 2);

        % Flip to the screen
        vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    end


    % Change the blend function to draw an antialiased fixation point
    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

    % Draw the fixation point
    Screen('DrawDots', window, [xCenter; yCenter], 10, black, [], 2);

    % Flip to the screen
    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

    % Now we wait for a keyboard button signaling the observers response.
    % The left arrow key signals a "left" response and the right arrow key
    % a "right" response. You can also press escape if you want to exit the
    % program
    respToBeMade = true;
    while respToBeMade
        [keyIsDown,secs, keyCode] = KbCheck;
        if keyCode(escapeKey)
            ShowCursor;
            sca;
            return
        elseif keyCode(leftKey)
            response = 1;
            respToBeMade = false;
        elseif keyCode(rightKey)
            response = 0;
            respToBeMade = false;
        end
    end

    % Record the response
    respVector(stimValues == theAngle) = respVector(stimValues == theAngle)...
        + response;

    % Add one to the counter for that stimulus
    countVector(stimValues == theAngle) = countVector(stimValues == theAngle) + 1;

end

rec = [stimValues; respVector; countVector]';
path_ = cd;
path_ =[path_ '\sup\'];
save ([path_,'Threshould_demo.mat'], 'rec', 'p');  % save results

% Clean up
sca;
%% Analysis data
path_ = cd;
path_ =[path_ '\sup\'];
load ([path_,'Threshould_demo.mat']);  % load results
 
figure;
plot(rec(:, 1), rec(:, 2) ./ rec(:, 3), 'ro-', 'MarkerFaceColor', 'r');
axis([min(rec(:, 1)) max(rec(:, 1)) 0 1]);
xlabel('Angle of Orientation (Degrees)');
ylabel('Performance');
title('Psychometric function');

