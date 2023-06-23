function [A] = NP_alpha(X, T)
%NP_ALPHA
%   A = NP_ALPHA(X, T) returns a non-parametric estimate of mixture 
%   parameters for a model describing recall responses X in terms of an 
%   unknown distribution of errors centred on target/non-target items T. 
%   Inputs should be in radians, -PI <= X < PI.
%
%   Ref: Bays, Sci Rep 6, 2016.
%
%   Paul Bays | bayslab.com | Licence GPL-2.0 | 2015-12-09 

if size(X,2)>1 || size(X,1)~=size(T,1)
    error('Input is not correctly dimensioned'); return;
end
E = mod(bsxfun(@minus,X,T) + pi, pi*2) - pi;

[n m] = size(E);
if m>n, warning('Input may be incorrectly dimensioned (items > trials).'); end

Z = sum(exp(1i*E));
SZ = repmat(sum(Z),1,m);

A = (Z.*conj(SZ)+conj(Z).*SZ)./(2*SZ.*conj(SZ));