function [num_pulses, field_lengths] = Get_num_pulses(seq)
% Get_num_pulses: Returns the number of pulses in a sequence.
% function [num_pulses, field_lengths] = Get_num_pulses(seq)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

field_names   = fieldnames(seq);
num_fields    = length(field_names);
field_lengths = zeros(num_fields, 1);

for n = 1:num_fields
	name = field_names{n};
	vec  = getfield(seq, name);
	field_lengths(n) = length(vec);
end

% Check that all fields have length equal to 1 or N:

num_pulses = max(field_lengths);	% N
if num_pulses > 1
	implied_field_lengths = field_lengths;
	% Vectors with length 1 imply that all N pulses have that value:
	implied_field_lengths(field_lengths == 1) = num_pulses;
	short_field_indices = find(implied_field_lengths < num_pulses);
	if (~isempty(short_field_indices))
		disp('Some fields were too short:');
		disp(char(field_names{short_field_indices}));
		error(' ');
	end
end
