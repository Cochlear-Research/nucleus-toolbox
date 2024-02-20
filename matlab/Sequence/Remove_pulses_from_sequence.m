function seq = Remove_pulses_from_sequence(seq, to_remove)

% Remove_pulses_from_sequence: Removes a set of pulses from a sequence.
% The timing of the remaining pulses is maintained;
% a constant-period sequence will be converted to a variable-period sequence.
%
% oseq = Remove_pulses_from_sequence(seq, to_remove)
%
% seq:       Input channel-magnitude sequence.
% to_remove: Logical vector, with length equal to number of pulses in sequence.
% oseq:      Output channel-magnitude sequence.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if any(to_remove)

	[pulse_times, duration] = Get_pulse_times(seq);
	
	seq.channels(to_remove)   = [];
	seq.magnitudes(to_remove) = [];
	pulse_times(to_remove)    = [];
	
	seq.periods_us = diff([pulse_times; duration]);
end