function p = wrapnormcdf (x, m, s, bound)
% WRAPNORMCDF Wrapped normal cumulative density function (pdf)
%   Y = WRAPNORMCDF(THETA,MU,SIGMA) returns the cdf of the wrapped normal 
%   distribution with mean MU and standard deviation SIGMA, evaluated between
%   -PI and the values in THETA (given in radians).
%
%   Y = WRAPNORMCDF(THETA,MU,SIGMA,BOUND) returns the cdf of the normal 
%   distribution wrapped at bounds given by +/- BOUND, evaluated between 
%   -BOUND and the values in THETA.
%
%   Paul Bays | bayslab.com | Licence GPL-2.0 | 2013-08-22

if nargin<3 | isempty(s), s = 1; end
if nargin<2 | isempty(m), m = 0; end

% make sure input sizes are compatible
[errorcode x m s] = distchck(3,x,m,s);
if errorcode > 0
    error('wrapnormcdf:InputSizeMismatch', 'Input sizes are not compatible.');
end

% adjust for custom bounds
if nargin<4, bound = pi; end
A = pi/bound;
x = x*A; m = m*A; s = s*A; 

s(s<=0) = nan;

% calculate CDF iteratively
p = zeros(size(x));
j = 0;
while (1)
    j=j+1;
    
    f = exp(- j^2 * s.^2 / 2) / j .* ( sin( j*(x-m) ) + sin( j*(m+pi) ) );
    p = p + f;

    if max(abs(f))<eps | all(isnan(f)), break; end        
end
p = 1/(2*pi) .* (x + pi + 2*p);

p(x<-pi | x>pi) = nan;
p(p<0) = 0; p(p>1) = 1;


