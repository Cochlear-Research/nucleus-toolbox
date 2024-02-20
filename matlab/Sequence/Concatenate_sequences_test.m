function result = Concatenate_sequences_test

% Concatenate_sequences_test: Test of Concatenate_sequences.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

verbose = Tester(mfilename);

%#####################################################################
% Uniform-rate Channel-magnitude sequences:
%#####################################################################

% Single pulse:
quc1.channels	= 1;
quc1.magnitudes	= 10;
quc1.periods_us	= 100;
if verbose > 1, disp('quc1'), Disp_sequence(quc1); end
Tester(Get_num_pulses(quc1), 1);

% Constant period_us:
quc3.channels	= (1:3)';
quc3.magnitudes	= 10 * 3 + quc3.channels;
quc3.periods_us	= 100;
if verbose > 1, disp('quc3'), Disp_sequence(quc3); end
Tester(Get_num_pulses(quc3), 3);

% Constant period_us:
quc4.channels	= (1:4)';
quc4.magnitudes	= 10 * 4 + quc4.channels;
quc4.periods_us	= 200;
if verbose > 1, disp('quc4'), Disp_sequence(quc4); end
Tester(Get_num_pulses(quc4), 4);

% Constant period_us & channel:
quc5.channels	= 5;
quc5.magnitudes	= (10:10:50)';
quc5.periods_us	= 200;
if verbose > 1, disp('quc5'), Disp_sequence(quc5); end
Tester(Get_num_pulses(quc5), 5);
% Useful in creating output sequences:
quc5_channels	= repmat(quc5.channels, 5, 1);

% Constant period_us & magnitude:
quc6.channels	= (1:6)';
quc6.magnitudes	= 60;
quc6.periods_us	= quc3.periods_us;
if verbose > 1, disp('quc6'), Disp_sequence(quc6); end
Tester(Get_num_pulses(quc6), 6);
% Useful in creating output sequences:
quc6_magnitudes	= repmat(quc6.magnitudes, 6, 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Concatenate 2 copies of a one-pulse channel-magnitude sequence:

quc02 = Concatenate_sequences(quc1, quc1);
if verbose > 1, disp('quc02'), Disp_sequence(quc02); end
quc02_.channels		=  quc1.channels;
quc02_.magnitudes	= [quc1.magnitudes; quc1.magnitudes];
quc02_.periods_us	=  quc1.periods_us;

Tester(quc02, quc02_);
Tester(Get_num_pulses(quc02), 2);

% Pass arguments as a cell array of sequences:
quc02 = Concatenate_sequences({quc1, quc1});
Tester(quc02, quc02_);

% Use replication:
quc02 = Concatenate_sequences(quc1, 2);
if verbose > 1, disp('quc02'), Disp_sequence(quc02); end
Tester(quc02, quc02_);

% Include empty sequences:
quc02 = Concatenate_sequences([], quc1, [], quc1);
Tester(quc02, quc02_);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Concatenate 3 copies of a one-pulse channel-magnitude sequence:

quc03 = Concatenate_sequences(quc1, quc1, quc1);
if verbose > 1, disp('quc03'), Disp_sequence(quc03); end
quc03_.channels		=  quc1.channels;
quc03_.magnitudes	= [quc1.magnitudes;quc1.magnitudes;quc1.magnitudes];
quc03_.periods_us	=  quc1.periods_us;

Tester(quc03, quc03_);
Tester(Get_num_pulses(quc03), 3);

% Pass arguments as a cell array of sequences:
quc03 = Concatenate_sequences({quc1, quc1, quc1});
Tester(quc03, quc03_);

% Use replication:
quc03 = Concatenate_sequences(quc1, 3);
Tester(quc03, quc03_);

% Include empty sequences:
quc03 = Concatenate_sequences([], quc1, [], quc1, quc1);
Tester(quc03, quc03_);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Concatenate 2 copies of a constant-channel sequence:

quc55 = Concatenate_sequences(quc5, quc5);
if verbose > 1, disp('quc55'), Disp_sequence(quc55); end
quc55_.channels		=  quc5.channels;
quc55_.magnitudes	= [quc5.magnitudes; quc5.magnitudes];
quc55_.periods_us	=  quc5.periods_us;

Tester(quc55, quc55_);

% Pass arguments as a cell array of sequences:
quc55 = Concatenate_sequences({quc5, quc5});
Tester(quc55, quc55_);

% Use replication:
quc55 = Concatenate_sequences(quc5, 2);
Tester(quc55, quc55_);

% Include empty sequences:
quc55 = Concatenate_sequences({[], quc5, [], quc5, [], []});
Tester(quc55, quc55_);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Concatenate a one-pulse & constant-channel sequence:

quc15 = Concatenate_sequences(quc1, quc5);
if verbose > 1, disp('quc15'), Disp_sequence(quc15); end
quc15_.channels		= [quc1.channels;   quc5_channels];
quc15_.magnitudes	= [quc1.magnitudes; quc5.magnitudes];
quc15_.periods_us	= [quc1.periods_us;    repmat(quc5.periods_us,5,1)];

Tester(quc15, quc15_);
Tester(Get_num_pulses(quc15), 6);

% Pass arguments as a cell array of sequences:
quc15 = Concatenate_sequences({quc1, quc5});
Tester(quc15, quc15_);

% Include empty sequences:
quc15 = Concatenate_sequences({quc1, [], quc5, []});
Tester(quc15, quc15_);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Concatenate a constant-magnitude sequence to itself:

quc12 = Concatenate_sequences(quc6, quc6);
if verbose > 1, disp('quc12'), Disp_sequence(quc12); end
quc12_.channels		= [quc6.channels;   quc6.channels];
quc12_.magnitudes	=  quc6.magnitudes;
quc12_.periods_us	=  quc6.periods_us;

Tester(quc12, quc12_);
Tester(Get_num_pulses(quc12), 12);

% Pass arguments as a cell array of sequences:
quc12 = Concatenate_sequences({quc6, quc6});
Tester(quc12, quc12_);

% Use replication:
quc12 = Concatenate_sequences(quc6, 2);
Tester(quc12, quc12_);

% Include empty sequences:
quc12 = Concatenate_sequences(quc6, quc6, [], [], [], []);
Tester(quc12, quc12_);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Concatenate two uniform-rate channel-magnitude sequences that have the same period_us:

quc09 = Concatenate_sequences(quc6, quc3);
if verbose > 1, disp('quc09'), Disp_sequence(quc09); end
quc09_.channels		= [quc6.channels;   quc3.channels];
quc09_.magnitudes	= [quc6_magnitudes; quc3.magnitudes];
quc09_.periods_us	=  quc6.periods_us;

Tester(quc09, quc09_);
Tester(Get_num_pulses(quc09), 9);

% Pass arguments as a cell array of sequences:
quc09 = Concatenate_sequences({quc6, quc3});
Tester(quc09, quc09_);

% Include empty sequences:
quc09 = Concatenate_sequences({[], [], [], quc6, quc3});
Tester(quc09, quc09_);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Concatenate two uniform-rate channel-magnitude sequences that have different periods_us:

quc10 = Concatenate_sequences(quc6, quc4);
if verbose > 1, disp('quc10'), Disp_sequence(quc10); end
quc10_.channels		= [quc6.channels;   quc4.channels];
quc10_.magnitudes	= [quc6_magnitudes; quc4.magnitudes];
quc10_.periods_us	= [repmat(quc6.periods_us, 6, 1);
					   repmat(quc4.periods_us, 4, 1)];

Tester(quc10, quc10_);
Tester(Get_num_pulses(quc10), 10);

% Pass arguments as a cell array of sequences:
quc10 = Concatenate_sequences({quc6, quc4});
Tester(quc10, quc10_);

% Include empty sequences:
quc10 = Concatenate_sequences({[], quc6, [], quc4});
Tester(quc10, quc10_);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Concatenate 3 uniform-rate channel-magnitude sequences, all same period_us:

quc15 = Concatenate_sequences(quc6, quc3, quc6);
if verbose > 1, disp('quc15'), Disp_sequence(quc15); end
quc15_.channels	    = [quc6.channels;   quc3.channels;   quc6.channels];
quc15_.magnitudes	= [quc6_magnitudes; quc3.magnitudes; quc6_magnitudes];
quc15_.periods_us	=  quc6.periods_us;

Tester(quc15, quc15_);
Tester(Get_num_pulses(quc15), 15);

% Pass arguments as a cell array of sequences:
quc15 = Concatenate_sequences({quc6, quc3, quc6});
Tester(quc15, quc15_);

% Include empty sequences:
quc15 = Concatenate_sequences({quc6, [], quc3, quc6, []});
Tester(quc15, quc15_);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Concatenate 4 uniform-rate channel-magnitude sequences, all same period_us:

quc18 = Concatenate_sequences(quc6, quc3, quc6, quc3);
if verbose > 1, disp('quc18'), Disp_sequence(quc18); end
quc18_.channels	    = [quc6.channels;   quc3.channels;   quc6.channels;   quc3.channels];
quc18_.magnitudes   = [quc6_magnitudes; quc3.magnitudes; quc6_magnitudes; quc3.magnitudes];
quc18_.periods_us	=  quc6.periods_us;

Tester(quc18, quc18_);
Tester(Get_num_pulses(quc18), 18);

% Pass arguments as a cell array of sequences:
quc18 = Concatenate_sequences({quc6, quc3, quc6, quc3});
Tester(quc18, quc18_);

% Include empty sequences:
quc18 = Concatenate_sequences({[], quc6, [], [], quc3, quc6, [], quc3});
Tester(quc18, quc18_);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Concatenate 4 uniform-rate channel-magnitude sequences that have different periods_us:

quc19 = Concatenate_sequences(quc6, quc3, quc4, quc6);
if verbose > 1, disp('quc19'), Disp_sequence(quc19); end
quc19_.channels	    = [quc6.channels;   quc3.channels;   quc4.channels;   quc6.channels];
quc19_.magnitudes	= [quc6_magnitudes; quc3.magnitudes; quc4.magnitudes; quc6_magnitudes];
quc19_.periods_us	= [repmat(quc6.periods_us, 6, 1);
					   repmat(quc3.periods_us, 3, 1);
					   repmat(quc4.periods_us, 4, 1);
					   repmat(quc6.periods_us, 6, 1)];

Tester(quc19, quc19_);
Tester(Get_num_pulses(quc19), 19);

% Pass arguments as a cell array of sequences:
quc19 = Concatenate_sequences({quc6, quc3, quc4, quc6});
Tester(quc19, quc19_);

% Include empty sequences:
quc19 = Concatenate_sequences(quc6, quc3, quc4, [], quc6, []);
Tester(quc19, quc19_);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Replicate a single-pulse channel-magnitude sequence

quc2000 = Concatenate_sequences(quc1, 2000);
quc2000_.channels	=  quc1.channels;
quc2000_.magnitudes	=  repmat(quc1.magnitudes, 2000, 1);
quc2000_.periods_us	=  quc1.periods_us;

Tester(quc2000, quc2000_);
Tester(Get_num_pulses(quc2000), 2000);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Replicate a multiple-pulse channel-magnitude sequence

quc4000 = Concatenate_sequences(quc4, 1000);
quc4000_.channels	=  repmat(quc4.channels,   1000, 1);
quc4000_.magnitudes	=  repmat(quc4.magnitudes, 1000, 1);
quc4000_.periods_us	=  quc4.periods_us;

Tester(quc4000, quc4000_);
Tester(Get_num_pulses(quc4000), 4000);

%#####################################################################
% Uniform-rate Pulse sequences:
%#####################################################################

MODE = Implant_modes;

quf1.electrodes		    = 10;
quf1.modes			    = MODE.MP1;
quf1.current_levels	    = 100;
quf1.phase_widths_us	=  25.0;
quf1.phase_gaps_us		=   8.0;
quf1.periods_us		    = 200.0;
if verbose > 1, disp('quf1'), Disp_sequence(quf1); end
Tester(Get_num_pulses(quf1), 1);

quf3.electrodes		    = 10 + (1:3)';
quf3.modes			    = MODE.MP1;
quf3.current_levels	    = 10 * 3 + (1:3)';
quf3.phase_widths_us	=  30.0;
quf3.phase_gaps_us		=   8.0;
quf3.periods_us		    = 200.0;
if verbose > 1, disp('quf3'), Disp_sequence(quf3); end
Tester(Get_num_pulses(quf3), 3);

quf6.electrodes		    = (1:6)';
quf6.modes			    = MODE.MP1;
quf6.current_levels	    = 10 * 6 + quf6.electrodes;
quf6.phase_widths_us	=  25.0;
quf6.phase_gaps_us		=   8.0;
quf6.periods_us		    = 200.0;
if verbose > 1, disp('quf6'), Disp_sequence(quf6); end
Tester(Get_num_pulses(quf6), 6);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Concatenate a one-pulse frame sequence to itself:

quf02 = Concatenate_sequences(quf1, quf1);
if verbose > 1, disp('quf02'), Disp_sequence(quf02); end
quf02_.electrodes		=  quf1.electrodes;
quf02_.modes			=  quf1.modes;
quf02_.current_levels	= [quf1.current_levels; quf1.current_levels];
quf02_.phase_widths_us	=  quf1.phase_widths_us;
quf02_.phase_gaps_us	=  quf1.phase_gaps_us;
quf02_.periods_us		=  quf1.periods_us;

Tester(quf02, quf02_);
Tester(Get_num_pulses(quf02), 2);

% Pass arguments as a cell array of sequences:
quf02 = Concatenate_sequences({quf1, quf1});
Tester(quf02, quf02_);

% Use replication:
quf02 = Concatenate_sequences(quf1, 2);
Tester(quf02, quf02_);

% Include empty sequences:
quf02 = Concatenate_sequences({quf1, [], [], quf1});
Tester(quf02, quf02_);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Concatenate a uniform-rate frame sequence to itself:

quf12 = Concatenate_sequences(quf6, quf6);
if verbose > 1, disp('quf12'), Disp_sequence(quf12); end
quf12_.electrodes		= [quf6.electrodes;		quf6.electrodes];
quf12_.modes			=  quf6.modes;
quf12_.current_levels	= [quf6.current_levels;	quf6.current_levels];
quf12_.phase_widths_us	=  quf6.phase_widths_us;
quf12_.phase_gaps_us	=  quf6.phase_gaps_us;
quf12_.periods_us		=  quf6.periods_us;

Tester(quf12, quf12_);
Tester(Get_num_pulses(quf12), 12);

% Pass arguments as a cell array of sequences:
quf12 = Concatenate_sequences({quf6, quf6});
Tester(quf12, quf12_);

% Use replication:
quf12 = Concatenate_sequences(quf6, 2);
Tester(quf12, quf12_);

% Include empty sequences:
quf12 = Concatenate_sequences([], quf6, quf6);
Tester(quf12, quf12_);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Concatenate two uniform-rate frame sequences with different phase widths:

quf09 = Concatenate_sequences(quf6, quf3);
if verbose > 1, disp('quf09'), Disp_sequence(quf09); end
quf09_.electrodes		= [quf6.electrodes;   	quf3.electrodes];
quf09_.modes			= quf6.modes;
quf09_.current_levels	= [quf6.current_levels;	quf3.current_levels];
quf09_.phase_widths_us	= [repmat(quf6.phase_widths_us, 6, 1);
						   repmat(quf3.phase_widths_us, 3, 1)];
quf09_.phase_gaps_us	=  quf6.phase_gaps_us;
quf09_.periods_us		=  quf6.periods_us;

Tester(quf09, quf09_);
Tester(Get_num_pulses(quf09), 9);

% Pass arguments as a cell array of sequences:
quf09 = Concatenate_sequences({quf6, quf3});
Tester(quf09, quf09_);

% Include empty sequences:
quf09 = Concatenate_sequences({quf6, quf3, [], [], [], []});
Tester(quf09, quf09_);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Replicate a single-pulse frame sequence

quf2000 = Concatenate_sequences(quf1, 2000);
quf2000_.electrodes		    =  quf1.electrodes;
quf2000_.modes			    =  quf1.modes;
quf2000_.current_levels	    =  repmat(quf1.current_levels, 2000, 1);
quf2000_.phase_widths_us	=  quf1.phase_widths_us;
quf2000_.phase_gaps_us		=  quf1.phase_gaps_us;
quf2000_.periods_us		    =  quf1.periods_us;

Tester(quf2000, quf2000_);
Tester(Get_num_pulses(quf2000), 2000);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Replicate a multiple-pulse frame sequence

quf6000 = Concatenate_sequences(quf6, 1000);
quf6000_.electrodes		    =  repmat(quf6.electrodes,    1000, 1);
quf6000_.modes			    =  quf6.modes;
quf6000_.current_levels	    =  repmat(quf6.current_levels,1000, 1);
quf6000_.phase_widths_us	=  quf6.phase_widths_us;
quf6000_.phase_gaps_us		=  quf6.phase_gaps_us;
quf6000_.periods_us		    =  quf6.periods_us;

Tester(quf6000, quf6000_);
Tester(Get_num_pulses(quf6000), 6000);

%#####################################################################
% Try to concatenate sequences with different fields:
%#####################################################################

try
	Concatenate_sequences(quc6, quf6);
	Tester(0);		% FAIL
catch x
	Tester(contains(x.identifier, 'nonExistentField'));
end

% Pass arguments as a cell array of sequences:

try
	Concatenate_sequences({quc6, quf6});
	Tester(0);		% FAIL
catch x
	Tester(contains(x.identifier, 'nonExistentField'));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

result = Tester;	% Report result
