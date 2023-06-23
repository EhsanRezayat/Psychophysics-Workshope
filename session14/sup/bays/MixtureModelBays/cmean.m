function M = cmean (X,Y)
% CMEAN Circular mean
%   CMEAN(X) returns the circular mean of samples in X. Use CMEAN(X,Y) for
%   histogram counts Y at bin centres X.
%
%   Ref: Statistical Analysis of Circular Data, N I Fisher
%
% Paul Bays | paulbays.com | 2013-08-23

if any(abs(X)>pi), error('Input values must be in radians, range -PI to PI'); return; end

if nargin<2, Y = ones(size(X)); end

M = angle(cresultant(X,Y));  
