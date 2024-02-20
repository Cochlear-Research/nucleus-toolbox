function [m, k] = Max_matrix(a)

[mr, kr] = max(a);  % mr and kr are row vectors, max in each column.
[m, kc]  = max(mr); % m is global maximum; k1 gives column index.
k = [kr(kc), kc];