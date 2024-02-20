function q = Read_csv_sequence(base_name)

% Read_csv_sequence: Read a sequence struct from a csv file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright: Cochlear Ltd
%   Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

file_name = strcat(base_name, '.csv');
t = readtable(file_name);
q = table2struct(t, 'ToScalar', true);

