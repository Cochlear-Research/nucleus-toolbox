function Run_tests(dir_name)

% Run_tests: Run all of the tests in the specified directory (and its sub-directories).
%
% Run_tests(dir_name)
%
% A partial path name will be searched for in the MATLAB search path.
% If no directory is specified, it uses the top-level Nucleus directory.
% Directories that are not in the path are skipped.
% It calls functions whose name ends with "_test".
% Note that many tests use logging.
% At the end of the tests, logging is set to echo, with no file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright: Cochlear Ltd
%   Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic;

result.num_pass = 0;
result.num_test = 0;

if (nargin == 0)
    log_file_name = sprintf('test-%s.log', Time_stamp_string());
    log_path = fullfile(Nucleus_dir(), 'test_out', log_file_name);
    diary(log_path);

	result = Recursive_test(Nucleus_dir, result);
else
	s = what(dir_name);	% Search on Matlab path, may find multiple matches.
	if isempty(s)
		fprintf('Path not found');
		return
	end
	for k = 1:length(s)
		result = Recursive_test(s(k).path, result);	
	end
end
t = toc;

if (result.num_test == 0)
	fprintf('No tests found');
	return;
end

% Print summary in YAML format:
fprintf('---\n');
fprintf('nucleus_version: %s\n', Nucleus_version);
fprintf('date_time: %s\n', char(datetime('now', 'Format', 'yyyy-MM-dd hh:mm:ss')))
fprintf('user: %s\n', char(java.lang.System.getProperty('user.name')))
m = matlabRelease;
fprintf('matlab_version: %s.%d\n', m.Release, m.Update)
fprintf('platform: %s\n', computer('arch'));
fprintf('computer: %s\n', Get_computer_id());
fprintf('duration: %4.2f seconds\n', t);
fprintf('num_test: %d\n', result.num_test);
fprintf('num_pass: %d\n', result.num_pass);

if (result.num_pass == result.num_test)
	result.outcome = 'Pass';
else
	result.outcome = 'Fail';
end
fprintf('result: %s\n', result.outcome);

diary off
Open_log echo ~file;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function result = Recursive_test(dir_full_path, result)

s = what(dir_full_path);
if isempty(s)
	return;					% Directory is not on path.
elseif length(s) > 1
	error('Multiple directories');	% Should not happen.
end
	
fprintf('     %s\n', s.path)	% full path

% Examine .m files:
for k = 1:length(s.m)
	file_name = s.m{k};
	% Execute if its name matches:
	match = regexp(file_name, '_test.m$', 'once');
	if ~isempty(match)
		try
			function_name = file_name(1:end-2);		% chop off '.m' at end
			r = feval(function_name);
			result.num_pass = result.num_pass + r;
        catch exc
			fprintf('FAIL:  %s:\n', function_name);
            disp(getReport(exc, 'extended'))
		end
		result.num_test = result.num_test + 1;
	end
end

% Examine sub-directories:
dir_contents = dir(s.path);
for k = 1:length(dir_contents)
	if dir_contents(k).isdir && isletter(dir_contents(k).name(1))
		full_path = fullfile(dir_full_path, dir_contents(k).name);
		result = Recursive_test(full_path, result);
	end
end
