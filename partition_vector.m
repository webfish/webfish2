function [Zer, One] = partition_vector(UB)
UB = int8(UB);
UB(UB ~= 0 & UB ~= 1) = 10;
tmp = [UB(1) UB] - [UB UB(end)];
%% Zeros
Zers = [find(UB(1) == 0), find(tmp == 1 | tmp == 10)];
Zere = [find(tmp == -1 | tmp == -10) - 1, numel(UB) * find(UB(end) == 0)];
Zer = [Zers; Zere];
%% Ones
Ones = [find(UB(1) == 1), find(tmp == -1 | tmp == 9)];
Onee = [find(tmp == 1 | tmp == -9) - 1, numel(UB) * find(UB(end) == 1)];
One = [Ones; Onee];

