function drawFixationCross() 
crossLengh=10;
crossColor=0;
crossWidth=3;

%set start & end points of line
crossLines=[-crossLengh , 0 ; crossLengh , 0 ; 0 , -crossLengh ; 0 , crossLengh];
crossLines=crossLines';

%open screen
[wPtr,rect] = Screen('OpenWindow',max(Screen('Screens')));

%center
xCenter = rect(3)/2;
yCenter = rect(4)/2;

%draw the lines
Screen('DrawLines',wPtr,crossLines,crossWidth,crossColor,[xCenter,yCenter])
Screen('Flip',wPtr) 

%wait until key pressed
KbWait();                                                   
 
clear Screen; 

end