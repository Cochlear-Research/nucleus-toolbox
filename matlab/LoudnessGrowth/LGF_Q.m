function q = LGF_Q(alpha, base_level, sat_level)

% LGF_Q: Calculate Loudness Growth Function Q factor.
%
% function q = LGF_Q(alpha, base_level, sat_level)
%
% Inputs:
% alpha			- curve shape factor.
% base_level	- amplitudes below this give 0 output).
% sat_level		- input amplitude at which output saturation occurs.
%
% Output:
% q				- the percentage decrease in the output for a 10 dB decrease
%				  in the input below sat_level

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p.lgf_alpha  = alpha;
p.base_level = base_level;
p.sat_level  = sat_level;
p.sub_mag    = 0;
input_level = sat_level/sqrt(10);	% 10 dB down from saturation
p = LGF_proc(p, input_level);
q = 100 * (1 - p);	% Convert to a percentage decrease