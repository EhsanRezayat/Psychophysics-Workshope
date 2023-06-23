function drawSomething ()

% KbWait();% after 2 sec you can press a key
Screen('Preference', 'SkipSyncTests', 1);    
[wPtr, rect] = Screen('OpenWindow',max(Screen('Screens')),[0 0 0]);

% Screen('FillRect' , windowPtr, [color], [rect] );
Screen('FillRect',  wPtr, [255 0 0],[100 100 500 500]);   % draw red rect
Screen('Flip',wPtr); % flip
WaitSecs(2);%wait for 2 sec

Screen('Flip',wPtr); % flip
WaitSecs(3);%wait for 3 sec

Screen('FillRect', wPtr, [255 120 60],[400 400 600 600]);   % draw orange rect
Screen('Flip',wPtr);  % flip
WaitSecs(2);%wait for 2 sec

clear Screen;
end