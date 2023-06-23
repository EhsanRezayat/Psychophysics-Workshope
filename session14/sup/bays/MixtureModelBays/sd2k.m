function K = sd2k(S)
% SD2K Concentration of von Mises distribution with specified circular s.d.
%   Returns a numerical approximation to the Von Mises concentration
%   parameter corresponding to standard deviation S of a wrapped normal
%   distribution.
%
%   Ref: Statistical analysis of circular data, Fisher
%
% Paul Bays | bayslab.com | Licence GPL-2.0 | 2012-11-20

R = exp(-S.^2/2);

K = fastA1inv(R);