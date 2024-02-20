function Save_csv_sequence(seq, base_name)

% Save_csv_sequence: Save a sequence struct to a csv file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright: Cochlear Ltd
%   Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

file_name = strcat(base_name, '.csv');
fid = fopen(file_name, 'wt');
if (fid == -1)
    error('Cannot open file');
end

field_names   = fieldnames(seq);
num_fields    = length(field_names);
field_lengths = zeros(num_fields, 1);
% Note that \n only means newline inside a format string:
seps          = sprintf('%s\n', repmat(',', 1, num_fields-1));

% Write header, and calculate field sizes:
for n = 1:num_fields
	name = field_names{n};
    fprintf(fid, '%s%s', name, seps(n));
	field_lengths(n) = length(seq.(name));
end

% Write a row for each pulse:
num_pulses = max(field_lengths);
for k = 1:num_pulses
	for n = 1:num_fields
		name = field_names{n};
        value = seq.(name);
		if field_lengths(n) > 1
            value = value(k);
        end
		fprintf(fid, '%g%s', value, seps(n));
    end
end
