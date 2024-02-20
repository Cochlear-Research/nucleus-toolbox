function result = Remove_retain_channels_test

% Remove_retain_channels_test: Test of Remove_channels_from_sequence, Retain_channels_from_sequence.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

verbose = Tester(mfilename);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

u.channels		= [  1;  2;  3;  1;  2;  3;  1;  1;  2;  2;  3;  3];
u.magnitudes	= 100 + 10 * u.channels;
u.periods_us	= 100;

v0   = Remove_channels_from_sequence(u, 4);		% Remove nothing
t0   = Retain_channels_from_sequence(u, 1:3);	% Retain all
t0a  = Retain_channels_from_sequence(u, 1:22);	% Retain all
v0_  = Complete_sequence(v0);
Tester(v0,  v0_);
Tester(t0,  v0_);
Tester(t0a, v0_);

v1   = Remove_channels_from_sequence(u, 1);
t1   = Retain_channels_from_sequence(u, [2;3]);
t1a  = Retain_channels_from_sequence(u, 2:22);
v1_.channels	= [      2;  3;      2;  3;          2;  2;  3;  3];
v1_.periods_us	= [    100;200;    100;300;        100;100;100;100];
v1_.magnitudes	= 100 + 10 * v1_.channels;
Tester(v1,  v1_);
Tester(t1,  v1_);
Tester(t1a, v1_);

v2   = Remove_channels_from_sequence(u, 2);
t2   = Retain_channels_from_sequence(u, [1;3]);
t2a  = Retain_channels_from_sequence(u, [1;3;4;5]);
v2_.channels	= [  1;      3;  1;      3;  1;  1;          3;  3];
v2_.periods_us	= [200;    100;200;    100;100;300;        100;100];
v2_.magnitudes	= 100 + 10 * v2_.channels;
Tester(v2,  v2_);
Tester(t2,  v2_);
Tester(t2a, v2_);

v3   = Remove_channels_from_sequence(u, 3);
t3   = Retain_channels_from_sequence(u, [1;2]);
t3a  = Retain_channels_from_sequence(u, [1;2;4;5]);
v3_.channels	= [  1;  2;      1;  2;      1;  1;  2;  2;       ];
v3_.periods_us	= [100;200;    100;200;    100;100;100;300        ];
v3_.magnitudes	= 100 + 10 * v3_.channels;
Tester(v3,  v3_);
Tester(t3,  v3_);
Tester(t3a, v3_);

v23  = Remove_channels_from_sequence(u, [2;3]);
t23  = Retain_channels_from_sequence(u, 1);
t23a = Retain_channels_from_sequence(u, [1,4,5,6,7]);
v23_.channels	= [  1;          1;          1;  1;               ];
v23_.periods_us	= [300;        300;        100;500                ];
v23_.magnitudes	= 100 + 10 * v23_.channels;
Tester(v23,  v23_);
Tester(t23,  v23_);
Tester(t23a, v23_);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if verbose >= 2
	Plot_sequence({u,v0,v1,v2,v3,v23},{'u','v0','v1','v2','v3','v23'});
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constant channel sequence:

q.channels		= 2;
q.magnitudes	= (100:10:200)';
q.periods_us	= 100;

q0  = Remove_channels_from_sequence(q, 4);	% remove nothing
a0  = Retain_channels_from_sequence(q, 2);	% retain all
q0_ = Complete_sequence(q0);
Tester(q0, q0_);
Tester(a0, q0_);

q1  = Remove_channels_from_sequence(q, 2);	% remove all pulses
a1  = Retain_channels_from_sequence(q, 3);	% retain nothing
Tester(Get_num_pulses(q1), 0);
Tester(Get_num_pulses(a1), 0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constant magnitude sequence:

m.channels		= [2;4;6;8];
m.magnitudes	= 99;
m.periods_us	= 100;

m0  = Remove_channels_from_sequence(m, 3);	% remove nothing
n0  = Retain_channels_from_sequence(m, m.channels);	% retain all
m0_ = Complete_sequence(m0);
Tester(m0, m0_);
Tester(n0, m0_);

m1  = Remove_channels_from_sequence(m, 4);			% remove one pulse
n1  = Retain_channels_from_sequence(m, [2,6,8]);	% remove one pulse
m1_.channels	= [  2;  6;  8];
m1_.magnitudes	= [ 99; 99; 99];
m1_.periods_us	= [200;100;100];
Tester(m1, m1_);
Tester(n1, m1_);

if verbose >= 2
	Plot_sequence({m,m0,m1},{'m','m0','m1'});
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

result = Tester;	% Report result
