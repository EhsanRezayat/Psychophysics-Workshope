% Clear the workspace
function stroob_test()
close all;
clearvars;
sca;

% Setup PTB with some default values
%  PsychDefaultSetup(2);

% Seed the random number generator. Here we use the an older way to be
% compatible with older systems. Newer syntax would be rng('shuffle'). Look
% at the help function of rand "help rand" for more information
% rand('seed', sum(100 * clock));

% Set the screen number to the external secondary monitor if there is one
% connected
screenNumber = max(Screen('Screens'));

% Define black, white and grey
white = WhiteIndex(screenNumber);
grey = white / 2;
black = BlackIndex(screenNumber);

% Open the screen
% [window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey, [1 1 1900 1000], 32, 2);
Screen('Preference', 'SkipSyncTests', 1);
[window, windowRect] = Screen('OpenWindow',max(Screen('Screens')),[128 128 128]); % open black window

% Flip to clear
Screen('Flip', window);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% Set the text size
Screen('TextSize', window, 60);

% Query the maximum priority level
topPriorityLevel = MaxPriority(window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Set the blend funciton for the screen
% Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

try
    %----------------------------------------------------------------------
    %                       Timing Information
    %----------------------------------------------------------------------
    
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
    KbName('UnifyKeyNames')
    escapeKey = KbName('ESCAPE');
    leftKey = KbName('LeftArrow');
    rightKey = KbName('RightArrow');
    downKey = KbName('DownArrow');
    
    
    %----------------------------------------------------------------------
    %                     Colors in words and RGB
    %----------------------------------------------------------------------
    
    % We are going to use three colors for this demo. Red, Green and blue.
    wordList = {'Red', 'Green', 'Blue'};
    rgbColors = [1 0 0; 0 1 0; 0 0 1];
    
    % Make the matrix which will determine our condition combinations
    condMatrixBase = [sort(repmat([1 2 3], 1, 3)); repmat([1 2 3], 1, 3)];
    
    % Number of trials per condition. We set this to one for this demo, to give
    % us a total of 9 trials.
    trialsPerCondition = 3;
    
    % Duplicate the condition matrix to get the full number of trials
    condMatrix = repmat(condMatrixBase, 1, trialsPerCondition);
    
    % Get the size of the matrix
    [~, numTrials] = size(condMatrix);
    
    % Randomise the conditions
    shuffler = Shuffle(1:numTrials);
    condMatrixShuffled = condMatrix(:, shuffler);
    
    
    %----------------------------------------------------------------------
    %                     Make a response matrix
    %----------------------------------------------------------------------
    
    % This is a four row matrix the first row will record the word we present,
    % the second row the color the word it written in, the third row the key
    % they respond with and the final row the time they took to make there response.
    respMat = nan(4, numTrials);
    
    
    %----------------------------------------------------------------------
    %                       Experimental loop
    %----------------------------------------------------------------------
    
    % Animation loop: we loop for the total number of trials
    for trial = 1:numTrials
        
        % Word and color number
        wordNum = condMatrixShuffled(1, trial);
        colorNum = condMatrixShuffled(2, trial);
        
        % The color word and the color it is drawn in
        theWord = wordList(wordNum);
        theColor = rgbColors(colorNum, :);
        
        % Cue to determine whether a response has been made
        respToBeMade = true;
        
        % If this is the first trial we present a start screen and wait for a
        % key-press
        if trial == 1
            DrawFormattedText(window, 'Name the color \n\n Press Any Key To Begin',...
                'center', 'center', black);
            Screen('Flip', window);
            KbStrokeWait;
        end
        
        % Flip again to sync us to the vertical retrace at the same time as
        % drawing our fixation point
        Screen('DrawDots', window, [xCenter; yCenter], 10, black, [], 2);
         Screen('Flip', window);
        
        % Now we present the isi interval with fixation point minus one frame
        % because we presented the fixation point once already when getting a
        % time stamp
        for frame = 1:isiTimeFrames - 1
            
            % Draw the fixation point
            Screen('DrawDots', window, [xCenter; yCenter], 10, black, [], 2);
            WaitSecs((waitframes - 0.5) * ifi)
            % Flip to the screen
            Screen('Flip', window);
        end
        
        % Now present the word in continuous loops until the person presses a
        % key to respond. We take a time stamp before and after to calculate
        % our reaction time. We could do this directly with the vbl time stamps,
        % but for the purposes of this introductory demo we will use GetSecs.
        %
        % The person should be asked to respond to either the written word or
        % the color the word is written in. They make thier response with the
        % three arrow key. They should press "Left" for "Red", "Down" for
        % "Green" and "Right" for "Blue".
        tStart = GetSecs;
        while respToBeMade == true
            
            % Draw the word
            DrawFormattedText(window, char(theWord), 'center', 'center', theColor);
            %           [newX,newY,textHeight]=Screen('DrawText', window,  char(theWord),xCenter, yCenter ,theColor);
            Screen('Flip',window);
            % Check the keyboard. The person should press the
            [keyIsDown,secs, keyCode] = KbCheck;
            if keyCode(escapeKey)
                ShowCursor;
                sca;
                return
            elseif keyCode(leftKey)
                response = 1;
                respToBeMade = false;
            elseif keyCode(downKey)
                response = 2;
                respToBeMade = false;
            elseif keyCode(rightKe9y)
                response = 3;
                respToBeMade = false;
            end
            
            % Flip to the screen
            %         WaitSecs((waitframes - 0.5) * ifi);
            %
            %         Screen('Flip', window);
        end
        tEnd = GetSecs;
        rt = tEnd - tStart;
        
        % Record the trial data into out data matrix
        respMat(1, trial) = wordNum;
        respMat(2, trial) = colorNum;
        respMat(3, trial) = response;
        respMat(4, trial) = rt;
        
    end
    
    % End of experiment screen. We clear the screen once they have made their
    % response
    % DrawFormattedText(window, 'Experiment Finished \n\n Press Any Key To Exit',...
    %     'center', 'center', black);
    Screen('Flip', window);
    KbStrokeWait;
    sca;
    respMat = respMat';
    save StroopTask_rst.mat respMat;
    
    %%
    clear all
    load StroopTask_rst.mat
    word_name = respMat(:,1);
    color_name = respMat(:,2);
    bhv = respMat(:,3);
    performance = [];
    conditions = unique(color_name);
    for ci = 1: length(conditions)
        ind_h = ismember(color_name,conditions(ci));
        
        performance(ci) = sum(ind_h&bhv==color_name)/sum(ind_h)*100 ;
        RT_cr (ci) = nanmean(respMat(ind_h&(bhv==color_name),4));
        RT_wr (ci) = nanmean(respMat(ind_h&(bhv~=color_name),4));
        
    end
    figure
    hold on
    bar(conditions,performance)
    xlabel('Contrast (a.u.)')
    ylabel('Performance (%)')
    
    figure
    subplot(121)
    hold on
    bar(conditions,RT_cr,'g')
    subplot(122)
    hold on
    bar(conditions,RT_wr,'b')
    xlabel('Contrast (a.u.)')
    ylabel('RT (sec.)')
    %%
    conditions = unique(color_name);
    
    
    RT_match  = nanmean(respMat((word_name==color_name),4));
    RT_nonmath  = nanmean(respMat((word_name~=color_name),4));
    
    
    figure
    
    hold on
    bar([RT_match RT_nonmath ] ,'g')
catch
    sca
    y=1;
end