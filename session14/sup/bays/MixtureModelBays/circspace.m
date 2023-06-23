function y = circspace (n)
% CIRCSPACE Vector of equally spaced points in circular range [-PI, PI)
%
% Paul Bays | paulbays.com | Licence GPL-2.0 | 2011-10-27

dy = 2*pi / n;
y = -pi+dy/2 : dy : pi-dy/2;