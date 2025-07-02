classdef Test_Save_YAML_results < matlab.unittest.TestCase

% Class-based test of Save_YAML_test_results.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    properties
		test_in_dir		% Path to test_in directory.
		test_out_dir	% Path to test_out directory.
        r1				% A result struct array with 1 result.
        r3				% A result struct array with 3 results.
	end

	methods (TestClassSetup)

        function setup(testCase)
			% Shared setup for the entire test class.

			% Find input file relative to this directory:
			this_file_path = mfilename("fullpath");
			[this_dir, ~, ~] = fileparts(this_file_path);
			testCase.test_in_dir = fullfile(this_dir, '../test_in');
			testCase.test_out_dir = fullfile(this_dir, '../test_out');

			in_file = fullfile(testCase.test_in_dir, 'input_results.mat');
			u = load(in_file);
			testCase.r1 = u.r1;
			testCase.r3 = u.r3;		
        end

	end

	methods (Test)

		function single(testCase)
			r = testCase.save_then_read(testCase.r1, 1, 'r1.yaml');
			testCase.verifyEqual(r{1}, {"nextmanager_test/testConstructor"; true});		
		end

		function multiple(testCase)
			r = testCase.save_then_read(testCase.r3, 3, 'r3.yaml');
			testCase.verifyEqual(r{1}, {"Read_CDI_map_Test/map_default"; true});		
			testCase.verifyEqual(r{2}, {"Read_CDI_map_Test/map_22_channels"; true});		
			testCase.verifyEqual(r{3}, {"Read_CDI_map_Test/map_21_channels"; true});		
		end
	end

	methods

		function r = save_then_read(testCase, result_struct, len, file_name)

			testCase.verifyEqual(length(result_struct), len);
			yaml_path = fullfile(testCase.test_out_dir, file_name);
			fid = fopen(yaml_path, 'wt');
			date_time = datetime(1999,12,31, 23,59,59);
			Save_YAML_test_results(fid, date_time, result_struct);
			fclose(fid);

			% Read it back:
			y = yaml.loadFile(yaml_path);
			testCase.verifyEqual(y.NucleusToolboxVersion, string(Nucleus_version));
			testCase.verifyTrue(isfield(y, 'User'));
			testCase.verifyTrue(isfield(y, 'MATLABVersion'));
			testCase.verifyTrue(isfield(y, 'Platform'));
			testCase.verifyTrue(isfield(y, 'Computer'));
			testCase.verifyTrue(isfield(y, 'duration_s'));
			% yaml.loadFile has UTC hard-wired:
			date_time.TimeZone = 'UTC';
			testCase.verifyEqual(y.date_time, date_time);

			testCase.verifyTrue(isfield(y, 'results'));
			r = y.results;
			testCase.verifyEqual(length(r), len + 1);
			testCase.verifyEqual(r{1}, {"Test"; "Success"});
			r = r(2:end); % Return the remaining elements for checking.
		end
	end

end