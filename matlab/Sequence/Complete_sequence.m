function seq = Complete_sequence(seq)

% Complete_sequence: Make all fields in a sequence have the same length.

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

% Extend constant fields to have length equal to N:

num_pulses = max(field_lengths);	% N
if num_pulses > 1
	for n = 1:num_fields
		if field_lengths(n) == 1
			name  = field_names{n};
			value = getfield(seq, name);
			seq   = setfield(seq, name, repmat(value, num_pulses, 1));
		end
	end
end
