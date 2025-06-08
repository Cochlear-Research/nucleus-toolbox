classdef Increment_file_name_test < matlab.unittest.TestCase

% Increment_file_name_test: Class-based test of Increment_file_name.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright: Cochlear Ltd
%   Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	methods (Test)
		% Test methods

		function Suffix_file_name(testCase)
			cases = {
				'foo0.txt',         'foo1.txt';
				'x_37.doc',         'x_38.doc';
				'sequence99.csv',   'sequence100.csv';
				'foo/bar/seq9.csv', 'foo/bar/seq10.csv';
				};
			[num_cases, ~] = size(cases);
			for n = 1:num_cases
				in_name = cases{n, 1};
				expected_out_name = cases{n, 2};
				% char inputs:
				out_name = Increment_file_name(in_name);
				testCase.verifyEqual(out_name, expected_out_name);
				% string inputs:
				out_name = Increment_file_name(string(in_name));
				testCase.verifyEqual(out_name, string(expected_out_name));
			end
		end
	end

end