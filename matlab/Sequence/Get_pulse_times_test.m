function result = Get_pulse_times_test

% Get_pulse_times_test: Test of Get_pulse_times.

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

[tu1,du1] = Get_pulse_times(u1);
Tester(tu1, 0);
Tester(du1, 200);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Uniform rate sequence:

u2.channels		= (1:4)';
u2.magnitudes	= 10 * u2.channels;
u2.periods_us	= 200;

[tu2,du2] = Get_pulse_times(u2);
Tester(tu2, [0;200;400;600]);
Tester(du2, 800);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Variable rate sequence:

v1.channels		= (1:4)';
v1.magnitudes	= 10 * v1.channels;
v1.periods_us	= [200; 400; 200; 400];

[tv1,dv1] = Get_pulse_times(v1);
Tester(tv1, [0;200;600;800]);
Tester(dv1, 1200);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

result = Tester;	% Report result
