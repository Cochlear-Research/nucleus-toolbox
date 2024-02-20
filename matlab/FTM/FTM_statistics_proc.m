function s = FTM_statistics_proc(p, u)

% FTM_statistics_proc: Calculate some statistics of an FTM.
%
% s = FTM_statistics_proc(p, u)
%
% p: parameter struct (not used)
% u: FTM
% s: struct containing statistics, in the following fields:
% s.channel_mean:     mean value of each channel (column vector).
% s.centroid_channel: "centre of gravity" across channels.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch nargin

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 0	% Default parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	s = [];
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 1	% Parameter calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	s = p;
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 2	% Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	[num_channels, num_samples] = size(u);

	% Samples that were rejected by Reject_smallest are NaN.
	% Samples that were less than base_level are negative.
	% Replace all of them with zeros.

	u(~(u>0)) = 0;

	s.channel_mean     = mean(u, 2);
	
	n = (1:num_channels)';
	
	w = warning('off');
	s.centroid_channel = sum(s.channel_mean .* n) / sum(s.channel_mean);
	warning(w);
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
