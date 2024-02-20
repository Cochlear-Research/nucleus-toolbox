function d = Diff_log_file(expected)

% Diff_log_file: Compares the log file to a cell array of strings.
% For use in unit testing.
% If an expected line contains the character '#'
% then that character and the remainder of the line is not checked,
% which is necessary to avoid time-stamps, 
% and can also be helpful when developing tests.
%
% d = Diff_log_file(expected)
%
% expected: A cell array of strings (without newlines).
% d:        Result of comparison:
%           If positive, it gives the first line number
%           at which the log file differed from expected contents.
%           -1: log file was too short
%           -2: log file was too long
%            0: log file contents matched expected contents.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

v = Verbose >= 3;
log_file_name = Open_log;
fid = fopen(log_file_name);

num_lines = 0;
d = 0;

while d == 0

    log_line = fgetl(fid);
    if ~ischar(log_line)				% End of file.
    	break;
    end
    
    num_lines = num_lines + 1;
    if (num_lines > length(expected))	% Too many lines in log file.
        d = -2;
        if v
            fprintf('log file too long.\n');
        end
    	break;
    end
    
    exp_line = expected{num_lines};
    
    k = strfind(exp_line, '#');
    if isempty(k)
        match = strcmpi(exp_line, log_line);
    else
        % Compare characters up to (but not including) first occurrence of '#'
        match = strncmpi(exp_line, log_line, k(1)-1);
    end
    
    if ~match
        d = num_lines;
        if v
            fprintf('log file unexpected line:\n%s\n%s\n', exp_line, log_line);
        end
    end
end
fclose(fid);

if (d == 0) && (num_lines < length(expected))
	d = -1;
    if v
        fprintf('log file too short.\n');
    end
end
