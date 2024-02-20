function Write_log(varargin)

% Write_log: Write text to a log file (set up by Open_log).
%
% function Write_log(varargin)
%
% This function takes the same arguments as fprintf,
% except that you don't specify a file id;
% instead it writes to the file set up by Open_log.
% The text is appended to the log file, 
% and optionally echoed to standard output.
% The log file is opened and closed on every call;
% this ensures that text is not lost if an error occurs,
% and allows the contents of the file to be observed
% by another application (perhaps on another PC).
% Logging to a file and echoing to stdout can both be
% enabled or disabled independently.
%
% Write_log('Start\n');				% Write 'Start\n' to the log file.
% Write_log('x = %d', x);			% Log the value of variable x.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[file_name, echo_state] = Open_log;

if ~isempty(file_name)
	fid = fopen(file_name, 'a');	% Open file & append to end.
	fprintf(fid, varargin{:});		% Write text to file.
	fclose(fid);
end

if isequal(echo_state, 'echo')
	fprintf(1, varargin{:});		% fid = 1 means stdout.
end

