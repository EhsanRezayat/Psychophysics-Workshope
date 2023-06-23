function S = cstd (X,Y)
% CSTD Circular standard deviation
%   CSTD(X) returns the circular standard deviation of samples in X. Use 
%   CSTD(X,Y) for histogram counts Y at bin centres X.
%
%   Ref: Statistical Analysis of Circular Data, N I Fisher
%
% Paul Bays | paulbays.com | 2019-09-26

if any(abs(X)>pi), error('Input values must be in radians, range -PI to PI'); return; end

if nargin<2, Y = ones(size(X)); end

R = abs(cresultant(X,Y));
S = sqrt(-2 * log(R));