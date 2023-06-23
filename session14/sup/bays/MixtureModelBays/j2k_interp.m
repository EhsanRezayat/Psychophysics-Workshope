function k = j2k_interp(j)
%J2K_INTERP Convert precision to concentration parameter.
%   K = J2K_INTERP(K) returns the concentration parameter for a von Mises
%   distribution that corresponds to a precision value J (in Fisher
%   information).
%   
%   The result is determined by spline interpolation from a table of J and
%   K values. The piecewise polynomial of the interpolant is computed as
%   persistent variable during the first function call, so the first call
%   of the function may be slow.
%
%   Sebastian Schneegans | bayslab.com | Licence GPL-2.0 | 2020-08-10

persistent J2K_PP

if isempty(J2K_PP)
    tableK = logspace(log10(0+1), log10(700+1), 1000) - 1;
    tableK([1, end]) = [0, 700];
    tableJ = tableK .* besseli(1, tableK) ./ besseli(0, tableK);
    J2K_PP = spline(sqrt(tableJ), tableK); % taking sqrt improves spline fit by avoiding infinite slope at 0
end

k = NaN(size(j));

maxK = 700;
I = j <= maxK & j ~= 0;
% k(I) = interp1(tableJ, tableK, j(I), 'spline');
k(I) = ppval(J2K_PP, sqrt(j(I)));

k(~I) = j(~I);
k(j < 0) = NaN;
k(k < 0) = 0;

