function LL = llNeuralSwap(X, T, NT, nItems, kappa, gamma, pNT, exactCircularMLE)
%LLNEURALSWAP Log-likelihood of responses in cued recall under neural
%model.
%   LL = LLNEURALSWAP(X, T, NT, NITEMS, KAPPA, GAMMA, PNT) computes the
%   summed log-likelihood of obtaining response values X in cued recall
%   trials with target feature values T, non-target feature values NT and
%   set sizes NITEMS under a neural model with tuning curve concentration
%   KAPPA, spike rate GAMMA, and swap rate pNT. The total spike rate GAMMA
%   is assumed to be distributed evenly between all items in the trial, and
%   each non-target in a trial is assumed to be reported with probability
%   PNT (i.e. total swap rate increases linearly with set size). X, T, and
%   NITEMS must be Nx1 vectors with one entry for each trial, and NT must
%   be an NxM matrix, where M is the maximum number of non-target items
%   (may contain NaNs for trials with fewer non-targets, and may be empty
%   if PNT is zero). Parameters KAPPA, GAMMA, and PNT must be scalars.
%   
%   LL = LLNEURALSWAP(X, T, NT, NITEMS, KAPPA, GAMMA, PNT,
%   EXACTCIRCULARMLE) allows switching between exact decoding of maximum
%   likelihood values in circular space (default, EXACTCIRCULARMLE = true),
%   and a simplified approach that treats the feature space as if it was
%   linear in order to determine the effect of the number of spikes/samples
%   on decoding precision (EXACTCIRCULARMLE = false). The latter allows
%   much faster computation of probabilities, but can deviate substantially
%   from exact decoding for small values of KAPPA.
%   
%   This function calls pNeuralModel to determine the individual components
%   of the response distributions.
%   
%   Sebastian Schneegans and Paul Bays | bayslab.com | 2020-08-10
%   Licence GPL-2.0
%   
%   Refs: Bays, JNeurosci 34(10), 2014; Bays, JoV 16(11), 2016; Schneegans,
%   Taylor, & Bays, PNAS, 2020.


if nargin < 8
    exactCircularMLE = true;
end

setSizes = unique(nItems);
if pNT < 0 || pNT*max(setSizes) > 1 || kappa < 0 || gamma < 0
    LL = -inf;
    return;
elseif pNT == 0
    NT = [];
elseif max(setSizes) > size(NT, 2) + 1
    error('Size of NT does not match set sizes specified by nItems.');
end

LL = 0;
errors = wrap(X - [T, NT]);

for i = 1 : numel(setSizes)
    n = setSizes(i);
    m = min(n, size(errors, 2));
    p = pNeuralModel(errors(nItems == n, 1:m), kappa, gamma/n, exactCircularMLE);
    LL = LL + sum(log(sum(p .* [1-(n-1)*pNT, repmat(pNT, [1, m-1])], 2)));
end
