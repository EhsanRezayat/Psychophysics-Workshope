function K = fastA1inv(R)
% FASTA1INV Fast approximation to A1INV 
%   K = FASTA1INV(R) returns a fast approximation of the solution of 
%   R = besseli(1,K) / besseli(0,K)

K = nan(size(R));

ix = R >= 0 & R < 0.53;
K(ix) = 2 * R(ix) + R(ix).^3 + (5 * R(ix).^5)/6;

ix = R >= 0.53 & R < 0.85;
K(ix) = -0.4 + 1.39 * R(ix) + 0.43./(1 - R(ix));

ix = R >= 0.85 & R <= 1;
K(ix) = 1./(R(ix).^3 - 4 * R(ix).^2 + 3 * R(ix));

