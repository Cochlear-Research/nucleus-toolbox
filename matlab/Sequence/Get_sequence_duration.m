function t = Get_sequence_duration(seq)

% Get_sequence_duration: Get the duration of a sequence.
% The sequence must have a field "periods_us".
%
% t = Get_sequence_duration(seq)
%
% seq: Sequence struct.
% t:   Duration (in microseconds).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

num_pulses = Get_num_pulses(seq);

if length(seq.periods_us) == 1
	t = seq.periods_us * num_pulses;
else
	t = sum(seq.periods_us);
end
