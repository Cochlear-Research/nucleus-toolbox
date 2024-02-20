function r = Check_struct(s_actual, s_expected)

% Check_struct:
%
% r = Check_struct(s_actual, s_expected)
%
% Check that fields in struct s_expected are the same in struct s_actual.
% Fields in s_expected with names ending in '_' are not checked.
% Any additional fields in s_actual are not checked.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright: Cochlear Ltd
%   Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

v = Verbose();
if v >= 2
    fprintf('Check_struct:\n')
end
field_names = fieldnames(s_expected);
for n = 1:length(field_names)
    f = field_names{n};
    if f(end) ~= '_'
        r = Tester(s_actual.(f), s_expected.(f));
        if v >= 2
            fprintf('%d %s\n', r, f)
        end
        if ~r && v >= 3 
            disp(s_actual.(f))
            fprintf('\n')
            disp(s_expected.(f))
            fprintf('\n')
        end
    end
end
