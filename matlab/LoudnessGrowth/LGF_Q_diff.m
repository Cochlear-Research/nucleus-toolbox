function out = LGF_Q_diff(log_alpha, Q, base_level, sat_level)

% LGF_Q_diff: Used in LGF calculations as the function for fzero.
%
% fzero detects the zero crossing of a function as the first argument is varied. 
% This function returns the difference between
% the specified Q and the Q calculated from log_alpha, base_level, sat_level.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

alpha = exp(log_alpha);
out = LGF_Q(alpha, base_level, sat_level) - Q;
