function seq = Remove_channels_from_sequence(seq, channels)

% Remove_channels_from_sequence: Removes pulses on the specified channels.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

seq = Complete_sequence(seq);
seq = Remove_pulses_from_sequence(seq, ismember(seq.channels, channels));
