function r = randMinDistance(sz, range, minDistance, circular)
% RANDMINDISTANCE  Random numbers with minimum distance between them.
%   
%   RANDMINDISTANCE(N, RANGE, MINDISTANCE, CIRCULAR) returns a column
%   vector of N random numbers [r_1, ..., r_N], uniformly distributed
%   within a range specified as vector [MIN, MAX], with |r_i - r_j| >=
%   MINDISTANCE for i ~= j. CIRCULAR is a boolean specifying whether
%   minDistance should also apply across the ends of the range (default is
%   true).
%   
%   RANDMINDISTANCE([M, N, P, ...], ...) returns an M-by-N-by-P-by-...
%   array of random numbers where the minimum distance applies within the
%   first dimension.
%   
%   Sebastian Schneegans | bayslab.com | Licence GPL-2.0 | 2020-08-10

n = sz(1);
m = prod(sz(2:end));

if circular
    l = range(2) - range(1) - n * minDistance;
    
    if l < 0
        error('randMinDistance:invalidArguments', 'Range too small to draw n numbers with minDistance.');
    end
    
    r = rand(n, m) * l;
    [s, I] = sort(r, 1);
    s = s + (0:n-1)' * minDistance;
    
    I = sub2ind([n, m], I, repmat(1:m, [n, 1]));
    r(I) = s;
    r = mod(r + diff(range) * rand([1, m]), diff(range)) + range(1);
else
    l = range(2) - range(1) - (n-1) * minDistance;
    
    if l < 0
        error('randMinDistance:invalidArguments', 'Range too small to draw n numbers with minDistance.');
    end
    
    r = rand([n, m]) * l;
    [s, I] = sort(r, 1);
    s = s + (0:n-1)' * minDistance;
    
    I = sub2ind([n, m], I, repmat(1:m, [n, 1]));
    r(I) = s + range(1);
end

if numel(sz) > 1
    r = reshape(r, sz);
end
