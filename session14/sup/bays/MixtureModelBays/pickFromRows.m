function out = pickFromRows(A, I, invert)
%PICKFROMROWS  Selects entries given by index vector from rows of matrix.
%   B = pickFromRows(A, I) returns a vector B such that B(i) = A(i, I(i)). Inputs
%   A and I must have the same number of rows, and I must be a column vector.
%   
%   B = pickFromRows(A, I, true) returns a matrix B such that each row B(i, :)
%   equals A(i, :), but with element A(i, I(i)) omitted.
%   
%   Sebastian Schneegans | bayslab.com | Licence GPL-2.0 | 2020-08-10

if nargin < 3
    invert = false;
end

if invert
    A = A';
    II = bsxfun(@ne, (1:size(A, 1))', I(:)');
    out = reshape(A(II), size(A) - [1, 0])';
else
    out = A(sub2ind(size(A), (1:size(A, 1))', I(:)));
end

