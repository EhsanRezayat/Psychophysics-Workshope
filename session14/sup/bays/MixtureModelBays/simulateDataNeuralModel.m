function [X, iSelect, sampleCounts, T, NT, nItems] = ...
    simulateDataNeuralModel(kappa, gamma, pNT, T, NT, exactCircularMLE, nReps, setSizes, nTrials, minDistance)
%SIMULATEDATANEURALMODEL  Simulate responses from neural resource model.

%   X = SIMULATEDATANEURALMODEL(KAPPA, GAMMA, PNT, T, NT) generates a
%   column vector X of response values from a neural resource model with
%   parameters KAPPA (tuning curve concentration), GAMMA (mean total spike
%   rate), and PNT (swap rate per non-target item) for trials with target
%   feature values T and non-target feature values NT. T must be a column
%   vector, and NT must be a matrix with one row for each trial. NT may
%   contain NaNs if some trials have fewer than the maximum number of
%   non-target items. X will be of the same size as T.
%   
%   X = SIMULATEDATANEURALMODEL(..., EXACTCIRCULARMLE, NREPS) specifies
%   whether the exact method for maximum likelihood estimation in circular
%   feature spaces should be used (slower; default is true), and produces
%   NREPS independently drawn responses for each trial. X is then of size
%   NTRIALS x NREPS.
%   
%   [X, I, SC] = SIMULATEDATANEURALMODEL(...) additionally returns the
%   NTRIALS x NREPS matrix I with the index of the item selected for
%   response generation in each trial (with the target being item 1), and
%   the NTRIALS x NREPS matrix SC yielding the number of spikes (or
%   samples) that were available for the selected item to decode the
%   response feature value.

%   [X, I, SC, T, NT, NITEMS] = SIMULATEDATANEURALMODEL(KAPPA, GAMMA, PNT,
%   [], [], ECMLE, NREPS, SETSIZES, NTRIALS, MINDISTANCE) additinally
%   generates the trial data, based on the given set sizes, number of
%   trials, number of repetitons of each trial, and a minimum distance in
%   feature space between items. The argument NTRIALS can either be a
%   vector of the same size as SETSIZES, specifying a different number of
%   trials for each set size, or a scalar. In the latter case, NTRIALS
%   trials are generated for each entry in SETSIZES.
%   
%   Sebastian Schneegans and Paul Bays | bayslab.com | 2020-08-18
%   Licence GPL-2.0
%   
%   Refs: Bays, JNeurosci 34(10), 2014; Bays, JoV 16(11), 2016; Schneegans,
%   Taylor, & Bays, PNAS, 2020.


%% check arguments

if nargin < 5
    NT = [];
end
if isempty(T) && (nargin < 9 || isempty(nTrials) || isempty(setSizes))
    error('Either the trial data must be given, or the number of trials and items be specified.');
end
if nargin < 6 || isempty(exactCircularMLE)
    exactCircularMLE = true;
end
if nargin < 7 || isempty(nReps)
    nReps = 1;
end

nTheta = 1000; % number of sampling points for error distributions with exactCircularMLE


%% generate trial data

if isempty(T)
    if nargin < 10 || isempty(minDistance)
        minDistance = 0;
    end
    
    % make sure set size and trial numbers are consistent, and set sizes are unique
    if numel(nTrials) == 1
        nTrials = repmat(nTrials, [numel(setSizes), 1]);
    elseif numel(nTrials) ~= numel(setSizes)
        error('Arguments setSizes and nTrials must have compatible sizes.');
    end 
    [setSizes, ~, I] = unique(setSizes);
    nTrials = accumarray(I, nTrials);
    
    nSetSizes = numel(setSizes);
    nTrialsTotal = sum(nTrials);
    
    % select 
    TNT = NaN(nTrialsTotal, max(setSizes));
    nItems = NaN(nTrialsTotal, 1);
    for i = 1 : nSetSizes
        n = setSizes(i);
        M = randMinDistance([n, nTrials(i)], [-pi, pi], minDistance, true)';
        
        m = sum(nTrials(1:i-1));
        TNT(m + 1 : m + nTrials(i), 1:n) = M;
        nItems(m + 1 : m + nTrials(i)) = n;
    end
    
    T = TNT(:, 1);
    NT = TNT(:, 2:end);
else
    nTrialsTotal = size(T, 1);
    TNT = [T, NT];
    nItems = sum(~isnan(TNT), 2);
        
    setSizes = 1 : size(TNT, 2);
    nTrials = histcounts(nItems, [setSizes, setSizes(end)+1]);
    nz = nTrials > 0;
    nTrials = nTrials(nz);
    setSizes = setSizes(nz);
    nSetSizes = numel(setSizes);
end


%% simulate responses

if gamma < 0 || kappa < 0 || pNT < 0 || (max(setSizes)-1)*pNT > 1
    error('Invalid parameter values.');
end

% determine sample count and reported item for each trial and rep
sampleCounts = NaN(nTrialsTotal, nReps);
iSelect = ones(nTrialsTotal, nReps);

for i = 1 : nSetSizes
    n = setSizes(i);
    I = nItems == n;
    sampleCounts(I, :) = poissrnd(gamma / n, [nTrials(i), nReps]);
    if pNT > 0
        p = [0, (1-(n-1)*pNT) + (0:n-1) * pNT]; % cumulative probabilities of selecting each item
        iSelect(I, :) = discretize(rand(nTrials(i), nReps), p);
    end
end
scRange = unique(sampleCounts);

% prepare error distributions
if exactCircularMLE
    theta = linspace(-pi, pi, nTheta);
    [rrk, pr, bir] = vmwalklengthpdf(kappa, scRange);
    pdf = pr * exp(kappa .* rrk' .* cos(theta) - bir(:, :, 1)' - log(2*pi));
end
    
% determine response error for each trial and rep, based on sample count
E = NaN(size(sampleCounts));
for i = 1 : numel(scRange)
    I = sampleCounts == scRange(i);
    nI = sum(I(:));
    
    if exactCircularMLE
        E(I) = randFromPdf(theta, pdf(i, :), nI);
    else
        E(I) = randvonmises(nI, 0, j2k_interp(scRange(i) * k2j(kappa)));
    end
end

% add response error to feature value of selected item
TNTt = TNT';
X = TNTt(iSelect' + (0:nTrialsTotal-1)*size(TNTt, 1))' + E;


