function [p, pSelect, pC] = pNeuralBinding(X, MR, C, MC, gamma, kappaR, kappaC, exactCircularMLE, nTheta)
%PNEURALBINDING Determines response probabilities in neural binding model.
%   P = PNEURALBINDING(X, MR, C, MC, GAMMA, KAPPAR, KAPPAC) computes
%   response probabilities P for a set of trials with response values X,
%   report feature values MR, cue values C, and cue feature values MC in a
%   conjunctive population coding model with gain GAMMA and concentrations
%   parameters KAPPAR and KAPPAC for the tuning curves in report and cue
%   dimension, respectively. Response and cue feature values must be given
%   as column vectors with size nTrials x 1, and MR and MC as matrices of
%   size nTrials x nItems. All feature value must be given in radians and
%   are assumed to be taken from a circular feature space over the range
%   [-pi, pi). Parameters GAMMA, KAPPAR, and KAPPAC must be scalars. The
%   output will be a column vector of response probabilities for each
%   trial.
%   
%   PNEURALBINDING(X, MR, C, MC, GAMMA, KAPPAR, KAPPAC, EXACTCIRCULARMLE)
%   allows switching between exact decoding of maximum likelihood values in
%   circular space (default, EXACTCIRCULARMLE = true), and a simplified
%   approach that treats the feature space as if it was linear in order to
%   determine the effect of the number of spikes/samples on decoding
%   precision (EXACTCIRCULARMLE = false). The latter allows much faster
%   computation of probabilities, but can deviate substantially from exact
%   decoding for small values of KAPPA.
%   
%   PNEURALBINDING(X, MR, C, MC, GAMMA, KAPPAR, KAPPAC, ECMLE, NTHETA) uses
%   NTHETA sampling points for numerical computations over the circular
%   space (nTheta must be even, default is 360).
%   
%   [P, PSELECT, PC] = PNEURALBINDING(...) additionally returns an nTrials
%   x nItems matrix PSELECT of probabilities that the response was based on
%   each item in a trial (taking into account both the similarity of each
%   item's cue feature with the given cue and the similarity of each item's
%   report feature with the response value), and another matrix PC of
%   a-priori probabilities that each item would be selected based only on the
%   similarity of its cue feature to the given cue.
%   
%   Sebastian Schneegans and Paul Bays | bayslab.com | 2020-08-10
%   Licence GPL-2.0
%   
%   Refs: Bays, JNeurosci 34(10), 2014; Bays, JoV 16(11), 2016; Schneegans
%   & Bays, JNeurosci, 37(14), 2017; Schneegans, Taylor, & Bays, PNAS,
%   2020.


%% input dimensions

nItems = size(MR, 2);
nTrials = size(MR, 1);

if gamma < 0 || kappaR < 0 || kappaC < 0
    p = NaN(size(X));
    pSelect = NaN(size(MR));
    return;
end

if nargin < 8
    exactCircularMLE = true;
end

if nargin < 9
    nTheta = 360; % must be even!
elseif mod(nTheta, 2) ~= 0 || nTheta < 2
    nTheta = max(2*round(nTheta/2), 2);
    warning('Parameter nTheta must be an even number greater than zero, value set to %d.', nTheta);
end


%% range and probabilities of spike (or sample) counts

% The number of spikes/samples for each item is assumed to be drawn
% independently from a Poisson distribution with mean gamma/nItems.

pBounds = 10^-4 / 2; % limits of probability range to be considered
countLim = max(poissinv([pBounds, 1-pBounds], gamma/nItems), [0, 1]);
counts = (countLim(1) : countLim(2))'; % range of spike counts to be considered
cCount = poisscdf(counts, gamma/nItems);
pCount = diff([0; cCount(1:end-1); 1]); % probabilities of spike counts


%% sampling points for numerical computation in circular space

% The space of cue features is sampled with nTheta points, over the range
% from (-pi+pi/nTheta) to (pi-pi/nTheta). nTheta is always even, so
% there is no sampling point at 0 and the range can always be divided into
% two symmetrical parts. For certain computations (where only absolute
% distance matters), only the upper half of the range is used.
% In the space of response features, only absolute distance matters for all
% computations, and we sample the range with nTheta/2+1 points (first point
% at 0, last one at pi).

dTheta = 2 * pi / nTheta; % distance between sampling points
iTheta = (1:nTheta)'; % sampling point indices
thetaR = 0 : dTheta : pi; % sampling points for report feature dimension
thetaC = thetaR(1:end-1) + dTheta/2; % sampling points for cue feature dimension


%% determine distributions of recall errors

% Recall precision for cue and report feature of each item is independent
% for a given sample count, but is correlated overall via the shared sample
% count. 

% get distributions of decoding errors separately for cue and report
% feature at each sample count (over half ranges)
if exactCircularMLE
    [rrk, pr, bir] = vmwalklengthpdf([kappaC, kappaR], counts);
    eC = pr(:, :, 1) * exp(kappaC .* rrk' .* cos(thetaC) - bir(:, :, 1)' - log(2*pi));
    eR = pr(:, :, 2) * exp(kappaR .* rrk' .* cos(thetaR) - bir(:, :, 2)' - log(2*pi));
else
    eC = vonmisespdf(thetaC, 0, j2k_interp(k2j(kappaC) * counts));
    eR = vonmisespdf(thetaR, 0, j2k_interp(k2j(kappaR) * counts));
end

% determine overall error distribution for cue feature
weC = pCount .* eC; % decoding errors for cue feature weighted with sample count probabilities
hCHalf = sum(weC, 1)';
hC = [flip(hCHalf, 1); hCHalf]; % extend to full range
dhC = circshift(hC, -1, 1) - hC; % difference vector for linear interpolation

% determine joint distribution of decoding errors, normalized so that each
% row (distribution over report feature) integrates to 1; first dimension
% of HCR is cue feature space, second is report feature space
HCR = sum(permute(weC ./ sum(weC, 1), [2, 3, 1]) .* permute(eR, [3, 2, 1]), 3);
dHCR = [diff(HCR, 1, 2), zeros(nTheta/2, 1)]; % difference matrix for linear interpolation


%% determine item feature values relative to cue/report value

% All trial information is reshaped to [1 x nItems x nTrials] arrays (the first
% dimension is used for probability distributions over cue space).

dC = permute(wrap(C - MC) / dTheta, [3, 2, 1]); % relative position of item cue features to cue, in sampling points
idC = floor(dC); % discretize to sampling points (for interpolation)
rdC = dC - idC; % remainder of discretization

dR = permute(abs(wrap(X - MR)) / dTheta + 1, [3, 2, 1]); % distance of response from item report features, in sampling points
idR = floor(dR); % discretize to sampling points (for interpolation)
rdR = dR - idR; % remainder of discretization


%% align cue error distribution to item cue values 

% Computations below are performed in matrices (pdfC and all those
% derived from it) whose first dimension is spanned by sampling points over
% cue feature space, using either the full range (-pi, pi) or the half
% range (0, pi). Values in the i-th row always refer to a distance bin
% d(i). For matrices defined over the half range, 
% d(i) = [(i-1)*dTheta, i*dTheta]. For matrices defined over the full
% range, d(i) = [(i-nTheta/2-1)*dTheta, (i-nTheta/2)*dTheta]. The second
% dimension of these matrices is spanned by the indices of the items in
% each trial, and the third dimension is spanned by the trial indices (the 
% third dimension is omitted in the comments for brevity).

% The distribution of decoding errors in hC is aligned with each item's
% cue feature value by manual linear interpolation.

I = mod(iTheta + idC - 1, nTheta) + 1; % index matrix for interpolation
pdfC = hC(I) + rdC .* dhC(I); % pdfC(i, j) = probability that decoded cue value for item j is i*dTheta relative to given cue
pdfC = pdfC ./ sum(pdfC, 1); % re-normalize after interpolation


%% determine probability that item is selected based on cue, and probability of decoded cue feature given item is seleced

% flip over pdf to reduce to half range, and determine complement of cdf
ccdfC = cumsum( pdfC(nTheta/2+1 : nTheta, :, :) + flip(pdfC(1 : nTheta/2, :, :), 1), 1, 'reverse'); % ccdfC(i, j) = probability that decoded cue value for item j has at least distance d(i) from cue
gcdfC = prod(ccdfC, 2) ./ ccdfC; % gcdfC(i, j) = probability that decoded cue value for all items other than j have at least distance d(i) from cue
gcdfC(isnan(gcdfC)) = 0; % remove NaNs (can occur due to division of 0 by 0
gcdfC = (gcdfC + [gcdfC(2:end, :, :); zeros(1, nItems, nTrials)]) / 2; % averaging as heuristics to account for possibility that multiple distances may fall in the same bin

% expanding again to full range to multiply with pdfC
cpC = pdfC .* [flip(gcdfC, 1); gcdfC]; % cpC(i, j) = probability that decoded cue value for item j has distance d(i) from actual cue, and decoded values for all other items have greater distance
pC = sum(cpC, 1); % pC(j) = probability that item j is selected for response generation for the given cue
cpC = cpC ./ pC; % normalize cpC for each item (pC is factored in again at the end)
% now cpC(i, j) is the conditional probability that the decoded feature value of item j is d(i) if item j is selected for response generation
cpC(isnan(cpC)) = 0;
pC = pC ./ sum(pC, 2); % re-normalize pC (deviations may have been introduced by discretization)


%% shift probability distributions back to be centered on 0

% Another manual linear interpolation that reverts the alignment performed
% above, so distributions over cue feature space are positioned as if each
% item's actual cue value was zero.

dcpC = cpC - circshift(cpC, 1, 1) ; % difference matrix for linear interpolation
I = mod(iTheta - idC - 1, nTheta) + 1; % index matrix
I = I + (reshape(0:nTrials-1, [1, 1, nTrials]) * nItems + (0:nItems-1)) * nTheta; % take into account trial/item number in index matrix
cpC = cpC(I) - rdC .* dcpC(I); % interpolation to shift cpC back
acpC = cpC(nTheta/2+1:end, :, :) + flip(cpC(1:nTheta/2, :, :), 1); % flip over to reduce to half range again


%% get interpolated slice from HCR for response value

% For each item, we extract a column vector from the joint decoding error
% distribution. This vector is the conditional distribution of decoding
% errors in the cue feature dimension given that the decoding error in the
% report feature dimension matches the distance of the response from the
% item's report value.

cpR = reshape(HCR(:, idR), [nTheta/2, nItems, nTrials]) + rdR .* reshape(dHCR(:, idR), [nTheta/2, nItems, nTrials]);


%% compute response and item selection probabilities

pR = sum(acpC .* cpR, 1); % pR(j) = probability that the observed response in the model is produced if item j is selected
p = reshape(sum(pC .* pR, 2), [nTrials, 1]);
pSelect = permute(pC .* pR, [3, 2, 1]) ./ p;
pC = permute(pC, [3, 2, 1]);


