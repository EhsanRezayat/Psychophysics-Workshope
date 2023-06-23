%% %%%%%%   In the name of God, the most gracious, the most merciful %%%%%%
%% MATLAB for Brain and Cognitive Psychology Workshope 2023
% Ehsan Rezayat, Ph.D.
% Faculty of Psychology and Education, University of Tehran,
% Institute for Research in Fundamental Sciences (IPM), School of Cognitive Sciences,
% rezayat@ut.ac.ir, rezayat@ipm.ir, erezayat.er@gmail.com
% Contributed by: Amir.M Mousavi.H, Helia Thaghavi & Fatemeh Fallah
% Amir.harris@sru.ac.ir   heliabsb@gmail.com  fh.fallah90@gmail.com
% last edition : 02/11/2023

%% session #10 Timing control
close all;
clear all;
clc;

path_code = cd;
addpath(genpath([path_code '\sup']))


%% Priority
whichScreen = max(Screen('Screens'));
maxPriorityLevel = MaxPriority(whichScreen);
Priority(maxPriorityLevel);
if IsOSX
    fprintf('Your operating system is OSX and it''s Priority levels range from 0-9\n');
elseif IsWindows
    fprintf('Your operating system is Windows and it''s Priority levels range from 0-2\n');
    
end
%% Control timing of task
tic1= tic;
WaitSecs(3)
toc(tic1)

start_time = GetSecs();

present_time = GetSecs()-start_time;

%% Timing

t_now=GetSecs;

WaitSecs(1)

dur =GetSecs-t_now ;


%% Example task with WaitSecs
Screen('Preference', 'SkipSyncTests', 1);
[wPtr, rect] = Screen('OpenWindow',max(Screen('Screens')),[128 128 128]);  %open the screen
[x,  y]  = meshgrid(-128:127,  128:-1:-127);
M        = 127*(1- ((y == 0 & x > -15 & x < 15)|(x == 0 & y > -15 & y < 15 ))) + 1;
fixation = Screen('MakeTexture',wPtr,M); %texture for fixation cross
fixRect  = [0 0 rect(3)/3 rect(3)/3 ]; % creating a rectangle where fixation cross is presented on screen
fixRect  = CenterRect(fixRect,rect); % locate the fixRect at center of screen
sSc      = 100; 
rectStim = [0 0 sSc sSc]; % creating a rectangle where stimulus is presented on screen
rectStim = CenterRect(rectStim, rect); % locate the rectStim at center of screen
stimulus = zeros(1,14); % creating a matrix for 14 facial expression texture

%
TrialNumber = 3;
fix_time = 1;
stim_time = 1;
del_time =0.5;
faceData=imread('sadface.jpg');
faceTexture=Screen('MakeTexture',wPtr,faceData);
for TrialNum = 1:TrialNumber
    t_start   = GetSecs;    
        
    % showing fixation point
    Screen('DrawTexture',wPtr,fixation,[],fixRect);    
    vbl = Screen('Flip', wPtr);  
    WaitSecs(fix_time)
   
        
     % showing stimulus 
    Screen('DrawTexture',wPtr,faceTexture,[],rectStim);
    vbl = Screen('Flip', wPtr);
    WaitSecs(stim_time)
    
    % showing fixation point for delay
    Screen('DrawTexture',wPtr,fixation,[],fixRect);
    vbl                = Screen('Flip', wPtr);
    WaitSecs(del_time)
    exist_code = KbName('esc');
    
        
    % Wait for response
    KbWait();
    [keyIsDown, pressedSecs, keyCode ] = KbCheck(-1);
    if keyIsDown
        
        if find(keyCode)== exist_code
            
            break;
        end
    end
    
end
clear Screen


%% Example task with state based
Screen('Preference', 'SkipSyncTests', 1);
[wPtr, rect] = Screen('OpenWindow',max(Screen('Screens')),[128 128 128]);  %open the screen
[x,  y]  = meshgrid(-128:127,  128:-1:-127);
M        = 127*(1- ((y == 0 & x > -15 & x < 15)|(x == 0 & y > -15 & y < 15 ))) + 1;
fixation = Screen('MakeTexture',wPtr,M); %texture for fixation cross
fixRect  = [0 0 rect(3)/3 rect(3)/3 ]; % creating a rectangle where fixation cross is presented on screen
fixRect  = CenterRect(fixRect,rect); % locate the fixRect at center of screen
sSc      = 100;
rectStim = [0 0 sSc sSc]; % creating a rectangle where stimulus is presented on screen
rectStim = CenterRect(rectStim, rect); % locate the rectStim at center of screen
stimulus = zeros(1,14); % creating a matrix for 14 facial expression texture

%
TrialNumber = 3;
fix_time = 1;
stim_time = 1;
del_time =0.5;
faceData=imread('sadface.jpg');
faceTexture=Screen('MakeTexture',wPtr,faceData);
for TrialNum = 1:TrialNumber
    t_start   = GetSecs;
    trial_end = 0;state = 0;
    while ~trial_end
        
        % showing fixation point
        if state== 0
            Screen('DrawTexture',wPtr,fixation,[],fixRect);
            vbl = Screen('Flip', wPtr);
            state =1;
            t_elapsed = GetSecs;
        elseif state== 1 && GetSecs-t_elapsed>fix_time
            state = 2;
            % showing stimulus
            Screen('DrawTexture',wPtr,faceTexture,[],rectStim);
            vbl = Screen('Flip', wPtr);
            t_elapsed = GetSecs;
            
        elseif state== 2 && GetSecs-t_elapsed>stim_time
            state = 3;
            
            % showing fixation point for delay
            Screen('DrawTexture',wPtr,fixation,[],fixRect);
            vbl                = Screen('Flip', wPtr);
            t_elapsed = GetSecs;
            
        elseif state== 3 && GetSecs-t_elapsed>del_time
            state = 4;
            exist_code = KbName('esc');
            
            
            % Wait for response
            KbWait();
            [keyIsDown, pressedSecs, keyCode ] = KbCheck(-1);
            if keyIsDown
                
                if find(keyCode)== exist_code
                    
                    break;
                end                
                trial_end = 1;
            end 
        end
        
    end
end
clear Screen


%% Shuffeling Trials
nContrast = 7;
repeats   = 15;
% initialize trial numbers from 1 to nTrials
contrastIndex = repmat(1 : nContrast, repeats, 1);
% use repmat to cycle thru contrast #s
Cond_trilas  = Shuffle(contrastIndex(:));

Cond_trilas  = randsample(contrastIndex(:),nContrast*repeats);

% rng
%
randi(10,10,1)
randperm(10,5)
%
f=1:100;
Shuffle(f)
%%
seleted= randperm(10,2);
reminded_item= setdiff([1:10],seleted);
seleted2= reminded_item(randperm(8,2))

%% Other Example codes
% RandSample()
% ChooseKFromN(100,200)
% RandSel()
% URandSel()
% CoinFlip()


