%%% Program showImage.m
function gca = showImage(M, lut_type)
gca = figure; % Opens a graphics window
image(M); % Display image M in the graphics window
% axis( ' image ' ); % Sets axis properties of the image in the
% graphics window
axis  off %' ); % Turn off the axes
if strcmp(lut_type, 'grayscale' ) % Check if lut_type is
% grayscale
lut = [[0:255]'  [0:255]' [0:255]'  ]/255;
colormap(lut);
else
colormap default ; % Use Matlab ’ s default colormap
end