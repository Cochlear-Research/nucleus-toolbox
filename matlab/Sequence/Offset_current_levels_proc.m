function q = Offset_current_levels_proc(p, q)

% Offset_current_levels_proc: Add an offset to all current levels in a sequence.
%
% qo = Offset_current_levels_proc(p, qi)
%
% p:  Parameter struct.
% qi: Input pulse sequence.
% qo: Output pulse sequence.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch nargin

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 0	% Default parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	q = feval(mfilename, []);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 1	% Parameter calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	q = Ensure_field(p,'current_level_offset', 0);
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 2	% Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	if isstruct(p)
		offset = p.current_level_offset;
	else
		offset = p;	% Allow use without param struct
	end

	% Adjust current level of stim pulses.
	% Idle pulses have current_level == 0, and are not adjusted.
	stim_pulses = (q.current_levels > 0);	
	q.current_levels(stim_pulses) = q.current_levels(stim_pulses) + offset;
	
	q.current_levels = max(q.current_levels, 0);
	q.current_levels = min(q.current_levels, 255);
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

