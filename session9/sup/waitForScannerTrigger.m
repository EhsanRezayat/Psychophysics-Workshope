function waitForScannerTrigger()

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
    
end