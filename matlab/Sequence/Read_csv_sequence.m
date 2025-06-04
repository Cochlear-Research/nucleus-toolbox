function q = Read_csv_sequence(file_name)

% Read_csv_sequence: Read a sequence struct from a csv file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright: Cochlear Ltd
%   Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[~, ~, ext] = fileparts(file_name);
if isempty(ext)
	file_name = strcat(file_name, '.csv');
end
t = readtable(file_name);
q = table2struct(t, 'ToScalar', true);

