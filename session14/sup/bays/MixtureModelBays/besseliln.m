function w = besseliln(nu, z)
%BESSELILN Logarithm of modified Bessel function of the first kind.
%   I = BESSELILN(NU,Z) computes the natural logarithm of the modified 
%   Bessel function of the first kind, I_nu(Z). 
%
% Paul Bays | bayslab.com | Licence GPL-2.0 | 2012-08-24 

w = log(besseli(nu,z,1)) + abs(real(z));
