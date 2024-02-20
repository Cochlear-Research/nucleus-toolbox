function v = Get_mean_current_levels(seq)

% Get_mean_current_levels: Returns a vector of mean current level on each electrode.
%
% v = Get_mean_current_levels(seq)
%
% seq: Pulse sequence.
% v:   Column vector of current levels.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

v = zeros(22, 1);
for e = 1:22
	x = (seq.electrodes == e);
	current_levels = seq.current_levels(x);
	if ~isempty(current_levels)
		v(e) = mean(current_levels);
	end
end

