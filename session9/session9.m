%% %%%%%%   In the name of God, the most gracious, the most merciful %%%%%%
%% MATLAB for Brain and Cognitive Psychology Workshope 2023
% Ehsan Rezayat, Ph.D.
% Faculty of Psychology and Education, University of Tehran,
% Institute for Research in Fundamental Sciences (IPM), School of Cognitive Sciences,
% rezayat@ut.ac.ir, rezayat@ipm.ir, erezayat.er@gmail.com 
% Contributed by: Amir.M Mousavi.H, Helia Thaghavi & Fatemeh Fallah
% Amir.harris@sru.ac.ir   heliabsb@gmail.com  fh.fallah90@gmail.com
% last edition : 02/11/2023

%% session #9 Respose collection  

path_code = cd;
addpath(genpath([path_code '\sup']))

%% PsychHID
devices = PsychHID('Devices'); %PsychHID only checks for USB devices on startup. 


%% Keyboard responses
GetChar()
KbWait()
KbCheck()

%% GetChar:Don't use GetChar() for timing!

FlushEvents()
pressed = GetChar()

%% GetChar
FlushEvents;GetChar()

%% KbCheck
WaitSecs(.5);
startTime = GetSecs();
keyIsDown = 0;

while ~keyIsDown
    [keyIsDown,secs,keyCode]=KbCheck(-1);
end
pressedKey = KbName(find(keyCode));
reactionTime = secs-startTime;

 fprintf('\nKey %s was pressed at %.4f seconds\n\n',pressedKey,reactionTime);

 
 %% KbCheck:Use KbCheck to break out of an animation loop
Screen('Preference','SkipSyncTests',1);

WaitSecs(.5);
startTime = GetSecs();
keyIsDown = 0;

%open the screen and set up initial color
 [wPtr,rect]=Screen('OpenWindow',max(Screen('Screens')),[128 128 128]);
%  [wPtr,rect]=Screen('Openwindow',max(Screen('Screens')),[128 128 128 ],[1 1 1900 1000]);

bgColor=255;
Screen('FillRect',wPtr,bgColor);
Screen('Flip',wPtr);
increment = -1;

while ~keyIsDown
    [ keyIsDown,secs,keyCode ]=KbCheck(-1);
    
    %change the background color
    bgColor = bgColor + increment;
    if bgColor<=0 || bgColor>=255
        increment = -increment;
    end
    Screen('FillRect',wPtr,bgColor);
    Screen('Flip',wPtr);
    
end

pressedKey = KbName(find(keyCode));
reactionTime = secs-startTime;

clear Screen
fprintf('\nKey %s was pressed at %.4f seconds\n\n',pressedKey,reactionTime);

%% Collect a response only while the stimulus is visible

%Present a stimulus and wait for a response while the stimulus is visible

Screen('Preference','SkipSyncTests',1);

WaitSecs(.5);
startTime = GetSecs();
keyIsDown = 0;
stimDuration=5;

%open the screen
 [wPtr,rect]=Screen('OpenWindow',max(Screen('Screens')),[128 128 128]);
%  [wPtr,rect]=Screen('Openwindow',max(Screen('Screens')),[128 128 128 ],[1 1 1900 1000]);

%Read in pic and create texture
faceData=imread('sadface.jpg');
faceTexture=Screen('MakeTexture',wPtr,faceData);

%Draw it
Screen('DrawTexture',wPtr,faceTexture);
stimTime=Screen('Flip',wPtr);
responseKey =[]; responseTime =[];
while GetSecs() <= stimTime + stimDuration
    [ keyIsDown,secs,keyCode ] = KbCheck(-1);
    if keyIsDown
        responseKey  = KbName(find(keyCode));
        responseTime = secs - startTime;
    

    end
    
end

%Blank screen for 5 seconds, not recording responses now
Screen('Flip',wPtr);
WaitSecs(5);
clear Screen

fprintf('\nKey %s was pressed at %.4f seconds\n\n',responseKey,responseTime);


%% Continue collecting responses after the stimulus goes away

%Continue to collect responses after the stimulus is gone

Screen('Preference','SkipSyncTests',1);

WaitSecs(.5);
startTime = GetSecs();
keyIsDown = 0;
stimDuration=5;
responseDuration=10;

%open the screen
 [wPtr,rect]=Screen('OpenWindow',max(Screen('Screens')),[128 128 128]);
%  [wPtr,rect]=Screen('Openwindow',max(Screen('Screens')),[128 128 128 ],[1 1 1900 1000]);

%Read in pic and create texture
faceData=imread('sadface.jpg');
faceTexture=Screen('MakeTexture',wPtr,faceData);

%Draw it
Screen('DrawTexture',wPtr,faceTexture);
stimTime=Screen('Flip',wPtr);


while GetSecs()<= stimTime + responseDuration
    [ keyIsDown,pressedSecs,keyCode ]=KbCheck(-1);
    if keyIsDown
        responseKey=KbName(find(keyCode));
        responseTime= pressedSecs - startTime;
    end
    if GetSecs-stimTime>=stimDuration
        %stimulus has been up for as long as it should be,so we erase it
        Screen('Flip',wPtr);
    end
    
end

fprintf('\nKey %s was pressed at %.4f seconds\n\n',responseKey,responseTime);
clear Screen


%% 
%% Ignoring responses

DisableKeysForKbCheck([disablekeys]) % vector of key codes to ignore

RestrictKeysForKbCheck([enablekeys])

%% Ignoring responses example

% waitForScannerTrigger()

WaitSecs(.5);

%find key code for trigger . which is a 5

triggerCode = KbName('5%')
keyIsDown   = 0;

%make sure no key are disabled

DisableKeysForKbCheck([]);

%wait for trigger 

while 1 
    [keyIsDown, pressedSecs, keyCode ] = KbCheck(-1);
    if keyIsDown
        if find(keyCode)== triggerCode
            break;
            
        end
    end
end

%Recoed trigger time for future reference 

triggerTime = pressedSecs;
fprintf('Trigger detected\n');

% Now disable the 5 key for the rest of script

DisableKeysForKbCheck([triggerCode]);

% Now get a new response, ingnoring triggers
WaitSecs(.5);
fprintf('Waiting for response\n')
keyIsDown = 0;
while ~keyIsDown
    [keyIsDown, pressedSecs, keyCode ] = KbCheck(-1);
end

pressedKey   = KbName(find(keyCode));
reactionTime = pressedSecs - triggerTime;

fprintf ('\nkey %s was pressed at %.4f secondes\n\n',pressedKey,reactionTime)

%% Keyboard responses

GetChar()
KbWait()
KbCheck()
KbQueueCheck()


%% KbQueueCheck

KbQueueCreate([deviceNumber]) %to create the queue. 
KbQueueStart()                %to start listening
KbQueueStop()                 %to stop listening (does not clear the queue)
KbQueueCheck()                %to check the values recorded while the queue was active
KbQueueFlush()                %to empty the queue
KbQueueRelease()              %to destroy the queue object

%% KbQueueCheck

% pressed      : has a key been pressed?
% firstPress   : array indicating when each key was first pressed
% firstRelease : array indicating when each key was first released

[pressed, firstPress, firstRelease, lastPress, lastRelease] = KbQueueCheck()  


%% Other keyboard response functions


GetNumber()

GetString()

GetEchoString(wPtr,message,x,y)  % EXAMPLE
                                 % Screen('Preference', 'SkipSyncTests', 1);
                                 % [wPtr rect] = Screen('OpenWindow',max(Screen('Screens')));
                                 % GetEchoString(wPtr,'Hwllo world !!!',rect(3)/2,rect(4)/2);

Ask(wPtr, message)                 % EXAMPLE
                                 % Screen('Preference', 'SkipSyncTests', 1);
                                 % [wPtr rect] = Screen('OpenWindow',max(Screen('Screens')));
                                 % Ask(wPtr,'Hwllo world !!!');


%% Mouse responses

GetMouse()
GetClicks()
GetMouseWheel()
SetMouse()
ShowCursor()
HideCursor()


%% Mouse responses

% buttons  : vector of three numbers, one for each mouse button , 0 = not pressed , 1 = pressed
% mouseDev : which mouse device


% [x,y,buttons] = GetMouse([windowPtrOrScreenNumber],[ mouseDev])

%% Mouse responses Example

% mouseWait ()

buttons = 0;

while ~buttons
    [x,y,buttons] = GetMouse();
end

fprintf ('you clicked button %d on x=%d and y= %d\n',find(buttons),x,y);

%%  Mouse responses

% [clicks,x,y,whichButton] = GetClicks([windowPtrOrScreenNumber] ,[ interclickSecs],[ mouseDev]) % Use this to wait for a click and record where the user clicked,
                                                                                               % and how many clicks they made (e.g. double-click). 

                                                                                               
% wheelDelta = GetMouseWheel([mouseIndex]) % Use this to get the position of the mouse scroll wheel

                                                      
%% Controlling the mouse  --> SetMouse


Screen('Preference', 'SkipSyncTests', 1);
% [wPtr , rect] = Screen('OpenWindow',max(Screen('Screens')));
%  [wPtr,rect]=Screen('Openwindow',max(Screen('Screens')),[128 128 128 ],[1 1 1900 1000]);
 [wPtr,rect]=Screen('Openwindow',max(Screen('Screens')),[128 128 128 ]);

SetMouse(rect(3)/2,rect(4)/2); % to move the mouse to center
KbWait();
clear Screen;


%% Controlling the mouse --> HideCursor

Screen('Preference', 'SkipSyncTests', 1);
% [wPtr , rect] = Screen('OpenWindow',max(Screen('Screens')));
%  [wPtr,rect]=Screen('Openwindow',max(Screen('Screens')),[128 128 128 ],[1 1 1900 1000]);
  [wPtr,rect]=Screen('Openwindow',max(Screen('Screens')),[128 128 128 ]);

HideCursor() ; % to hide the mouse pointer
KbWait();
ShowCursor()   % to show  the mouse pointer
WaitSecs(1) 
KbWait();
clear Screen;


%% Other input devices

GamePad() % Type Gamepad in the command window for help, or Gamepad Subcommand? for help with a subcommand

Gamepad('GetButton',gamepadIndex, buttonIndex) % to get status of buttons
Gamepad('GetAxis',gamepadIndex,axisIndex)      % to get joystick position
Gamepad('GetBall',gamepadIndex,ballIndex)      % to get trackball info

