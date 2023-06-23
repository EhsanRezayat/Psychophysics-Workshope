function s = deg2screen (d, screen_struct, format)

% function s = deg2screen (d, screen_struct, format)
% 
% returns the location of d in screen coordinate. 
% 
% Input
%   d               a vector or a matrix with two rows or two columns
%   screen_struct
%   format          can be 'v', 'cm', or 'rm'
% 
% Output
%   s       location in screen coordinate
% 
% 

% 
% 09/26/07,  Roozbeh Kiani
% 

s = zeros(size(d));

if nargin < 3 || isempty(format)
    [m, n] = size(d);
    if m==1 || n==1
        format = 'v';
    elseif n == 2
        format = 'cm';
    elseif m == 2
        format = 'rm';
    end
end

switch format
    %if d is a vector assume this arrangement: [x y x y ...]  
    case {'v','vector'}
        s(:,1:2:end) = mean(screen_struct.screen_rect([1 3])) + d(:,1:2:end) * screen_struct.pix_per_deg;
        s(:,2:2:end) = mean(screen_struct.screen_rect([2 4])) - d(:,2:2:end) * screen_struct.pix_per_deg;
    %if the format is cm assume that d is a two-column matrix [x y]
    case {'cm','column matrix'}
        s(:,1) = mean(screen_struct.screen_rect([1 3])) + d(:,1) * screen_struct.pix_per_deg;
        s(:,2) = mean(screen_struct.screen_rect([2 4])) - d(:,2) * screen_struct.pix_per_deg;
    %if the format is rm assume that d is a two-row matrix [x; y]
    case {'rm','row matrix'}
        s(1,:) = mean(screen_struct.screen_rect([1 3])) + d(1,:) * screen_struct.pix_per_deg;
        s(2,:) = mean(screen_struct.screen_rect([2 4])) - d(2,:) * screen_struct.pix_per_deg;
    otherwise
        error('Deg2Screen:UnknownFormat', 'Input of deg2screen should be either a vector or a 2*n or n*2 matrix');
end

