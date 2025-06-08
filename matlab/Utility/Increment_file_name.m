function file_path = Increment_file_name(file_path)

% Increment_file_name: Increments the numeric suffix of a file name

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright: Cochlear Ltd
%   Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[path, name, ext] = fileparts(file_path);
[base_match, digit_match] = split(name, digitsPattern);
assert(numel(base_match) == 2);
assert(isscalar(digit_match));
index = str2double(digit_match{1});
file_name = sprintf('%s%d%s', base_match{1}, index + 1, ext);
file_path = fullfile(path, file_name);
