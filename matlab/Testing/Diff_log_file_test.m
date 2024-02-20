function result = Diff_log_file_test

% Diff_log_file_test: Test of Diff_log_file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Tester(mfilename);

Open_log([mfilename, '.log'], 'new');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Empty log file:

% Empty
Tester(0, Diff_log_file({}));

not_empty = {
'hello'
};
% Log file too short (empty):
Tester(-1, Diff_log_file(not_empty));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% No time-stamps in log file:

Write_log('foo 100\nbar 200\n\n3\n');

% Log file too long (expect empty):
Tester(-2, Diff_log_file({}));

match = {
'foo 100'
'bar 200'
''
'3'
};
Tester(0, Diff_log_file(match));

match2 = {
'foo 100'
'bar #mismatch here is ignored'
''
'3'
};
Tester(0, Diff_log_file(match2));

match3 = {
'foo 100'
'#' % ignore entire line
''
'3'
};
Tester(0, Diff_log_file(match3));

match4 = {
'foo 100'
'bar 200'
'# ignore this'
'3'
};
Tester(0, Diff_log_file(match4));

mismatch1 = {
'foo 100'
'mismatch'
''
'3'
};
Tester(2, Diff_log_file(mismatch1));

mismatch2 = {
'foo 100 mismatch' % extra characters on line
'bar 200'
''
'3'
};
Tester(1, Diff_log_file(mismatch2));

mismatch3 = {
'foo' % too few characters on line
'bar 200'
''
'3'
};
Tester(1, Diff_log_file(mismatch3));

mismatch_empty = {
'foo 100'
'bar 200'
'mismatch'
'3'
};
Tester(3, Diff_log_file(mismatch_empty));

omit_empty = {
'foo 100'
'bar 200'
'3'
};
Tester(3, Diff_log_file(omit_empty));

longer = {
'foo 100'
'bar 200'
''
'3'
'4'
};
Tester(-1, Diff_log_file(longer)); % log file too short.

shorter = {
'foo 100'
'bar 200'
};
Tester(-2, Diff_log_file(shorter)); % log file too long.

inserted_skip_line = {
'foo 100'
'#'     % causes out of sync
'bar 200'
'3'
};
Tester(3, Diff_log_file(inserted_skip_line));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time-stamps in log file:

Write_log_time_stamp;
Write_log('--\n');

match1 = {
'foo 100'
'bar 200'
''
'3'
'time #'
'--'
};
Tester(0, Diff_log_file(match1));

match2 = {
'foo 100'
'bar 200'
''
'3'
'time # ignores remainder of line'
'--'
};
Tester(0, Diff_log_file(match2));

mismatch_time = {
'foo 100'
'bar 200'
''
'3'
'time 2002-08-04-22-46-27'
'--'
};
Tester(5, Diff_log_file(mismatch_time));

mismatch1 = {
'foo 100'
'bar 299'
''
'3'
'time #'
'--'
};
Tester(2, Diff_log_file(mismatch1));

mismatch2 = {
'foo 100'
'bar 200'
''
'3'
''  % need something here
'--'
};
Tester(5, Diff_log_file(mismatch2));

longer = {
'foo 100'
'bar 200'
''
'3'
'time #'
'--'
'4'
};
Tester(-1, Diff_log_file(longer)); % log file too short.

shorter = {
'foo 100'
'bar 200'
''
'3'
};
Tester(-2, Diff_log_file(shorter)); % log file too long

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

result = Tester;	% Report result.