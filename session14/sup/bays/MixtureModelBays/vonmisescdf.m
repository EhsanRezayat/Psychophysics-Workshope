function p = vonmisescdf (x, mu, K)
% VONMISESCDF Von Mises cumulative density function (pdf)
%   Y = VONMISESCDF(THETA,MU,K) returns the cdf of the Von Mises
%   distribution with mean MU and concentration parameter K,
%   evaluated between -PI and the values in THETA (given in radians).
%
%   Paul Bays | bayslab.com | Licence GPL-2.0 | 2013-08-22

if (K>700)
    p = wrapnormcdf(x, mu, 1/sqrt(K));
    
else
    
    % Evaluate lower bound (-PI)
    j = 0; lb = 0;
    while(1)
        j = j+1;
        f = besseli(j, K) * sin(j * (-pi - mu)) / j;
        
        lb = lb + f;
        
        if max(abs(f))<eps, break; end
    end
    lb = (-pi + 2 * lb / besseli(0,K)) / (2*pi);
    
    
    % Evaluate cdf
    p = zeros(size(x));
    
    j = 0;
    while(1)
        j = j+1;
        f = besseli(j, K) * sin(j * (x - mu)) / j;
        
        p = p + f;
        
        if max(abs(f))<eps, break; end
    end
    
    p = (x + 2 * p / besseli(0,K)) / (2*pi);
    
    p = p - lb;
    
    p(x<-pi | x>pi) = nan;
end