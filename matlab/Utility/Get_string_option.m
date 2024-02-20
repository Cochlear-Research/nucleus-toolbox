function value = Get_string_option(opt, name, default_value)

% Get_string_option: Get value of an optional parameter from a string.
%
% value = Get_string_option(opt, name, default_value)
% opt:  string containing optional parameters
% name: parameter name (string)
% default_value: value to be used if parameter name is absent
%
% Examples:
% opt = 'foo 3 bar 0.1'
% Get_string_option(opt, 'foo', 0) == 3
% Get_string_option(opt, 'bar', 1) == 0.1
% Get_string_option(opt, 'zzz', 9) == 9     % default

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

k1 = strfind(opt, name);
if isempty(k1)
    value = default_value;
    return
end
if length(k1) > 1
    warning('Multiple occurrence of parameter %s', name);
    k1 = k1(1);
end
k2 = k1 + length(name);
value = sscanf(opt(k2:end), '%f');
if isempty(value)
    value = default_value;
end    
value = value(:)';  % row vector
     