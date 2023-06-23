function P = expectedNonTargetDeviation(X, T, NT, binEdges, nPermutations)
% EXPECTEDNONTARGETDEVIATION Expected histogram of non-target deviations in
%   cued recall.
%   P = EXPECTEDNONTARGETDEVIATION(X, T, NT, BINEDGES) returns in P the
%   expected histogram (normalized as a pdf) of response deviations from
%   the non-target items in a cued recall task, assuming no swap errors. It
%   is intended to be used for correcting the actual histogram of
%   non-target deviations for inhomogeneity induced by minimum distances
%   between items' feature values. X is the vector of response values, T
%   the vector of target values (both M x 1), and NT is the matrix of
%   non-target values (M x (N-1) for set size N).
%   
%   P = EXPECTEDNONTARGETDEVIATION(X, T, NT, BINEDGES, NPERMUTATIONS) bases
%   the estimation on NPERMUTATIONS random shuffles of the trials. This is
%   typically slower and less precise, and should only be used for very
%   large numbers of trials where the first variant exceeds the available
%   memory.
%   
%   Sebastian Schneegans | bayslab.com | Licence GPL-2.0 | 2020-08-10

if nargin < 5
    nPermutations = 0;
end

nTrials = size(X, 1);
setSize = size(NT, 2) + 1;

dXT = X - T;
dTNT = NT - T;

if nPermutations <= 0
    D = wrap(dXT' - reshape(dTNT, [nTrials, 1, setSize-1]));
    P = histcounts(D, binEdges, 'Normalization', 'pdf');
else
    C = zeros(1, numel(binEdges)-1);
    for i = 1 : nPermutations
        D = wrap(dXT(randperm(nTrials)) - dTNT);
        C = C + histcounts(D, binEdges);
    end
    P = C ./ (sum(C) * diff(binEdges));
end

