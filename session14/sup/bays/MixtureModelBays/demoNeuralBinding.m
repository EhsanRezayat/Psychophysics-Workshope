% Simulate response data from neural binding model, then perform maximum
% likelihood fit of simulated data with the model (parameter recovery), and
% plot the results.
% 
% Sebastian Schneegans and Paul Bays | bayslab.com | 2020-08-10
% Licence GPL-2.0
% 
% Refs: Bays, JNeurosci 34(10), 2014; Bays, JoV 16(11), 2016; Schneegans &
% Bays, JNeurosci, 37(14), 2017; Schneegans, Taylor, & Bays, PNAS, 2020.


%% settings

% model parameters
gamma = 8;
kappaReport = 8;
kappaCue = 2;

exactCircMLE = true;

% bins for plotting response distributions
nBins = 51;
binEdges = linspace(-pi, pi, nBins+1);
binCenters = (binEdges(1:end-1) + binEdges(2:end))/2;

% trial settings
nReps = 1;
nTrials = 1000;
nItems = 4;
minDist = pi/4; % minimum distance between feature values within a trial

nTheta = 360;


%% generate data and compute response distribution

[X, ~, ~, MR, MC] = simulateDataNeuralBinding(gamma, kappaReport, kappaCue, 0, [], [], [], ...
    exactCircMLE, nReps, nTrials, nItems, minDist);
histT = histcounts(wrap(X - MR(:, 1)), binEdges, 'Normalization', 'pdf');
histNT = histcounts(wrap(X - reshape(MR(:, 2:end), [nTrials, 1, nItems-1])), binEdges, 'Normalization', 'pdf');

histNT_exp = zeros(1, nBins); % expected NT distributions if there were no swap errors
for i = 1 : nReps
    histNT_exp = histNT_exp + 1/nReps * expectedNonTargetDeviation(X(:, i), MR(:, 1), MR(:, 2:end), binEdges);
end


%% fit neural binding model to simulated data

b = fminsearch(@(B) -sum(log(pNeuralBinding(X(:, 1), MR, MC(:, 1), MC, B(1), B(2), B(3), exactCircMLE))), ...
    [5, 5, 5], optimset('Display', 'iter'));


%% get exact response distributions for original data and fit

[pdfT, pdfNT, pdfNT_exp, theta] ...
    = errorDistributionNeuralBinding(MR, MC(:, 1), MC, gamma, kappaReport, kappaCue, exactCircMLE, nTheta);
[pdfT_fit, pdfNT_fit, pdfNT_exp_fit] ...
    = errorDistributionNeuralBinding(MR, MC(:, 1), MC, b(1), b(2), b(3), exactCircMLE, nTheta);


%% plot results

% plotting the response histograms of simulated data (black), the
% continuous distribution of response probabilities for the generating
% model (blue), and the same distribution with parameters found by maximum
% likelihood fit of the simulated data (red)

figure('Name', 'Simulated data and model fit');

subplot(3, 1, 1)
plot(binCenters, histT, '-k', theta, pdfT, '-b', theta, pdfT_fit, '-r');
set(gca, 'XLim', [-pi, pi]);
title('deviation from target'); ylabel('probability density');

subplot(3, 1, 2)
plot(binCenters, histNT, '-k', theta, pdfNT, '-b', theta, pdfNT_fit, '-r');
set(gca, 'XLim', [-pi, pi]);
title('deviation from non-targets'); ylabel('probability density');

% the final plot shows distribution of non-target deviations corrected for
% effects of minimum feature distance, obtained by subtracting the
% distribution expected in the absence of swap errors from the observed NT
% deviations
subplot(3, 1, 3)
plot(binCenters, histNT - histNT_exp, '-k', theta, pdfNT - pdfNT_exp, '-b', theta, pdfNT_fit - pdfNT_exp_fit, '-r');
set(gca, 'XLim', [-pi, pi]);
title('deviation from non-targets (corrected)'); ylabel('probability density');
xlabel('distance in feature space');

