function R = cresultant(X, Y)
% CRESULTANT Circular resultant vector
%   M = CRESULTANT(X) returns the first trigonometric moment of a circular 
%   sample X (range -PI to PI).  Use CRESULTANT(X,Y) for histogram counts Y
%   at bin centres X.
%
% Paul Bays | paulbays.com | 2019-09-26

if any(abs(X)>pi), error('Input values must be in radians, range -PI to PI'); return; end

if size(X,1)==1, X = X'; end

if nargin<2
    Y = ones(size(X)); 
else
    if size(Y,1)==1, Y = Y'; end
end

R = sum(Y.*exp(1i * X)) ./ sum(Y);

