function p = wrapnormpdf (x, m, s, bound)
% WRAPNORMPDF Wrapped normal probability density function (pdf)
%   Y = WRAPNORMPDF(THETA,MU,SIGMA) returns the pdf of the wrapped normal 
%   distribution with mean MU and standard deviation SIGMA, evaluated at 
%   the values in THETA (given in radians).
%
%   Y = WRAPNORMPDF(THETA,MU,SIGMA,BOUND) returns the normal distribution
%   wrapped at bounds given by +/- BOUND.
%
%   Paul Bays | bayslab.com | Licence GPL-2.0 | 2013-08-22

if nargin<3 | isempty(s), s = 1; end
if nargin<2 | isempty(m), m = 0; end

% make sure input sizes are compatible
[errorcode x m s] = distchck(3,x,m,s);
if errorcode > 0
    error('wrapnormpdf:InputSizeMismatch', 'Input sizes are not compatible.');
end

% adjust for custom bounds
if nargin<4, bound = pi; end
A = pi/bound;
x = x*A; m = m*A; s = s*A; 

s(s<=0) = nan;

% calculate PDF iteratively
p = zeros(size(x));

rho = exp(-s.^2 / 2);

j = 0;
while (1)
    j = j + 1;
    
    f = rho .^ (j^2) .* cos(j * (x - m));           
    p = p + f;

    if max(abs(f(:)))<eps || all(isnan(f(:))), break; end        
end

p = 1/(2*pi) * (1 + 2*p) * A;

p(x<-pi | x>pi) = nan;
p(p<0) = 0;

