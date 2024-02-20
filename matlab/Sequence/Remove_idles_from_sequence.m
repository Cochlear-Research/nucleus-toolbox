function seq = Remove_idles_from_sequence(seq)

% Remove_idles_from_sequence: Remove idle pulses from a sequence.
% The timing of the remaining stimulus pulses is maintained;
% a constant-period sequence will be converted to a variable-period sequence.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

seq = Complete_sequence(seq);
seq = Remove_pulses_from_sequence(seq, seq.magnitudes < 0);