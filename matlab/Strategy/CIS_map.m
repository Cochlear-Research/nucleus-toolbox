function p = CIS_map(p)

% Calculate CIS map parameters.
%
% p = CIS_map(p)
%
% Args:
%     p: A struct containing the clinical parameters.
%
% Returns:
%     p: A struct containing the clinical and derived parameters.
%     Any fields omitted from the input struct will be set to default values.
%
%
% CIS is the same as ACE except that :func:`Reject_smallest` is not used.
% To perform processing, use::
%
%   q = Process(p, audio)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin == 0
	p = struct;
end

p = Ensure_field(p, 'map_name', 'CIS');
p = Ensure_field(p, 'channel_stim_rate_Hz',	500);
p = Ensure_electrodes(p);
p.num_selected = p.num_bands;
p = ACE_map(p);
% Remove Reject_smallest_proc from processing chain:
k = Find_process(p, @Reject_smallest_proc);
p.processes(k) = [];
