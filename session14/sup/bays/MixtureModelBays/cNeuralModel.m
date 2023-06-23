function c = cNeuralModel(x, kappa, xi, exactCircularMLE, nr)
%CNEURALMODEL Determines cumulative density function for response values in
%neural population model.
%   C = CNEURALMODEL(X, KAPPA, XI) computes the cumulative density of
%   decoding errors X in maximum likelihood decoding from an idealized
%   neural population, assuming von Mises tuning curves with concentration
%   parameter KAPPA and Poisson spiking with spike rate XI (for a single
%   encoded item). Values in X must be in radians and are assumed to be
%   drawn from circular feature space over [-pi, pi). X may be a matrix of
%   any size, and both KAPPA and XI must be scalars. The result is computed
%   as probability of resultant direction of a random walk where each step
%   is chosen from a von Mises distribution with mean 0 and concentration
%   KAPPA, and the number of steps is Poisson distributed with mean XI.
%   
%   C = CNEURALMODEL(X, KAPPA, XI, EXACTCIRCULARMLE) allows switching
%   between exact decoding of maximum likelihood values in circular space
%   (default, EXACTCIRCULARMLE = true), and a simplified approach that
%   treats the feature space as if it was linear in order to determine the
%   effect of the number of spikes/samples on decoding precision
%   (EXACTCIRCULARMLE = false). The latter allows much faster computation
%   of probabilities, but can deviate substantially from exact decoding for
%   small values of KAPPA.
%   
%   C = CNEURALMODEL(X, KAPPA, XI, EXACTCIRCULARMLE, NR) uses NR sampling
%   points over the space of resultant vector lengths for numerical
%   computions (applies to exact circular MLE method only).
%   
%   Sebastian Schneegans and Paul Bays | bayslab.com | 2020-08-10
%   Licence GPL-2.0
%   
%   Refs: Bays, JNeurosci 34(10), 2014; Bays, JoV 16(11), 2016; Schneegans,
%   Taylor, & Bays, PNAS, 2020.


if nargin < 4 || isempty(exactCircularMLE)
    exactCircularMLE = true;
end
if nargin < 5
    nr = []; % use default value of vmwalkpdfs function
end

pBounds = 10^-4/2;

% determine dx and reshape to column vector (result will be reshaped to
% original size of x a the end)
sz = size(x);
x = reshape(x, 1, []);

% determine range of sample counts to consider, and their probability
nLim = max(poissinv([pBounds, 1-pBounds], xi), [0, 1]);
ns = (nLim(1) : nLim(2)); % range of spike counts to be considered
cn = poisscdf(ns, xi);
pn = diff([0, cn(1:end-1), 1]); % probabilities of spike counts

% determine probabilities for each sample count and compute weighted sum
if exactCircularMLE
    [rrk, pr] = vmwalklengthpdf(kappa, ns, nr);
    nr = numel(rrk);
    cv = NaN(nr, numel(x));
    for i = 1 : numel(rrk)
        cv(i, :) = vonmisescdf(x, 0, kappa * rrk(i));
    end
    c = pn * pr * cv;
else
    kk = j2k_interp(k2j(kappa) .* ns');
    cv = NaN(nr, numel(x));
    for i = 1 : numel(kk)
        cv(i, :) = vonmisescdf(x, 0, kk(i));
    end
    c = pn * cv;
end

% resize to input dimensions
c = reshape(c, sz);

