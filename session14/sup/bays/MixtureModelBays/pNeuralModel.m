function p = pNeuralModel(dx, kappa, xi, exactCircularMLE, nr)
%PNEURALMODEL Determines response probabilities in neural population model.
%   P = PNEURALMODEL(DX, KAPPA, XI) computes the probability densities P of
%   obtaining decoding errors DX in maximum likelihood decoding from an
%   idealized neural population, assuming von Mises tuning curves with
%   concentration parameter KAPPA and Poisson spiking with spike rate XI
%   (for a single encoded item). Values in DX must be in radians and are
%   assumed to be drawn from circular feature space over [-pi, pi). DX may
%   be a matrix of any size, and both KAPPA and XI must be scalars. The
%   result is computed as probability of resultant direction of a random
%   walk where each step is chosen from a von Mises distribution with mean
%   0 and concentration KAPPA, and the number of steps is Poisson
%   distributed with mean XI.
%   
%   P = PNEURALMODEL(DX, KAPPA, XI, EXACTCIRCULARMLE) allows switching
%   between exact decoding of maximum likelihood values in circular space
%   (default, EXACTCIRCULARMLE = true), and a simplified approach that
%   treats the feature space as if it was linear in order to determine the
%   effect of the number of spikes/samples on decoding precision
%   (EXACTCIRCULARMLE = false). The latter allows much faster computation
%   of probabilities, but can deviate substantially from exact decoding for
%   small values of KAPPA.
%   
%   P = PNEURALMODEL(DX, KAPPA, XI, EXACTCIRCULARMLE, NR) uses NR sampling
%   points over the space of resultant vector lengths for numerical
%   computions (applies to exact circular MLE method only).
%   
%   Sebastian Schneegans and Paul Bays | bayslab.com | 2020-08-10
%   Licence GPL-2.0
%   
%   Refs: Bays, J Neurosci 34(10), 2014; Bays, JoV 16(11), 2016; Schneegans,
%   Taylor, & Bays, PNAS, 2020.


if kappa < 0 || xi < 0
    p = NaN(size(dx));
    return;
end

if nargin < 4 || isempty(exactCircularMLE)
    exactCircularMLE = true;
end
if nargin < 5
    nr = []; % use default value in vmwalklengthpdf function
end

pBounds = 10^-4/2;

% determine dx and reshape to column vector (result will be reshaped to
% original size of x a the end)
sz = size(dx);
dx = reshape(dx, 1, []);

% determine range of sample counts to consider, and their probability
nLim = max(poissinv([pBounds, 1-pBounds], xi), [0, 1]);
ns = (nLim(1) : nLim(2)); % range of sample counts to be considered
cn = poisscdf(ns, xi);
pn = diff([0, cn(1:end-1), 1]); % probabilities of sample counts

% determine probabilities for each sample count and compute weighted sum
if exactCircularMLE
    [rrk, pr, bir] = vmwalklengthpdf(kappa, ns, nr);
    pv = exp(kappa .* rrk' .* cos(dx) - bir' - log(2*pi));
    p = pn * pr * pv;
else
    kk = j2k_interp(k2j(kappa) .* ns');
    pv = exp(kk .* cos(dx) - log(2*pi) - besseliln(0, kk));
    p = pn * pv;
end

% resize to input dimensions
p = reshape(p, sz);

