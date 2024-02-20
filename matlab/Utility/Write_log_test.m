function result = Write_log_test

% Write_log_test: Test of Open_log and Write_log.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Tester(mfilename);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Open_log Test1.log new;
Write_log('x = ');		% no newline
Write_log('%d\n', 1);
Write_log('---\n');

expected = {
'x = 1',
'---'
};

log_file_name = Open_log;
Tester(log_file_name, 'Test1.log');

actual = Read_text_file(log_file_name);
Tester(actual, expected);

% Change log file:
log_file_name = Open_log('Test2.log', 'new');
Tester(log_file_name, 'Test2.log');

Write_log('testing\n');
Tester(Read_text_file(log_file_name), {'testing'});

% Append to existing log file:
Open_log Test1.log;
Write_log('appending\n');

expected{end+1} = 'appending';
actual = Read_text_file('Test1.log');
Tester(actual, expected);

delete('Test2.log');
% Test1.log is the open log, it will be deleted by Tester.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

result = Tester;	% Report result.