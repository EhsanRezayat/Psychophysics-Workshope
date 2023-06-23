function [X, II, SC, MR, MC] = simulateDataNeuralBinding(gamma, kappaReport, kappaCue, sampleCountAdjustment, ...
    MR, C, MC, exactCircularMLE, nReps, nTrials, nItems, minDistance)
%SIMULATEDATANEURALBINDING  Simulate responses from neural binding model.
%   X = SIMULATEDATANEURALBINDING(GAMMA, KAPPAREPORT, KAPPACUE,
%   SAMPLECOUNTADJUSTMENT, MR, C, MC) generates a column vector X of
%   response values from a neural binding model with parameters GAMMA,
%   KAPPAREPORT, KAPPACUE, and SAMPLECOUNTADJUSTMENT (optional, default is
%   0) for trials with report feature values MR, given cue value C, and cue
%   feature values MC. MR and MC must be NTRIALS x NITEMS matrices, and C
%   must be a NTRIALS x 1 vector. X will be of size NTRIALS x 1.
%   
%   X = SIMULATEDATANEURALBINDING(..., EXACTCIRCULARMLE, NREPS) specifies
%   whether the exact method for maximum likelihood estimation in circular
%   feature spaces should be used (slower; default is true), and produces
%   NREPS independently drawn responses for each trial. X is then of size
%   NTRIALS x NREPS.
%   
%   [X, I, SC] = SIMULATEDATANEURALBINDING(...) additionally returns the
%   NTRIALS x NREPS matrix I with the index of the item selected for
%   response generation in each trial, and the NTRIALS x NREPS x 2 matrix
%   SC yielding the number of samples the selected item had in the cue and
%   report dimension (SC(:, :, 1) for cue, SC(:, :, 2) for report; if
%   sampleCountAdjustent == 0, the values are identical).

%   [X, I, SC, MR, C, MC] = SIMULATEDATANEURALBINDING(GAMMA, KAPPAREPORT,
%   KAPPACUE, SCA, [], [], [], ECMLE, NREPS, NTRIALS, NITEMS, MINDISTANCE)
%   additinally generates the trial data, based on the given number of
%   trials, number of memory items per trial, and a minimum distance in
%   feature space between items (optional, default is 0). If MINDISTANCE is
%   a two-element vector, the first entry is the distance in report feature
%   space, the second in cue feature space. The given cue is assumed to be
%   the first entry in MC for each trial. The resulting matrix of response
%   values has size NTRIALS x NREPS.
%   
%   Sebastian Schneegans and Paul Bays | bayslab.com | 2020-08-10
%   Licence GPL-2.0
%   
%   Refs: Bays, JNeurosci 34(10), 2014; Bays, JoV 16(11), 2016; Schneegans
%   & Bays, JNeurosci, 37(14), 2017; Schneegans, Taylor, & Bays, PNAS,
%   2020.


%% check arguments

if (isempty(MR) || isempty(MC) || isempty(C)) && (nargin < 11 || isempty(nTrials) || isempty(nItems))
    error('Either the trial data must be given, or the number of trials and items be specified.');
end
if isempty(sampleCountAdjustment)
    sampleCountAdjustment = 0;
end
if nargin < 8 || isempty(exactCircularMLE)
    exactCircularMLE = true;
end
if nargin < 9 || isempty(nReps)
    nReps = 1;
end


%% generate trial data based on nTrials, nItems, and minDistance if no data is given

if isempty(MR)
    if nargin < 11 || isempty(minDistance)
        minDistanceR = 0;
        minDistanceC = 0;
    elseif numel(minDistance) == 1
        minDistanceR = minDistance;
        minDistanceC = minDistance;
    elseif numel(minDistance) == 2
        minDistanceR = minDistance(1);
        minDistanceC = minDistance(2);
    else
        error('Argument minDistance must be a scalar or a two-element vector.');
    end
    
    MR = randMinDistance([nItems, nTrials], [-pi, pi], minDistanceR, true)';
    MC = randMinDistance([nItems, nTrials], [-pi, pi], minDistanceC, true)';
    C = MC(:, 1);
else
    nTrials = size(MR, 1);
    nItems = size(MR, 2);
end

nTheta = 1000;
theta = linspace(-pi, pi, nTheta + 1);


%% generate responses for trial data

X = NaN(nTrials, nReps);
II = NaN(nTrials, nReps);
SC = NaN(nTrials, nReps, 2);

for r = 1 : nReps
    % draw spike counts for each item from Poisson distribution
    sampleCounts = poissrnd(gamma/nItems, [nTrials, nItems]);
    
    if sampleCountAdjustment <= 0
        sampleCountsC = sampleCounts;
        sampleCountsR = binornd(sampleCounts, 1 + sampleCountAdjustment);
    else
        sampleCountsC = binornd(sampleCounts, 1 - sampleCountAdjustment);
        sampleCountsR = sampleCounts;
    end
    
    scRange = unique([sampleCountsR; sampleCountsC]);
    
    % prepare error distributions
    if exactCircularMLE
        [rrk, pr, bir] = vmwalklengthpdf([kappaCue, kappaReport], scRange);
        pdfC = pr(:, :, 1) * exp(kappaCue .* rrk' .* cos(theta) - bir(:, :, 1)' - log(2*pi));
        pdfR = pr(:, :, 2) * exp(kappaReport .* rrk' .* cos(theta) - bir(:, :, 2)' - log(2*pi));
    end
    
    % determine decoded feature values in each repetition
    XC = NaN(size(sampleCounts));
    XR = NaN(size(sampleCounts));
    
    for i = 1 : numel(scRange)
        sc = scRange(i);
        IC = sampleCountsC == sc;
        nIC = sum(IC(:));
        IR = sampleCountsR == sc;
        nIR = sum(IR(:));
        
        if exactCircularMLE
            XC(IC) = randFromPdf(theta, pdfC(i, :), nIC);
            XR(IR) = randFromPdf(theta, pdfR(i, :), nIR);
        else
            XC(IC) = randvonmises(nIC, 0, j2k_interp(sc*k2j(kappaCue)));
            XR(IR) = randvonmises(nIR, 0, j2k_interp(sc*k2j(kappaReport)));
        end
    end
    XC = wrap(XC + MC);
    XR = wrap(XR + MR);
    
    % select item with decoded value closest to cue
    [~, I] = min(abs(wrap(XC - C)), [], 2);
    X(:, r) = pickFromRows(XR, I);
    II(:, r) = I;
    
    SC(:, r, :) = cat(3, pickFromRows(sampleCountsC, I), pickFromRows(sampleCountsR, I));
end

