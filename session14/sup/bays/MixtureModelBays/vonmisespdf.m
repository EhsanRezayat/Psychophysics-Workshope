function p = vonmisespdf (x, mu, k)
% VONMISESPDF Von Mises probability density function (pdf)
%   Y = VONMISESPDF(THETA,MU,K) returns the pdf of the von Mises 
%   distribution with mean MU and concentration parameter K, 
%   evaluated at the values in THETA (given in radians).
%
%   Paul Bays | bayslab.com | Licence GPL-2.0 | 2013-08-22

p = exp(k.*cos(x-mu) - log(2*pi) - besseliln(0,k));
