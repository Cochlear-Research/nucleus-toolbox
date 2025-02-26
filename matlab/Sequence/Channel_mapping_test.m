function result = Channel_mapping_test

% Channel_mapping_test: Test of Channel_mapping_proc, Channel_mapping_inv_proc.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson, Herbert Mauch
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

verbose = Tester(mfilename);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

MODE = Implant_modes;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Bad maps:

pp = {};

pp{1}.lower_levels = repmat(100, 12, 1);  % Electrodes has default length (22).

pp{2}.electrodes   = [22; 18; 12;  4];
pp{2}.lower_levels = [10; 10; 10; 10];
pp{2}.upper_levels = [99; 99; 99];              % Wrong length.

pp{3}.electrodes   = [22; 18; 12;  4];
pp{3}.lower_levels = [10; 10; 10; 10; 10];      % Wrong length.
pp{3}.upper_levels = [99; 98; 97; 96];          

pp{4}.electrodes   = [22; 21; 18; 12;  8;  3];
pp{4}.lower_levels = [10; 12; 11; 14;  7;  7];
pp{4}.upper_levels = [99; 99; 99; 13; 99; 99];  % upper < lower

pp{5}.electrodes   = [22; 21; 18; 12;  8;  3];
pp{5}.lower_levels = [10; 12; 11; 14;  7;  7];
pp{5}.upper_levels = [99; 99; 99; 99; NaN; 99];  % NaN is illegal

pp{6}.period_us         = 60;  % Too short for default phase width, phase gap

pp{7}.period_us         = 72;
pp{7}.phase_width_us    = 30;  % Too long for specified period

pp{8}.phase_width_us    =  5;  % Shorter than minimum 

pp{9}.phase_gap_us      =  5;  % Shorter than minimum 

pp{10}.period_us        = NaN; % Illegal

pp{11}.phase_width_us   = NaN; % Illegal

pp{12}.phase_gap_us     = NaN; % Illegal

pp{13}.phase_gap_us     = 30;  % Too long for default period

for n = 1:length(pp)
    try
        Channel_mapping_proc(pp{n});
        Tester(0);                      % Fail if we reach this statement.
    catch exc
        Tester(exc.identifier, 'Nucleus:Channel_mapping');
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Conversion to column vectors:

p0 = struct;
p0.electrodes       = 21:-1:1;
p0.upper_levels     = 200 + p0.electrodes;
p0.lower_levels     = 100 + p0.electrodes;
p0c = Channel_mapping_proc(p0);
Tester(p0c.num_bands, 21);
Tester(p0c.electrodes, p0.electrodes');
Tester(p0c.upper_levels, p0.upper_levels');
Tester(p0c.lower_levels, p0.lower_levels');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p1 = struct;
p1.electrodes		= (22:-1:1)';
p1.modes			= MODE.MP1_2;
p1.phase_width_us	= 25.0;
p1.phase_gap_us		=  8.0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters chosen so that current_level = magnitude

p1.lower_levels	= zeros(22, 1);
p1.upper_levels	= repmat(255, 22, 1);
p1.full_scale	= 255;
p1 = Channel_mapping_proc(p1);
Tester(p1.num_bands, 22);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sweep sequence has each channel in order:

N = 22;
n = (1:N)';
c0.channels			= n;
c0.magnitudes		= n * 10;
c0.periods_us		= repmat(100, N, 1);

q0 = Channel_mapping_proc(p1, c0);

if verbose > 3
	disp('c0');
	Disp_sequence(c0);
	disp('q0');
	Disp_sequence(q0);
end

Tester(Get_num_pulses(c0),	Get_num_pulses(q0));
Tester(q0.electrodes,		p1.electrodes);
Tester(q0.modes,			p1.modes);
Tester(q0.current_levels,	c0.magnitudes);
Tester(q0.phase_widths_us,	p1.phase_width_us);
Tester(q0.phase_gaps_us,	p1.phase_gap_us);
Tester(q0.periods_us,		c0.periods_us);

% Inverse mapping:

c0_inv = Channel_mapping_inv_proc(p1, q0);
Tester(c0_inv, c0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inverse mapping with E > 22

qx = q0;
qx.electrodes(4) = 24;
c7 = Channel_mapping_inv_proc(p1, qx);
c7_channels = c0.channels;
c7_channels(4) = 0;
Tester(c7.channels, c7_channels);
c7_magnitudes = c0.magnitudes;
c7_magnitudes(4) = 0;
Tester(c7.magnitudes, c7_magnitudes);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sequence has idle pulse (mag < 0), then each channel in order.
% (LGF_proc uses mag < 0 to indicate envelopes below base level).

c1.channels	    = [ 1; c0.channels];
c1.magnitudes	= [-1; c0.magnitudes];
c1.periods_us	= repmat(100, 23, 1);

q1 = Channel_mapping_proc(p1, c1);

if verbose > 3
	disp('c1');
	Disp_sequence(c1);
	disp('q1');
	Disp_sequence(q1);
end

Tester(Get_num_pulses(q1), 23);
Tester(q1.electrodes,		[ 22; p1.electrodes]);
Tester(q1.modes,			p1.modes);
Tester(q1.current_levels,	[ 0; c1.magnitudes(2:end)]);
Tester(q1.phase_widths_us,	p1.phase_width_us);
Tester(q1.phase_gaps_us,	p1.phase_gap_us);
Tester(q1.periods_us,		c1.periods_us);

% Inverse mapping:

c1_inv = Channel_mapping_inv_proc(p1, q1);

Tester(c1_inv.channels,		c1.channels);
Tester(c1_inv.magnitudes,	[0; c0.magnitudes]); % orignal magnitude was lost
Tester(c1_inv.periods_us,	c1.periods_us);

if verbose > 3
	disp('c1_inv');
	Disp_sequence(c1_inv);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Further idle tests:

% Sequences with constant channel, all idle  (mag < 0):
c_idle.channels		= 3;
c_idle.magnitudes	= repmat(-1, 4, 1);
c_idle.periods_us	= 100;

q_idle = Channel_mapping_proc(p1, c_idle);
Tester(q_idle.electrodes,		20);
Tester(q_idle.modes,			MODE.MP1_2);
Tester(q_idle.current_levels,	zeros(4,1));

if verbose > 3
	disp('q_normal_idle');
	Disp_sequence(q_idle);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters chosen so that current_level = lower_level

p2 = p1;
p2.lower_levels	= 5 * (1:p2.num_bands)';
p2.volume = 0;

p2 = Channel_mapping_proc(p2);
q2 = Channel_mapping_proc(p2, c1);

Tester(Get_num_pulses(c1),	Get_num_pulses(q2));
Tester(q2.electrodes,		[22; p2.electrodes]);
Tester(q2.modes,			p2.modes);
Tester(q2.current_levels,	[ 0; p2.lower_levels]);
Tester(q2.phase_widths_us,	p2.phase_width_us);
Tester(q2.phase_gaps_us,	p2.phase_gap_us);
Tester(q2.periods_us,		c1.periods_us);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

c3.channels		= [4;3;5;1;2];
c3.magnitudes	= linspace(0,100,5)';
c3.periods_us	= (100:100:500)';

p3.electrodes	= [20;16;12;7;2];
p3.modes		= MODE.MP1_2;
p3.lower_levels	= repmat(100, 5, 1);
p3.upper_levels	= repmat(200, 5, 1);
p3.full_scale	= 100;

p3.volume = 100;
p3  = Channel_mapping_proc(p3);
Tester(p3.num_bands, 5);

q3a = Channel_mapping_proc(p3, c3);

Tester(q3a.electrodes,	    [7;12;2;20;16]);
Tester(q3a.current_levels,	round(linspace(100,200,5))');
Tester(q3a.periods_us,		c3.periods_us);

% Inverse mapping:

p3_inv = Channel_mapping_inv_proc(p3);
c3_inv = Channel_mapping_inv_proc(p3_inv, q3a);

Tester(c3_inv, c3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p3.volume = 50;
p3  = Channel_mapping_proc(p3);
q3b = Channel_mapping_proc(p3, c3);

Tester(q3b.current_levels,	round(linspace(100,150,5))');
Tester(q3b.periods_us,		c3.periods_us);

% +++ check magnitudes greater than full_scale
% +++ check volumes greater than 100

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p4 = p3;
p4.volume_type = 'constant range';
p4.volume = 100;
p4 = Channel_mapping_proc(p4);
q4a = Channel_mapping_proc(p4, c3);

p4.volume = 50;
p4  = Channel_mapping_proc(p4);
q4b = Channel_mapping_proc(p4, c3);

p4.volume = 0;
p4  = Channel_mapping_proc(p4);
q4c = Channel_mapping_proc(p4, c3);

Tester(q4a.current_levels,	round(linspace(100,200,5))');
Tester(q4b.current_levels,	round(linspace( 50,150,5))');
Tester(q4c.current_levels,	round(linspace(  0,100,5))');

Tester(q4a.periods_us,		c3.periods_us);
Tester(q4b.periods_us,		c3.periods_us);
Tester(q4c.periods_us,		c3.periods_us);

p5.electrodes		= (5:-1:1)';
p5.modes			= MODE.MP1_2;
p5.lower_levels	    = repmat(100, 5, 1);
p5.upper_levels	    = repmat(150, 5, 1);
p5.full_scale		= 100;
p5.volume_type		= 'constant range';
p5.volume			= 100;
p5 = Channel_mapping_proc(p5);
Tester(p5.num_bands, 5);

q5a = Channel_mapping_proc(p5, c3);

p5.volume			= 200;
p5  = Channel_mapping_proc(p5);
q5b = Channel_mapping_proc(p5, c3);

Tester(q5a.current_levels,	round(linspace(100,150,5))');
Tester(q5b.current_levels,	round(linspace(150,200,5))');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sequence from map with disabled electrodes

p6 = struct;
p6.electrodes		= [22,21,18,15,14,12,9,8,7,3]';
num_bands          	= length(p6.electrodes);
p6.modes			= MODE.MP1_2;
p6.phase_width_us	= 25.0;
p6.phase_gap_us		=  8.0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters chosen so that current_level = magnitude

p6.lower_levels	= zeros(num_bands, 1);
p6.upper_levels	= repmat(255, num_bands, 1);
p6.full_scale	= 255;

p6 = Channel_mapping_proc(p6);
Tester(p6.num_bands == num_bands);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sweep sequence has each channel in order:

n = (1:num_bands)';
c6.channels			= n;
c6.magnitudes		= n * 10;
c6.periods_us		= repmat(100, num_bands, 1);

q6 = Channel_mapping_proc(p6, c6);

if verbose > 3
	disp('c6');
	Disp_sequence(c6);
	disp('q6');
	Disp_sequence(q6);
end

Tester(Get_num_pulses(c6),	Get_num_pulses(q6));
Tester(q6.electrodes,		p6.electrodes);
Tester(q6.modes,			p6.modes);
Tester(q6.current_levels,	c6.magnitudes);
Tester(q6.phase_widths_us,	p6.phase_width_us);
Tester(q6.phase_gaps_us,	p6.phase_gap_us);
Tester(q6.periods_us,		c6.periods_us);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inverse mapping:

c6_inv = Channel_mapping_inv_proc(p6, q6);
Tester(c6_inv, c6);

if verbose > 3
	disp('c6_inv');
	Disp_sequence(c6_inv);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

result = Tester;
