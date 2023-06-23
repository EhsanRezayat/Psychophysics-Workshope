
%% Demo for Shadlen & Newsome's random dots

% 
% 09/26/07,  Roozbeh Kiani
% 

    % focus on command window
commandwindow;

    % use unified key names for compatibility across platforms 
KbName('UnifyKeyNames');


    % initialize global variables. you can define the specs of the monitor and dots either
    % by editing defineGlobals or by overriding the default values here.
defineGlobals;
screen_struct.cur_screen = 0;
screen_struct.mon_width_cm = 37;
screen_struct.mon_refresh = 75;     %change if needed but it must be 75 Hz for correct 
                                    %replication of the stimulus

    % wait for all keys to be released
while KbCheck
    WaitSecs(0.1);  
end

    % start
try
        %initialize the screen
%     initScreen;
    
        %override default parameters of dots if needed
    dots_aperture = [0 0 8 8];
    dots_direction = 180;
    dots_coherence = 0.256;
    dots_speed = 5;
    dots_density = 16.7;
    dots_interval = 3;
    dot_size = 3;
    dot_color = [255 255 255];
    dotsDefine(dots_aperture, ...
               dots_direction, ...
               dots_coherence, ...      % usually one of these [0 0.032 0.064 0.128 0.256 0.512]
               dots_speed, ...          % usually 5 to 10
               dots_density, ...        % 16.7
               dots_interval, ...       % 3
               dot_size, ...            % depends on screen size and eye distance
               dot_color);              % usually white
    
        %set the priority to the maximum
    Priority(MaxPriority(screen_struct.cur_screen));
        %wait 0.5 sec
    WaitSecs(0.5);
        %show dots
    rseed = [1000 2010];
    duration = 2;
    dotsShow(rseed, duration);
        %wait 0.5 sec 
    WaitSecs(0.5);
    
        %Terminate
    
        %set the priority of the thread back to zero
    Priority(0);
    
        %close all the windows and screens
    Screen('CloseAll');
    
        %make the cursor visible
    ShowCursor;
    
catch err
    fprintf('\n\nStopped due to ERROR\n\n');
    Screen('CloseAll');
    ShowCursor;
    Priority(0);
    rethrow(err);
end


fprintf('\n\n **************************************** \n\n');





