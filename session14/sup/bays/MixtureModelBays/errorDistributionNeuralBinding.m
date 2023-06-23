function [pdfT, pdfNT, pdfNT_expNoSwaps, theta, pCAll] = ...
    errorDistributionNeuralBinding(MR, C, MC, gamma, kappaR, kappaC, exactCircularMLE, nTheta)
%ERRORDISTRIBUTIONNEURALBINDING  Computes distributions of response errors
%   and non-target deviations in neural binding model.
%   
%   PDFT = ERRORDISTRIBUTIONNEURALBINDING(MR, C, MC, GAMMA, KAPPAR, KAPPAC)
%   computes a probability density distribution over the space [-pi, pi] of
%   response errors for a neural binding model with parameters GAMMA, KAPPAR,
%   and KAPPAC, for a set of trials with item report feature values MR, given
%   cue values C, and item cue feature values MC. The resulting distribution is
%   determined by superimposing the response probability distributions for each
%   trial, aligned to each trial's target feature. MR and MC must be nTrials x
%   nItems matrices of item feature values in all trials, C must be an nTrials x
%   1 vector of feature values for the given cue, amd GAMMA, KAPPAR, and KAPPAC
%   must be scalars. The first column of MR is assumed to contain the report
%   feature values of the target item in each trial.
%   
%   PDFT = ERRORDISTRIBUTIONNEURALBINDING(MR, C, MC, GAMMA, KAPPAR, KAPPAC,
%   EXACTCIRCULARMLE, NTHETA) specifies which method should be used for
%   computing response distribution from the neural binding model (default for
%   EXACTCIRCULARMLE is true; if set to false, a faster method is used that
%   yields a close approximation), and uses NTHETA sampling points at which
%   response distributions are computed (default is 360).
%
%   [PDFT, PDFNT, PDFNT_EXPNOSWAPS, THETA, PC] =
%   ERRORDISTRIBUTIONNEURALBINDING(...) additionally provides the distribution
%   of response deviations from non-target features, PDFNT, the expected
%   distribution of non-target deviation if there were no swap errors,
%   PDFNT_EXPNOSWAPS, the vector THETA of sampling points over [-pi, pi] at
%   which the probability distributions are computed, and a matrix PC of
%   probabilities that each item in each trial is selected for response
%   generation (based on the model parameters, the given cue, and all items' cue
%   feature values). The distribution PDFNT_EXPNOSWAPS is equivalent to the
%   result of expectedNonTargetDeviations in behavioral data, and can be used to
%   correct the distribution of non-target deviations PDFNT for effects of
%   minimum distance in items' feature values.
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

pdfT = NaN(1, nTheta);
pdfNT = NaN(1, nTheta);
pdfNT_expNoSwaps = NaN(1, nTheta);
pCAll = NaN(nTrials, nItems);

if gamma < 0 || kappaR < 0 || kappaC < 0
    return;
end

if nargin < 7
    exactCircularMLE = true;
end

if nargin < 8
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
nCounts = numel(counts);
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
theta = 0 : dTheta : pi;
thetaR = theta(1:end-1) + dTheta/2; % sampling points for report feature dimension
thetaC = theta(1:end-1) + dTheta/2; % sampling points for cue feature dimension

theta = [-fliplr(thetaR), thetaR];

%% determine distributions of recall errors

% Recall precision for cue and report feature of each item is independent
% for a given sample count, but is correlated overall via the shared sample
% count. 

% get distributions of decoding errors for cue feature at each sample count
% (over half range)
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

% determine conditional probability for sample count given decoding error for cue feature
psceC = weC ./ sum(weC);
psceC(isnan(psceC)) = 1/nCounts; % remove NaNs (can occur due to division of 0 by 0, psceC for those doesn't matter)
psceC = reshape(psceC, [nCounts, 1, nTheta/2]); % reshape for later use (2nd dimension is items in trial later)


%% determine item feature values relative to cue/report value

dC = wrap(C - MC) / dTheta; % relative position of item cue features to cue, in sampling points
idC = floor(dC); % discretize to sampling points (for interpolation)
rdC = dC - idC; % remainder of discretization

dR = wrap(MR - reshape(MR, [nTrials, 1, nItems])) / dTheta; % relative position of report features to target feature, in sampling points
idR = floor(dR);
rdR = dR - idR;


%% loop over trials
pdfAll = zeros(1, nTheta);

for k = 1 : nTrials
    
    % Computations for each trial are performed in matrices (pdfC and all
    % those derived from it) whose first dimension is spanned by sampling
    % points over cue feature space, using either the full range (-pi, pi)
    % or the half range (0, pi). Values in the i-th row always refer to a
    % distance bin d(i). For matrices defined over the half range, 
    % d(i) = [(i-1)*dTheta, i*dTheta]. For matrices defined over the full range, 
    % d(i) = [(i-nTheta/2-1)*dTheta, (i-nTheta/2)*dTheta]. 
    % The second dimension of these matrices is spanned by the indices of the 
    % items in each trial.
    
    
    %% align cue error distribution to item cue values
    
    % The distribution of decoding errors in hC is aligned with each item's
    % cue feature value by manual linear interpolation.
    
    I = mod(iTheta + idC(k, :) - 1, nTheta) + 1; % index matrix for interpolation
    pdfC = hC(I) + rdC(k, :) .* dhC(I); % pdfC(i, j) = probability that decoded cue value for item j is i*dTheta relative to given cue
    pdfC = pdfC ./ sum(pdfC, 1); % re-normalize after interpolation
    
    
    %% determine probability that item is selected based on cue, and conditional probability of decoded cue feature
    
    % flip over pdf to reduce to half range, and determine complement of cdf
    ccdfC = cumsum( pdfC(nTheta/2+1 : nTheta, :) + flip(pdfC(1 : nTheta/2, :), 1), 1, 'reverse'); % ccdfC(i, j) = probability that decoded cue value for item j has at least distance d(i) from cue
    gcdfC = prod(ccdfC, 2) ./ ccdfC; % gcdfC(i, j) = probability that decoded cue values for all items other than j have distance of at least d(i) from cue
    gcdfC(isnan(gcdfC)) = 0; % remove NaNs (can occur due to division of 0 by 0)
    gcdfC = (gcdfC + [gcdfC(2:end, :); zeros(1, nItems)]) / 2; % averaging as heuristics to account for possibility that multiple distances may fall in the same bin
    
    % expand back to full range, multiply with pdfC and sum up to get probability that each item is selected for response based on cue
    cpC = pdfC .* [flip(gcdfC, 1); gcdfC]; % cpC(i, j) = probability that decoded cue value for item j has distance d(i) from actual cue, and decoded values for all other items have greater distance
    pC = sum(cpC, 1); % pC(j) = probability that item j is selected for response generation for the given cue
    cpC = cpC ./ pC; % normalize cpC for each item (pC is factored in again at the end)
    % now cpC(i, j) is the conditional probability that the decoded cue feature value of item j is d(i) if item j is selected for response generation
    cpC(isnan(cpC)) = 0;
    pC = pC ./ sum(pC, 2); % re-normalize pC (deviations may have been introduced by discretization)
    
    
    %% shift probability distributions back to be centered on 0
    
    % Another manual linear interpolation that reverts the alignment performed
    % above, so distributions over cue feature space are positioned as if each
    % item's actual cue value was zero.
    
    dcpC = cpC - circshift(cpC, 1, 1); % difference matrix for linear interpolation
    I = mod(iTheta - idC(k, :) - 1, nTheta) + 1; % index matrix
    I = I + (0:nItems-1) * nTheta; % take into account item number in index matrix
    cpC = cpC(I) - rdC(k, :) .* dcpC(I); % interpolation to shift cpC back
    acpC = cpC(nTheta/2+1:end, :, :) + flip(cpC(1:nTheta/2, :, :), 1); % flip over to reduce to half range again
    
    
    %% conditional probability that each item has certain sample count if it is selected for response
    
    pSCS = sum(psceC .* reshape(acpC', [1, nItems, nTheta/2]), 3); % sample counts in 3rd dimension
    pSCS = pSCS ./ sum(pSCS, 1); % pSCS(i, j) is probabily that item j has sample count counts(i) if it is selected for response
    % pSCS and er (below) are nCounts x nItems
    
    
    %% compute response probability distributions and align to target and non-targets
    
    pdfRh = pC .* reshape(sum(reshape(pSCS, [nCounts, 1, nItems]) .* eR, 1), [nTheta/2, nItems]); % response pdfs centered on each item, size nItems x nTheta
    pdfR = [flipud(pdfRh); pdfRh]; % extend to full range
    
    dpdfR = pdfR - circshift(pdfR, 1, 1);
    I = mod(iTheta + idR(k, :, :) - 1, nTheta) + 1;
    I = I + reshape(0:nItems-1, [1, 1, nItems]) * nTheta;
    apdfR = pdfR(I) + rdR(k, :, :) .* dpdfR(I); % pdf for each item, and aligned to each item
    spdfR = sum(apdfR, 3)';
    spdfR = spdfR ./ (sum(spdfR, 2) * dTheta); % normalize pdf
    
    pdfAll = pdfAll + 1/nTrials * spdfR;
    pCAll(k, :) = pC;
end


%% finalize results

pdfT = pdfAll(1, :);
pdfNT = mean(pdfAll(2:end, :), 1);

% determine distribution of all T - NT values over all trials, and convolve it
% with the response distributions relative to the target to get expected
% response distribution around non targets if there were no swap errors
idTNT = reshape(idR(:, 1, 2:end), [], 1); 
rdTNT = reshape(rdR(:, 1, 2:end), [], 1);

distTNT = (accumarray(mod(nTheta/2 + idTNT, nTheta+1) + 1, 1 - rdTNT, [nTheta+1, 1]) ...
    + accumarray(mod(nTheta/2 + idTNT + 1, nTheta+1) + 1, rdTNT, [nTheta+1, 1]))';
distTNTe = distTNT([nTheta/2+3:end, 1:end, 1:nTheta/2-1]);
pdfNT_expNoSwaps = conv(distTNTe, pdfT, 'valid');
pdfNT_expNoSwaps = pdfNT_expNoSwaps ./ (sum(pdfNT_expNoSwaps) * dTheta);


