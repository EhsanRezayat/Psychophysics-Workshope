function colorLoop()


%set color value
red=0;
green=0;
blue=0;

%set Dimensions
square=[100 100 400 400];

%open screen
Screen('Preference', 'SkipSyncTests', 1);
% [wPtr,rect] = Screen('OpenWindow',max(Screen('Screens')),0);
[wPtr, rect] = Screen('OpenWindow',max(Screen('Screens')),[128 128 128]);  %open the screen

%record the time we are starting
startTime=GetSecs();

% continue this loop until 10 sec
while GetSecs() < startTime+10
    
    %draw square
    Screen('FillRect',wPtr,[red green blue],square);
    Screen('Flip',wPtr); 
    
    %increment red
    red = red + 10;
    %if red is too high , reset
    if red >250 
        red=0;
%         
    end
   
end
    
clear Screen; 
end