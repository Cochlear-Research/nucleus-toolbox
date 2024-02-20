function a = Read_bin(file_name, num_rows, precision, endian)
% Read_bin: Reads a 1 or 2D matrix from a binary file.
% function a = Read_bin(file_name, [num_rows], [precision], [endian])
%	num_rows:	number of rows in the array (default = 1)
% 	precision:	numeric type for fread
%				'int16'  = signed 16-bit integers (default)
%				'uint16' = unsigned  16-bit integers
%	endian:		machine format
%				'l' = little-endian (least sig byte first) Intel (default)
%				'b' = big-endian (most sig byte first) Mac, SP5
%
% test = Read_bin('test.bin')
% test = Read_bin('test.bin', 2)
% test = Read_bin('test.bin', 2, 'uint16')
% test = Read_bin('test.spb', 2, 'uint16','b')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 1 						
	error('incorrect usage');
end

if nargin < 3 						
	precision = 'int16';	% Default: 16-bit signed integers
end

if nargin < 4 						
	endian = 'l';			% Default: little-endian (Intel)
end

fid = fopen(file_name, 'r', endian);
if (fid == -1)
	error('Cannot open file');
end
a = fread(fid, precision);	% Column vector
fclose(fid);

if (nargin >= 2)
	a = reshape(a, num_rows, length(a)/num_rows);
end
