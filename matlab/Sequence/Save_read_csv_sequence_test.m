function result = Save_read_csv_sequence_test

% Save_read_csv_sequence_test: Test of Save_csv_sequence, Read_csv_sequence.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Tester(mfilename);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MODE = Implant_modes;

quf6.electrodes		    = (1:6)';
quf6.modes			    = MODE.MP1;
quf6.current_levels	    = 10 * 6 + quf6.electrodes;
quf6.phase_widths_us	=  25.0;
quf6.phase_gaps_us		=   8.0;
quf6.periods_us		    = 200.0;

Save_csv_sequence(quf6, fullfile(Nucleus_dir, 'test_out', 'quf6'));
% Compare to known good reference file:
r = cmp(fullfile(Nucleus_dir, 'test_in', 'quf6.csv'), fullfile(Nucleus_dir, 'test_out', 'quf6.csv'), '-s');
Tester(r.error == 0);

% In csv files, all rows should be the same length,
% so all fields will have the same length.
quf6c = Complete_sequence(quf6);
% Should get same csv file for the "complete" sequence:
Save_csv_sequence(quf6c, fullfile(Nucleus_dir, 'test_out', 'quf6c'));
r = cmp(fullfile(Nucleus_dir, 'test_in', 'quf6.csv'), fullfile(Nucleus_dir, 'test_out', 'quf6c.csv'), '-s');
Tester(r.error == 0);

% Reading known good reference file should give the "complete" sequence.
q = Read_csv_sequence(fullfile(Nucleus_dir, 'test_in', 'quf6'));
Tester(quf6c, q);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

result = Tester;	% Report result
