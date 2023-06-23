function dotsDefine(aperture, direction, coherence, speed, density, interval, dot_size, dot_color)
% 
% function dotsDefine(patch_index, aperture, direction, coherence, speed, density, interval, dot_size, dot_color)
% 
% 

% 
% 09/26/07,  Roozbeh Kiani
% 

global screen_struct dots_struct 

    %fill in the structure based on the supplied parameters 
if nargin>=1 && ~isempty(aperture)
    dots_struct.aperture = aperture;
end
if nargin>=2 && ~isempty(direction)
    dots_struct.direction = direction;
end
if nargin>=3 && ~isempty(coherence)
    dots_struct.coherence = coherence;
end
if nargin>=4 && ~isempty(speed)
    dots_struct.speed = speed;
end
if nargin>=5 && ~isempty(density)
    dots_struct.density = density;
end
if nargin>=6 && ~isempty(interval)
    dots_struct.interval = interval;
end
if nargin>=7 && ~isempty(dot_size)
    dots_struct.dot_size = dot_size;
end
if nargin>=8 && ~isempty(dot_color)
    dots_struct.dot_color = dot_color;
end
    %make sure that the dot patches are properly defined
if length(dots_struct.aperture)~=4 || any(~isfinite(dots_struct.aperture))
    dots_struct.aperture = [0 0 0 0];
end
if length(dots_struct.direction)~=1 || ~isfinite(dots_struct.direction)
    dots_struct.direction = 0;
end
if length(dots_struct.coherence)~=1 || ~isfinite(dots_struct.coherence)
    dots_struct.coherence = 0;
end
if length(dots_struct.speed)~=1 || ~isfinite(dots_struct.speed)
    dots_struct.speed = 0;
end
if length(dots_struct.density)~=1 || ~isfinite(dots_struct.density)
    dots_struct.density = 0;
end
if length(dots_struct.interval)~=1 || ~isfinite(dots_struct.interval)
    dots_struct.interval = 3;
end
if length(dots_struct.dot_size)~=1 || ~isfinite(dots_struct.dot_size)
    dots_struct.dot_size = 1;
end
if length(dots_struct.dot_color)~=3 || any(~isfinite(dots_struct.dot_color))
    dots_struct.dot_color = screen_struct.screen_bkg;
end



