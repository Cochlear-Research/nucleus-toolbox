function Log_sequence(seq)

% Log_sequence: Write a sequence as text to the log file.
%
% Log_sequence(seq)
%
% seq: Sequence struct.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if iscell(seq)
	seq = Concatenate_sequences(seq);
end

[num_pulses, field_lengths] = Get_num_pulses(seq);

field_names  = fieldnames(seq);
num_fields   = length(field_names);
field_name_chars  = char(field_names);
field_name_length = max(4, size(field_name_chars, 2)) + 1;

fmt_str = ['%', num2str(field_name_length), 's'];
fmt_num = ['%', num2str(field_name_length), 'g'];

% Print field names as column headings:
s = '';
for f = 1:num_fields
	name = field_names{f};
	s = [s, sprintf(fmt_str, name)];
end
Write_log(s);
Write_log('\n');

% Print contents:
for p = 1:num_pulses
	s = '';
	for f = 1:num_fields
		if (p <= field_lengths(f)) 
			vec = getfield(seq, field_names{f});
			if isequal(field_names{f}, 'modes')
				str = sprintf(fmt_str, Mode_string(vec(p)));
			else
				str = sprintf(fmt_num, vec(p));
			end
		else
			str = sprintf(fmt_str, ' ');
		end
		s = [s, str];
	end
	Write_log(s);
	Write_log('\n');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function str = Mode_string(m)
	MODE = Implant_modes;
	switch m
		case MODE.MP1,		str = 'MP1';
		case MODE.MP2,		str = 'MP2';
		case MODE.MP1_2,	str = 'MP1_2';
		otherwise,			str = num2str(m);
	end