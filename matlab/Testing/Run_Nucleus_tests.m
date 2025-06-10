function Run_Nucleus_tests()

% Run_Nucleus_tests: Run the tests in the current directory and its sub-directories.
%
% It calls functions whose name ends with "_test".
% These are assumed to on the path, and using the NTM testing framework.
% It also calls any tests that use the MATLAB testing framework.
% To avoid name conflicts, their names should start with "Test_".
% A .log file is created containing the test results,
% in a format that can be read by cochlear.sphinx.test_reporter.
% At the end of the tests, logging is set to echo, with no file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright: Cochlear Ltd
%   Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic;

ntm_results.num_pass = 0;
ntm_results.num_test = 0;

dt = datetime;
dt.Format = "yMMdd_HHmmss";

log_file_name = sprintf('result_%s.log', char(dt));
log_path = fullfile(Nucleus_dir(), 'test_out', log_file_name);
diary(log_path);
fid = 1;			% standard output

dd = dir('**/*_test.m'); % Recursive search through nested sub-directories.
for n = 1:length(dd)
	try
		[path, function_name, ext] = fileparts(dd(n).name);
		assert(isempty(path));
		assert(isequal(ext, '.m'));
		r = feval(function_name);
		ntm_results.num_pass = ntm_results.num_pass + r;
    catch exc
		fprintf(fid, 'FAIL:  %s:\n', function_name);
        disp(getReport(exc, 'extended'))
	end
	ntm_results.num_test = ntm_results.num_test + 1;
end

t = toc;
diary('off');			% Don't capture MATLAB testing framework output.

% Run MATLAB testing framework:
framework_results = runtests(IncludeSubfolders=true);

diary('on')				% Capture subsequent output.

if (ntm_results.num_test == 0) && isempty(framework_results)
	fprintf(fid, 'No tests found\n');
	return;
end

fprintf(fid, '---\n');	% YAML end of document marker.

% NTM results:
fprintf(fid, 'ntm_num_test: %d\n', ntm_results.num_test);
fprintf(fid, 'ntm_num_pass: %d\n', ntm_results.num_pass);
fprintf(fid, 'ntm_duration_s: %4.1f\n', t);

Save_YAML_test_results(fid, dt, framework_results);

diary('off');
Open_log echo ~file;
