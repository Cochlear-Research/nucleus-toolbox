function result = Get_sequence_duration_test

% Get_sequence_duration_test: Test of Get_sequence_duration.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

verbose = Tester(mfilename);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% One-pulse sequence:

u1.channels		= 4;
u1.magnitudes	= 10;
u1.periods_us	= 200;

Tester(Get_sequence_duration(u1), 200);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Uniform rate sequence:

u2.channels		= (1:4)';
u2.magnitudes	= 10 * u2.channels;
u2.periods_us	= 200;

Tester(Get_sequence_duration(u2), 800);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Variable rate sequence:

v1.channels		= (1:4)';
v1.magnitudes	= 10 * v1.channels;
v1.periods_us	= [200; 400; 200; 400];

Tester(Get_sequence_duration(v1), 1200);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

result = Tester;	% Report result
