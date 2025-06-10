classdef Test_Increment_file_name < matlab.unittest.TestCase

% Test_Increment_file_name: Class-based test of Increment_file_name.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright: Cochlear Ltd
%   Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    properties (TestParameter)
        io_name = {
				'foo0.txt foo1.txt';
				'x_37.doc x_38.doc';
				'q99.csv q100.csv';
                '12.log 13.log';
			};
        path = {
                '.';
                'foo';
                'foo/bar';
            };
    end

	methods (Test)

        function Char(testCase, io_name)
            file_names = split(io_name);
			in_name = file_names{1};
			expected_out_name = file_names{2};
			out_name = Increment_file_name(in_name);
			testCase.verifyEqual(out_name, expected_out_name);
		end

        function String(testCase, io_name)
            file_names = split(io_name);
			in_name = file_names{1};
			expected_out_name = file_names{2};
			out_name = Increment_file_name(string(in_name));
			testCase.verifyEqual(out_name, string(expected_out_name));
		end

        function Path(testCase, path)
            in_path = fullfile(path, 'seq1.csv');
			out_path = Increment_file_name(in_path);
			testCase.verifyEqual(out_path, fullfile(path, 'seq2.csv'));
        end

    end
end
