function Write_log_cell_array(c)

% Write_log_cell_array: Write cell array to log file.
%
% Write_log_cell_array(c)
% c: a cell array of numbers or strings.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~iscell(c)
	error('Expected cell array');
end

if ischar(c{1})
	Write_log('%s', [c{:}]);
	
elseif isnumeric(c{1})
	Write_log('%3d ', [c{:}]);
	
else
	error('Bad data type');
end

