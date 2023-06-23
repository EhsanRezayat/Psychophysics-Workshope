function [P xx] = NP_pdf(X, T, xx)
%NP_PDF
%   P = NP_PDF(X, T) returns a non-parametric estimate of probability 
%   density for a model describing recall responses X in terms of an 
%   unknown distribution of errors centred on target/non-target items T. 
%   Inputs should be in radians, -PI <= X < PI.
%
%   By default, NP_PDF returns the density evaluated at 25 points 
%   evenly-spaced on the circle. P = NP_PDF(X, T, N) evaluates the density
%   at N evenly-spaced points, and P = NP_PDF(X, T, Y) where Y is a vector,
%   evaluates the density at the values in Y. [P Y] = NP_PDF(X, T) returns
%   the evaluation points in Y.
%
%   Ref: Bays, Sci Rep 6, 2016.
%
%   Paul Bays | bayslab.com | Licence GPL-2.0 | 2015-12-09 

if nargin<3 || isempty(xx)
    nx = 25; xx = -pi+pi/nx : 2*pi/nx : pi-pi/nx;
elseif prod(size(xx))==1
    nx = xx; xx = -pi+pi/nx : 2*pi/nx : pi-pi/nx;
else
    nx = length(xx);
end

if size(xx,1)>1, xx = xx'; end

if size(X,2)>1 || size(X,1)~=size(T,1) 
    error('Input is not correctly dimensioned'); return; 
end

E = mod(bsxfun(@minus,X,T) + pi, pi*2) - pi;

[n m] = size(E);
if m>n, warning('Input may be incorrectly dimensioned (items > trials).'); end

if m==1
    P = hist(E,xx)'*nx/(n*2*pi);
else
    P = (sum(hist(E,xx),2)*nx/n - (m-1))/(2*pi);
end