function [B, LL, W] = mixtureFit (X, T, NT)
% mixtureFit (X, T, NT)
%   Returns maximum likelihood parameters B for a model describing
%   responses X as a probabilistic mixture of target-centred (targets
%   specified in T), non-target centred (non-targets in NT), and uniformly
%   distributed responses. Inputs should be in radians, -PI <= X < PI.
%   Fitting is based on an EM algorithm with multiple starting parameters.
%
%   B = mixtureFit (X, T, NT) returns a vector [K pT pN pU], where pT is
%   the probability of responding with the target value, pN the probability
%   of responding with a non-target value, and pU the probability of a
%   random respone. K is the concentration of a von Mises distribution
%   describing response variability around item values.
%
%   [B LL] = mixtureFit (X, T, NT) additionally returns the log likelihood LL.
%
%   [B LL W] = mixtureFit (X, T, NT) additionally returns a weight matrix of
%   trial-by-trial posterior probabilities that responses come from each of
%   the three mixture components. Each row of W corresponds to a separate 
%   trial and is of the form [wT wN wU], corresponding to the probability
%   the response comes from the target, non-target or uniform response
%   distributions, respectively.
%
%   Refs: Bays, Catalao & Husain, JoV 9(10), 2009; Schneegans & Bays,
%   Cortex 83, 2016
%
%   Paul Bays | bayslab.com | Licence GPL-2.0 | 2017-02-20

n = size(X,1); 

if (nargin<2) T = zeros(n,1); end

if (size(X,2)>1 || size(T,2)>1 || size(X,1)~=size(T,1) || nargin>2 && ~isempty(NT) && (size(NT,1)~=size(X,1) || size(NT,1)~=size(T,1)))     
    error('Input is not correctly dimensioned'); return; 
end

if (nargin<3) NT = zeros(n,0); nn = 0; else  nn = size(NT,2); end

% Starting parameters
K = [     1   10  100];
N = [  0.01  0.1  0.4];
U = [  0.01  0.1  0.4];

if nn==0, N = 0; end

LL = -inf; B = [NaN NaN NaN NaN]; W = NaN;

% Parameter estimates

warning('off','mixtureFunction:MaxIter');

for i=1:length(K)
    for j=1:length(N)
        for k=1:length(U)
            [b ll w] = mixtureFunction(X,T,NT,[K(i) 1-N(j)-U(k) N(j) U(k)]);
            if (ll>LL)
                LL = ll;
                B = b; W = w;
            end
        end
    end
end

warning('on','mixtureFunction:MaxIter');
