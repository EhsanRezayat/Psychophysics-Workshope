
% 
% 09/26/07,  Roozbeh Kiani
% 


global screen_struct dots_struct MAX_DOTS_PER_FRAME 

distance = 28;
dot_size = 3;

    % define the screen structure for the experiment
screen_struct = struct('cur_screen', 1, ...         % which screen will be showing the stimuli
                       'screen_bkg', [0 0 0], ...   % screen background [r g b]
                       'mon_width_cm', 40.0, ...    % initScreen will generate an error if the monitor size is incorrect
                       'view_dist_cm', distance, ... 
                       'mon_refresh', 75, ...       % initScreen will generate an error if the monitor frame rate is different 
                       'cur_window', [], ...
                       'screen_rect', [], ...
                       'pix_per_deg', []);


    % define the maximum number of dots in each dots patch 
MAX_DOTS_PER_FRAME = 200;


dots_struct = struct('aperture', [], ...
                     'direction', [], ...
                     'coherence', 0, ...
                     'speed', 5, ...
                     'density', 16.7, ...
                     'interval', 3, ...
                     'dot_size', dot_size, ...
                     'dot_color', [255 255 255]);

