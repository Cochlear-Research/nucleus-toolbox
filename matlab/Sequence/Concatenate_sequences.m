function seq = Concatenate_sequences(varargin)

% Concatenate_sequences: Concatenate sequences
% The sequences must all have the same fields.
% The arguments can be passed in separately,
% or as a cell array.
%
% seq = Concatenate_sequences(seq1, seq2, seq3, ...)
% seq = Concatenate_sequences({seq1, seq2, seq3, ...})
%
% seq = Concatenate_sequences(seq1, n)
% Concatenates n copies of seq1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (nargin == 1) && iscell(varargin{1})

	% eg. Concatenate_sequences({seq1, seq2, seq3})
	seq = Concatenate_cell_of_sequences(varargin{1});
	
elseif (nargin == 2) && isstruct(varargin{1}) && isnumeric(varargin{2})

	% eg. Concatenate_sequences(seq1, n)
	seq = Replicate_sequence(varargin{1}, varargin{2});
	
else
	% eg. Concatenate_sequences(seq1, seq2, seq3, ...)
	seq = Concatenate_cell_of_sequences(varargin);
	
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function seq = Concatenate_cell_of_sequences(seqs)

	% Look for empty sequences in cell array:
	num_seqs = length(seqs);
	for ns = 1:num_seqs
		empty(ns) = isempty(seqs{ns});
	end
	seqs(empty) = [];	% Remove empty sequences.
	
	num_seqs = length(seqs);
	% If there is only one non-empty sequence, just return it:
	if num_seqs == 1
		seq = seqs{1};
		return
	end

	for ns = 1:num_seqs
		num_pulses(ns) = Get_num_pulses(seqs{ns});
	end

	seq = [];
	field_names = fieldnames(seqs{1});
	num_fields  = length(field_names);
	for nf = 1:num_fields

		name = field_names{nf};

		for ns = 1:num_seqs
			field_data{ns}    = getfield(seqs{ns}, name);
			field_lengths(ns) = length(field_data{ns});
		end

		if all(field_lengths == 1)

			% This field is a constant in every sequence.
			% Check whether it has the same value in every sequence.

			% Convert into a vector:
			constant_fields = [field_data{:}];
			value = constant_fields(1);
			if all(constant_fields == value)
				seq = setfield(seq, name, value);
			end
		end

		if ~isfield(seq, name)
			for ns = 1:num_seqs
				if (field_lengths(ns) == 1)
					field_data{ns} = repmat(field_data{ns}, num_pulses(ns), 1);
				end
			end
			seq = setfield(seq, name, cat(1, field_data{:}));
		end

	end

	% If we concatenate a one-pulse sequence to itself,
	% then every field is constant.
	% We will replicate one field.

	seq = Check_single_pulse(seq, num_seqs);
		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function seq = Replicate_sequence(seq, num_copies)

	field_names = fieldnames(seq);
	num_fields  = length(field_names);
	for nf = 1:num_fields

		name = field_names{nf};

		field_data   = getfield(seq, name);
		field_length = length(field_data);

		if (field_length > 1)
			field_data = repmat(field_data, num_copies, 1);
			seq = setfield(seq, name, field_data);
		end

	end

	% If we replicate a one-pulse sequence,
	% then every field is constant.
	% We will replicate one field.

	seq = Check_single_pulse(seq, num_copies);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function seq = Check_single_pulse(seq, num_copies)

	if Get_num_pulses(seq) == 1

		if isfield(seq, 'magnitudes')
			seq.magnitudes = repmat(seq.magnitudes, num_copies, 1);
		elseif isfield(seq, 'current_levels')
			seq.current_levels = repmat(seq.current_levels, num_copies, 1);
		else
			error('Unknown sequence type');
		end

	end
		