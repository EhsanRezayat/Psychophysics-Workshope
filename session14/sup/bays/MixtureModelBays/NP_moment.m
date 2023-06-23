function M = NP_moment(X, T, J)
%NP_MOMENT
%   M = NP_MOMENT(X, T, J) returns a non-parametric estimate of the Jth
%   circular moment for a model describing recall responses X in terms of
%   an unknown distribution of errors centred on target/non-target items T.
%   Inputs should be in radians, -PI <= X < PI.
%
%   Ref: Bays, Sci Rep 6, 2016.
%
%   Paul Bays | bayslab.com | Licence GPL-2.0 | 2015-12-09 

if nargin<3 || isempty(J)
    J = 1;
end

if size(X,2)>1 || size(X,1)~=size(T,1)
    error('Input is not correctly dimensioned'); return;
end
E = mod(bsxfun(@minus,X,T) + pi, pi*2) - pi;

[n m] = size(E);
if m>n, warning('Input may be incorrectly dimensioned (items > trials).'); end

M = sum(sum(exp(1i*J*E)))/n;