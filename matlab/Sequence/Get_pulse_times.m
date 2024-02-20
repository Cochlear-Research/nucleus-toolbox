function [t, duration] = Get_pulse_times(seq)

% Get_pulse_times: Get the time of each pulse of a sequence.
% The sequence must have a field "periods_us",
% which is the time from the start of the pulse,
% to the start of the next pulse.
% The first pulse is defined to occur at time 0.
% The last time (the sequence duration) can be returned as a second output;
% note that there is no pulse there.
% This can be convenient, because:
% seq.periods_us == diff([t; duration])
%
% [t, duration] = Get_pulse_times(seq)
%
% seq:      Sequence struct
% seq.periods_us: time from start of pulse to start of next pulse.
%
% t:        Time of the start of each pulse.
% duration: Duration of the sequence (includes last period).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

num_pulses = Get_num_pulses(seq);

if length(seq.periods_us) == 1
	t = seq.periods_us * (0:num_pulses)';
else
	t = [0; cumsum(seq.periods_us)];
end

duration = t(end);
t(end) = [];