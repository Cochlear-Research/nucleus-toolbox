function Save_YAML_test_results(fid, date_time, results)

% Save_YAML_test_results: Save MATLAB testing framework results to YAML file.
% The YAML file begins with "meta" information about the test environment.
% It can be read by the Python module ``cochlear.sphinx.test_reporter``
% and converted to a Sphinx document table.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Some keys are shown verbatim in the report so have names starting with upper case.
fprintf(fid, 'Nucleus Toolbox version: %s\n', Nucleus_version);
fprintf(fid, 'User: %s\n', char(java.lang.System.getProperty('user.name')));
try
    m = matlabRelease;
    fprintf(fid, 'MATLAB version: %s.%d\n', m.Release, m.Update);
catch
    fprintf(fid, 'MATLAB version: %s\n', version);    % prior to R2020b
end
fprintf(fid, 'Platform: %s\n', computer('arch'));
fprintf(fid, 'Computer: %s\n', Get_computer_id());
date_time.Format = 'yyyy-MM-dd HH:mm:ss';
fprintf(fid, 'date_time: %s\n', char(date_time));

if exist('results', 'var')
	% Convert results to a table:
	rt = table(results);
	duration = sum(rt.Duration);
	fprintf(fid, 'duration_s: %4.1f\n', duration);

	rt = removevars(rt, {'Failed', 'Incomplete', 'Duration', 'Details'});
	c = table2cell(rt);
	h = [{'Test'}, {'Success'}]; % Column headings
	c = [h; c];
	s = yaml.dump(c);

	fprintf(fid, '%s\n', 'results:');
	fprintf(fid, '%s', s);
end
