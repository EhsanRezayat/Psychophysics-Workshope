function [rrk, pr, bir] = vmwalklengthpdf(k, n, nr)
%VMWALKLENGTHPDF  Distribution of resultant vector lengths in von Mises
%random walk.
%   [RRK, PR] = VMWALKLENGTHPDF(K, N) determines the probability density PR
%   over resultant lengths RRK for a von Mises random walk with N steps and
%   a concentration parameter K. Both K and N may be vectors, and PR will
%   be of size numel(N) x M x numel(K), where M is the size of the row
%   vector RRK.
%   
%   [RRK, PR] = VMWALKLENGTHPDF(K, N, NR) uses NR sampling points over the
%   space of resultant lengths (RRK will have NR+2 entries, with 0 and 1
%   added to represent results for N = 0 or N = 1 with high precision.
%   
%   [RRK, PR, BIR] = VMWALKLENGTHPDF(...) additionally returns the
%   logarithm of the modified bessel function of the first kind with order
%   zero for all values in RRK (besseliln(0, RRK)). This can be used in
%   computing the pdf of the resultant direction of the random walk.
%   
%   Sebastian Schneegans and Paul Bays | bayslab.com | 2020-08-10
%   Licence GPL-2.0
%   
%   Refs: Bays, JNeurosci 34(10), 2014; Bays, JoV 16(11), 2016; Schneegans,
%   Taylor, & Bays, PNAS, 2020.


persistent kluyver_density_ext
if ~isstruct(kluyver_density_ext)
    fprintf('Loading kluyver_density.mat ...\n');
    kluyver_density_ext = load('kluyver_density.mat');
    
    nmle = size(kluyver_density_ext.mle, 1);
    kluyver_density_ext.dr = diff(kluyver_density_ext.rr(1:2));
    
    % using reverse cumulative sum because values in mle at the end of the
    % rr range get extremely small, would cause numerical errors with
    % forward cumulative sum
    kluyver_density_ext.rcmle = [cumsum(kluyver_density_ext.mle, 2, 'reverse'), zeros(nmle, 1)]; % reverse cumulative mles
    s = kluyver_density_ext.rcmle(:, 1) ./ kluyver_density_ext.nr .* (1:nmle)';
    kluyver_density_ext.rcmle = kluyver_density_ext.rcmle ./ s;
    kluyver_density_ext.emle = [kluyver_density_ext.mle ./ s, zeros(nmle, 1)];
end

if nargin < 3 || isempty(nr)
    nr = kluyver_density_ext.nr;
end

% reshape inputs
n = reshape(n, [], 1);
nk = numel(k);
k = reshape(k, [1, 1, nk]);

% ranges of n and r
nMin = min(n);
nMax = max(n);
rr = linspace(0, nMax, nr + 1);
rrk = rr(1:end-1) + diff(rr)/2;

% pre-compute some values that are needed more than once
bik = besseliln(0, k);
bir = besseliln(0, k .* rrk);
kdMaxN = size(kluyver_density_ext.mle, 1);

% prepare weight matrix for mixture of von Mises distributions
pr = zeros(numel(n), nr+2, nk);

% special cases n = 0 or n = 1
pr(n == 0, 1, :) = 1;
pr(n == 1, 2, :) = 1;

% manual linear interpolation for intermediate values of n
if nMax > 1 && nMin <= kdMaxN
    I = n > 1 & n <= kdMaxN;
    nn_ip = n(I);
    
    rrs = (rr ./ nn_ip) / kluyver_density_ext.dr + 1;
    irrs = floor(rrs); % index matrix for interpolation (columns only)
    drrs = rrs - irrs; % factors for difference matrix
    jrrs = (min(irrs, kluyver_density_ext.nr+1) - 1) .* kdMaxN + nn_ip; % limit to valid range and take into account rows
    
    prk = - diff(kluyver_density_ext.rcmle(jrrs) - drrs .* kluyver_density_ext.emle(jrrs), [], 2);
    pra = exp(bir - nn_ip .* bik) .* prk;
    pra(isnan(pra)) = 0;
    pr(I, 3:end, :) = pra ./ sum(pra, 2);
end

% Gaussian approximation for large n
if nMax > kdMaxN
    I = n > kdMaxN;
    nn_ga = n(I);

    m = nn_ga .* besseli(1,k) ./ exp(bik);
    s2 = nn_ga .* (0.5 + 0.5 * exp(besseliln(2, k) - bik) - exp(2 * besseliln(1,k) - 2 * bik));
    pra = normpdf(rrk, m, sqrt(s2));
    pr(I, 3:end, :) = pra ./ sum(pra, 2);
end

rrk = [0, 1, rrk];
bir = [zeros(1, 1, nk), bik, bir];

