%% %%%%%%   In the name of God, the most gracious, the most merciful %%%%%%
%% MATLAB for Brain and Cognitive Psychology Workshope 2023
% Ehsan Rezayat, Ph.D.
% Faculty of Psychology and Education, University of Tehran,
% Institute for Research in Fundamental Sciences (IPM), School of Cognitive Sciences,
% rezayat@ut.ac.ir, rezayat@ipm.ir, erezayat.er@gmail.com 
% Contributed by: Amir.M Mousavi.H, Helia Thaghavi & Fatemeh Fallah
% Amir.harris@sru.ac.ir   heliabsb@gmail.com  fh.fallah90@gmail.com
% last edition : 02/11/2023

%% session #6 Presentation Stimuli  

path_code = cd;
addpath(genpath([path_code '\sup']))

%% Psychtoolbox testing

PsychtoolboxVersion % shows your psychtoolbox version

% UpdatePsychtoolbox  % updates your psychtoolbox version

help PsychDemos  % shows your psychtoolbox demos

Screen('Preference', 'SkipSyncTests', 1);
% KbDemo % keyboard demo

%% Screen Test
ScreenTest()  % Screen Test --> after running the code press 0 to test your screen

%% Tests Sync
ScreenNumber=max(Screen('Screens'));
[windowPtr,rect]=Screen('OpenWindow',ScreenNumber);

% VBLSyncTest() % Tests Sync
pause

clear Screen;
%%  Perceptual VBL Sync Test
PerceptualVBLSyncTest() % Perceptual VBL Sync Test
%%instructions on how  to install the kernel driver
help PsychtoolboxKernelDriver % instructions on how to install the kernel driver

%% The Screen command
help Screen % Screen() is the heart of Psychtoolbox

%% The Screen command
% Screen('OpenWindow?')
%For explanation of any particular screen function, just add a question
% mark "?". E.g. for 'OpenWindow'--> Screen OpenWindow?

%%
Screen()

%% The Screen command
Screen DrawLine?

%% Using the Screen command
Screen('Preference', 'SkipSyncTests', 1);
Screen('Screens')

max(Screen('Screens'))

ScreenNumber=max(Screen('Screens'));
[windowPtr,rect]=Screen('OpenWindow',ScreenNumber);

%% Flip screen
% flipTime
Screen('Preference', 'SkipSyncTests', 1);
wPtr = Screen('OpenWindow',max(Screen('Screens')));
Screen('Flip',wPtr);
pause

clear Screen;

%% Time
Screen('Preference', 'SkipSyncTests', 1);
wPtr = Screen('OpenWindow',max(Screen('Screens')));
now = GetSecs();
aLittleLater = GetSecs();
gap = aLittleLater - now;

VBLtime = Screen('Flip',wPtr, [gap], [0]); % when: you can specify a time in the future for the flip to take place

pause

clear Screen;                                                    %    dontclear: Default is to clear the back buffer.  However in some cases you may want to leave the back buffer as is.  Default is 0, set to 1 if you don't want it to clear.

%% Using Screen -> drawSomething()
Screen('Preference', 'SkipSyncTests', 1);

 [wPtr, rect] = Screen('OpenWindow',max(Screen('Screens')));  %open the screen
% [wPtr, rect] = Screen('OpenWindow',max(Screen('Screens')),[128 128 128],[0 0 1900 800]);  %open the screen
 
Screen('FillRect', wPtr, [128 0 128],[100 200 500 500]);      %draw a rectangle on the back buffer
Screen('Flip',wPtr);  %flip the buffers
% KbWait();              %wit until key pressed
 WaitSecs(2)
clear Screen;

%% WaitSecs(s)
%
% WaitSecs('UntilTime',when)
%
% KbWait()

%% KbWait
[secs, keyCode, deltaSecs] = KbWait()  % keyCode is a vector of all the keys, with a 1 for any key that was pressed.

%find(keyCode) will return the index of the button(s) pressed.

%That code can then be turned into a character using KbName()

%% KbWait Example
WaitSecs(1);
[secs, keyCode, deltaT] = KbWait();

find(keyCode)    % if you press ((Space)) key the result will be : 32

KbName(32)       % answer: space

KbName('space')  % answer: 32




%% Tests Sync
Screen('Preference', 'SkipSyncTests', 1);
VBLSyncTest() % Tests Sync

%% Perceptual VBL Sync Test
PerceptualVBLSyncTest() % Perceptual VBL Sync Test
%%instructions on how to install the kernel driver

%% Testing the screen

help SyncTrouble 

%% Skipping Sync Tests

Screen('Preference','SkipSyncTests',1);

%% Screen Timing

Screen('Preference','SkipSyncTests',1);

wPtr = Screen('OpenWindow',0);
% wPtr =Screen('OpenWindow',max(Screen('Screens')));
flipTime = Screen('Flip',wPtr);

KbWait(); %wait until key pressed

clear Screen;

%% Screen Timing

now = GetSecs();
aLittleLater = GetSecs();
gap = aLittleLater - now;
