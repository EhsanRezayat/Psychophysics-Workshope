% This script demonstrates how to fit the neural resource model /
% stochastic sampling model to behavioral data from delayed reproduction
% tasks, and how to plot the fits.
%
% Sebastian Schneegans and Paul Bays | bayslab.com | 2020-08-10
% Licence GPL-2.0
% 
% Refs: Bays, JNeurosci 34(10), 2014; Bays, JoV 16(11), 2016; Schneegans,
% Taylor, & Bays, PNAS, 2020.


%% settings

% plot settings
nBins = 25; % for data histograms
nTheta = 1000; % sampling points for plotting model fits

% trial settings
setSizes = [1, 2, 4, 8];
nTrials = 1000; % per set size
minDistance = 0.01; % minimum distance between items' feature values

% model settings for simulated data
kappa = 2.5;
gamma = 10;
pNT = 0.05; % probability of swap errors per non-target
exactCircularMLE = true;


%% generate trials and response data

% we use simulated data based on the neural resource model as placeholder
% for actual behavioral data; the data set generated here would correspond
% to the behavioral data of a single subject in a delayed reproduction
% task
[response, ~, ~, target, nonTargets, nItems] = ...
    simulateDataNeuralModel(kappa, gamma, pNT, [], [], exactCircularMLE, 1, setSizes, nTrials, minDistance);

error = wrap(response - target);
ntErrors = wrap(response - nonTargets);
nSetSizes = numel(setSizes);


%% prepare histogram bins and sampling points

binEdges = linspace(-pi, pi, nBins+1);
binCenters = binEdges(1:end-1) + diff(binEdges)/2;
theta = linspace(-pi, pi, nTheta);


%% fit error distribution for a single set size

n = 1; % set size to fit and plot

% maximum likelihood fit of trials with set size n
b = fminsearch(@(B) -sum(log(pNeuralModel(error(nItems == n), B(1), B(2)))), [5, 5], optimset('Display', 'iter'));

% histogram for plotting the data
ht = histcounts(error(nItems == n), binEdges, 'Normalization', 'pdf');

figure('Name', sprintf('Fit of error distribution at set size %d', n)); hold on;
bar(binCenters, ht, 1, 'FaceAlpha', 0.1);
plot(theta, pNeuralModel(theta, b(1), b(2)), 'r'); % plot error distribution of model with ML parameters
set(gca, 'XLim', [-pi, pi], 'YLim', [0, 2]);


%% use a normalization (neural resource) model to fit data from multiple set-sizes simultaneously

% fit data using llNeuralSwap, which calls pNeuralModel for each set size with
% gamma parameter scaled appropriately (swap rate set to zero for now)
b = fminsearch(@(B) -llNeuralSwap(response, target, [], nItems, B(1), B(2), 0), ...
    [5, 5], optimset('Display', 'iter'));

% % alternatively, construct function to be minimized by hand:
% b2 = fminsearch(@(B) -(sum(log(pNeuralModel(error(nItems == 1), B(1), B(2)))) ...
%                      + sum(log(pNeuralModel(error(nItems == 2), B(1), B(2)/2))) ...
%                      + sum(log(pNeuralModel(error(nItems == 4), B(1), B(2)/4))) ...
%                      + sum(log(pNeuralModel(error(nItems == 8), B(1), B(2)/8)))), [5, 5], optimset('disp', 'iter'));

figure('Name', 'Combined fit for all set sizes');
for i = 1 : nSetSizes
    n = setSizes(i);
    ht = histcounts(error(nItems == n), binEdges, 'Normalization', 'pdf');
    
    subplot(floor(sqrt(nSetSizes)), ceil(sqrt(nSetSizes)), i); hold on;
    bar(binCenters, ht, 1, 'FaceAlpha', 0.1); 
    plot(theta, pNeuralModel(theta, b(1), b(2)/n), 'r');
    title(sprintf('set size %d', n));
    set(gca, 'XLim', [-pi, pi], 'YLim', [0, 2]);
end


%% fit model with swap errors to error distribution at a single set size

n = 8;
I = nItems == n;
b = fminsearch(@(B) -llNeuralSwap(response(I), target(I), nonTargets(I, 1:n-1), nItems(I), B(1), B(2), B(3)), ...
    [5 5 0.1], optimset('Display', 'iter'));

ht = histcounts(error(I), binEdges, 'Normalization', 'pdf');
hnt = histcounts(ntErrors(I, 1:n-1), binEdges, 'Normalization', 'pdf');

figure('Name', sprintf('Fit with swap errors for set size %d', n));
subplot(1, 2, 1); hold on;
bar(binCenters, ht, 1, 'FaceAlpha', 0.1);
plot(theta, (1 - b(3)*(n-1)) * pNeuralModel(theta, b(1), b(2)/n) + b(3)*(n-1)/(2*pi), 'r');
set(gca, 'XLim', [-pi, pi], 'YLim', [0, 0.75]);
title('target error');

subplot(1, 2, 2); hold on;
bar(binCenters, hnt, 1, 'FaceAlpha', 0.1);
plot(theta, b(3) * pNeuralModel(theta, b(1), b(2)/n) + (1 - b(3))/(2*pi), 'r');
set(gca, 'XLim', [-pi, pi], 'YLim', [0.1, 0.25]);
title('non-target error');


%% fit neural resource model with swap errors to all set sizes simultaneously 

b = fminsearch(@(B) -llNeuralSwap(response, target, nonTargets, nItems, B(1), B(2), B(3)), ...
    [5 5 0.1], optimset('Display', 'iter'));

figure('Name', 'Combined fit for all set sizes with swap errors');
set(gcf, 'Position', get(gcf, 'Position') .* [1, 1, 1.5, 1]); % scale up figure horizontally
for i = 1 : nSetSizes
    n = setSizes(i);
    I = nItems == n;
    ht = histcounts(error(I), binEdges, 'Normalization', 'pdf');
    
    subplot(2, nSetSizes, i); hold on;
    bar(binCenters, ht, 1, 'FaceAlpha', 0.1); 
    plot(theta, pNeuralModel(theta, b(1), b(2)/n), 'r');
    title(sprintf('target error, set size %d', n));
    set(gca, 'XLim', [-pi, pi], 'YLim', [0, 2]);
    
    if n > 1
        hnt = histcounts(ntErrors(I, 1:n-1), binEdges, 'Normalization', 'pdf');
        
        subplot(2, nSetSizes, nSetSizes + i); hold on;
        bar(binCenters, hnt, 1, 'FaceAlpha', 0.1);
        plot(theta, b(3) * pNeuralModel(theta, b(1), b(2)/n) + (1 - b(3))/(2*pi), 'r');
        set(gca, 'XLim', [-pi, pi], 'YLim', [0.1, 0.25]);
        title(sprintf('non-target error, set size %d', n));
    end
    
end


%% fit simplified sampling model with swap errors
% use faster approximation of maximum likelihood estimation in circular
% space (setting the optional last parameter of llNeuralSwap to false)

b = fminsearch(@(B) -llNeuralSwap(response, target, nonTargets, nItems, B(1), B(2), B(3), false), ...
    [5 5 0.1], optimset('Display', 'iter'));

figure('Name', 'Combined fit for all set sizes with swap errors, simplified model');
set(gcf, 'Position', get(gcf, 'Position') .* [1, 1, 1.5, 1]); % scale up figure horizontally
for i = 1 : nSetSizes
    n = setSizes(i);
    I = nItems == n;
    ht = histcounts(error(I), binEdges, 'Normalization', 'pdf');
    
    subplot(2, nSetSizes, i); hold on;
    bar(binCenters, ht, 1, 'FaceAlpha', 0.1); 
    plot(theta, pNeuralModel(theta, b(1), b(2)/n), 'r');
    title(sprintf('target error, set size %d', n));
    set(gca, 'XLim', [-pi, pi], 'YLim', [0, 2]);
    
    if n > 1
        hnt = histcounts(ntErrors(I, 1:n-1), binEdges, 'Normalization', 'pdf');
        
        subplot(2, nSetSizes, nSetSizes + i); hold on;
        bar(binCenters, hnt, 1, 'FaceAlpha', 0.1);
        plot(theta, b(3) * pNeuralModel(theta, b(1), b(2)/n) + (1 - b(3))/(2*pi), 'r');
        set(gca, 'XLim', [-pi, pi], 'YLim', [0.1, 0.25]);
        title(sprintf('non-target error, set size %d', n));
    end
end


