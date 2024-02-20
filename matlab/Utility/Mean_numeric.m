function avg = Mean_numeric(x, dim)

% Mean_numeric: mean value, ignoring NaNs

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

good = ~isnan(x);
num_scores = sum(good, dim);
x(~good) = 0;
s = sum(x, dim);
warning off;
avg = s ./ num_scores;
warning on;
