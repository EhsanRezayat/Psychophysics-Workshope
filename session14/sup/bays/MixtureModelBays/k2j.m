function j = k2j(k)
%K2J Convert concentration parameter to precision.
%   J = K2J(K) returns the precision value J (in Fisher information) that
%   corresponds to a concentration parameter K in a von Mises distribution.
%   
%   Sebastian Schneegans | bayslab.com | Licence GPL-2.0 | 2020-08-10

j = k .* besseli(1, k) ./ besseli(0, k);
j(k > 700) = k(k > 700);