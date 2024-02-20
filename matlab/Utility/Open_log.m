function [file_name_out, echo_state_out] = Open_log(varargin)

% Open_log: Open a log file (for use with Write_log).
%
% function [file_name_out, echo_state_out] = Open_log(varargin)
%
% The input arguments should be strings.
% Some strings set up options:
% 'echo'  : Enables echo to standard output in Write_log.
% '~echo' : Disables echo to standard output in Write_log.
% '~file' : Disables file output in Write_log.
% 'new'   : Discards any existing file contents.
%
% Any other string is taken as the file name.
% It returns the file name and the echo state (strings).
%
% Examples:
%
% [f, e] = Open_log;           : Get filename into f, get echo state into e.
% Open_log foo.log;            : Set file name to 'foo.log'.
% Open_log ~file;              : Turn file log off.
% Open_log echo;               : Turn echo on.
% Open_log ~echo;              : Turn echo off.
% Open_log new;                : Discard contents of current log file.
% Open_log hoo.txt echo;       : Set file name to 'hoo.txt', turn echo on.
% Open_log boo.txt new;        : Set file name to 'boo.txt', discard old file contents.
% Open_log goo.txt echo new;   : Set file name to 'boo.txt', turn echo on, discard old file contents.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

persistent file_name;
persistent echo_state;

if isempty(echo_state)
	echo_state = 'echo';				% Initial state.
end

for n = 1:nargin

	switch varargin{n}
	
		case '~echo'
			echo_state = '~echo';
			
		case 'echo'
			echo_state = 'echo';
			
		case 'new'
			fid = fopen(file_name, 'w'); % Discard contents of file if it exists.
			fclose(fid);
			
		case '~file'
			file_name = '';

		otherwise
			file_name = varargin{n};
			fid = fopen(file_name, 'a'); % Create file if needed,
										 % but don't discard contents of an existing file.
			fclose(fid);
	end
end				

file_name_out  = file_name;
echo_state_out = echo_state;

