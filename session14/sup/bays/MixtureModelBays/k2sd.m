function S = k2sd (K)
% K2SD Circular s.d. of von Mises p.d.f. with specified concentration
%   Returns the circular standard deviation of a von Mises distribution
%   with concentration parameter of K.
%
%   Ref: Statistical analysis of circular data, Fisher
%
% Paul Bays | bayslab.com | Licence GPL-2.0 | 2012-11-20

S = sqrt(-2*(besseliln(1,K)-besseliln(0,K)));
 
S(K<=0) = nan;