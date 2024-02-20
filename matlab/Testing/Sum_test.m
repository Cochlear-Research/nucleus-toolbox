function result = Sum_test

% Sum_test: Example of using Tester.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

verbose = Tester(mfilename);

% Generate inputs:
x = [1 2 3];

% Run function under test to produce outputs:
s = sum(x);

if verbose
	% Display inputs, outputs:
	x, s
end

Tester(size(s), [1 1]);	% Verify the expected size.
Tester(s, 6);			% Verify the expected result.

result = Tester;		% Report result.
