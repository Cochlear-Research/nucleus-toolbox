function v = Uncollate_sequence(q, analysis_period, num_bands)

% Uncollate_sequence: Convert a (channel, magnitude, periods_us) sequence into a FTM
%
% v = Uncollate_sequence(q, analysis_period, num_bands)
%
% q:               Sequence with fields (channels, magnitudes, periods_us).
% analysis_period: The duration of one column of the output FTM, v.
%                  Should be equal to the analysis_period of the 
%                  coding strategy that produced the sequence.
% num_bands:       The number of bands of the output FTM, v.
%                  Default is the highest channel number.
%
% v:               Frequency-Time Matrix (FTM)
%
% Note: if analysis_period is too long, so that a channel is stimulated
% more than once during one analysis_period, then the last pulse will 
% over-write the earlier ones.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 3
	num_bands = max(q.channels);
end
pulse_times = Get_pulse_times(q);
time_slots = 1 + floor(pulse_times / analysis_period);
num_time_slots = max(time_slots);
v = zeros(num_bands, num_time_slots);

num_pulses = length(pulse_times);
for n = 1:num_pulses
	if q.channels(n) > 0
		v(q.channels(n), time_slots(n)) = q.magnitudes(n);
	end
end
