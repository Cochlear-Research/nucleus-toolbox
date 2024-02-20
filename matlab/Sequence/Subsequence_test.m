function result = Subsequence_test

% Subsequence_test: Test Subsequence.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Tester(mfilename);
MODE = Implant_modes;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Channel magnitude sequence, constant period_us:
qc.channels	    = (1:5)';
qc.magnitudes	= (10:10:50)';
qc.periods_us	= 200;

% 2 indices:
yc = Subsequence(qc, 2, 4);
Tester(yc.channels,   [2;3;4]);
Tester(yc.magnitudes, [20;30;40]);
Tester(yc.periods_us, 200);

% 1 index:
yc = Subsequence(qc, 2);
Tester(yc.channels,   [2;3;4;5]);
Tester(yc.magnitudes, [20;30;40;50]);
Tester(yc.periods_us, 200);

% Negative index:
yc = Subsequence(qc, -3);
Tester(yc.channels,   [3;4;5]);
Tester(yc.magnitudes, [30;40;50]);
Tester(yc.periods_us, 200);

% Negative index:
yc = Subsequence(qc, -1);
Tester(yc.channels,   5);
Tester(yc.magnitudes, 50);
Tester(yc.periods_us, 200);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Electrode current-level sequence, constant period_us:
qe.electrodes	    = (22:-1:18)';
qe.modes	        = MODE.MP1_2;
qe.current_levels   = (101:105)';
qe.phase_widths_us  = 25;
qe.phase_gaps_us    = 10;
qe.periods_us	    = 200;

% 2 indices:
ye = Subsequence(qe, 2, 4);
Tester(ye.electrodes,		[21;20;19]);
Tester(ye.modes,			qe.modes);
Tester(ye.current_levels,	[102;103;104]);
Tester(ye.phase_widths_us,	qe.phase_widths_us);
Tester(ye.phase_gaps_us,	qe.phase_gaps_us);
Tester(ye.periods_us,		qe.periods_us);

% 1 index:
ye = Subsequence(qe, 2);
Tester(ye.electrodes,		[21;20;19;18]);
Tester(ye.modes,			qe.modes);
Tester(ye.current_levels,	[102;103;104;105]);
Tester(ye.phase_widths_us,	qe.phase_widths_us);
Tester(ye.phase_gaps_us,	qe.phase_gaps_us);
Tester(ye.periods_us,		qe.periods_us);

% Negative index:
ye = Subsequence(qe, -3);
Tester(ye.electrodes,		[20;19;18]);
Tester(ye.modes,			qe.modes);
Tester(ye.current_levels,	[103;104;105]);
Tester(ye.phase_widths_us,	qe.phase_widths_us);
Tester(ye.phase_gaps_us,	qe.phase_gaps_us);
Tester(ye.periods_us,		qe.periods_us);

% Negative index:
ye = Subsequence(qe, -1);
Tester(ye.electrodes,		18);
Tester(ye.modes,			qe.modes);
Tester(ye.current_levels,	105);
Tester(ye.phase_widths_us,	qe.phase_widths_us);
Tester(ye.phase_gaps_us,	qe.phase_gaps_us);
Tester(ye.periods_us,		qe.periods_us);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

result = Tester;	% Report result

end
