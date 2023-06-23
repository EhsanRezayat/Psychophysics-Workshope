function r = randFromPdf(x, p, n)
%RANDFROMPDF  Draw random numbers from piecewise-linear distribution.
%   R = RANDFROMPDF(X, P, N) draws N random numbers from a continuous
%   probability distribution that is specified by probability values P at
%   sampling points X, with linear interpolation between sampling points. X and
%   P must be of the same size, and X must be strictly increasing. P will be
%   normalized such that it integrates to one over the range [X(1), X(end)]. If
%   N is a vector, R will be a matrix with size(R) equal to N.
%   
%   Sebastian Schneegans | bayslab.com | Licence GPL-2.0 | 2020-08-10

x = x(:);
p = p(:);
if numel(x) ~= numel(p)
    error('Arguments X and P must have the same size.');
end
m = prod(n);

rnd = rand(m, 3); % one rand to select bin, one to choose between uniform and linear part, one to choose value within bin

dx = diff(x);
pb = (p(1:end-1) + p(2:end))/2; % mean probability in each bin

cp = [0; cumsum(pb .* dx)]; % cumulative sum of total probability for each bin
cp = cp / cp(end);
[~, ~, bins] = histcounts(rnd(:, 1), cp);

dp = diff(p);
sdp = sign(dp);
sdp(sdp == 0) = 1;

q = abs(dp) ./ (2*pb); % proportion of linear component

r = rnd(:, 3);
I = rnd(:, 2) < q(bins); % choose from linear component
r(I) = sqrt(r(I));

x2 = x(2:end);
x(sdp == -1) = x2(sdp == -1);
r = x(bins) + sdp(bins) .* r .* dx(bins);

if numel(n) > 1
    r = reshape(r, n);
end
