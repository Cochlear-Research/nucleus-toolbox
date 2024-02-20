function Write_log_time_stamp

% Write_log_time_stamp: Write date & time to a log file (set up by Open_log).
% In unit testing we compare a new log to an old log,
% so we begin the line with 'time' so that it can be found easily.
% See Compare_log_file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Write_log('time %s\n', Time_stamp_string);
