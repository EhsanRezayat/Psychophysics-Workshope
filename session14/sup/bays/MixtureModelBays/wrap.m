function X = wrap(Y, bound)
% WRAP Maps values into a circular space [-PI, PI) 
%   X = WRAP(Y, BOUND) specifies alternative symmetric bounds (default is PI).
%
% Paul Bays | bayslab.com | Licence GPL-2.0 | 2010-09-21

if nargin<2, bound = pi; end

X = mod(Y + bound, bound*2) - bound;
