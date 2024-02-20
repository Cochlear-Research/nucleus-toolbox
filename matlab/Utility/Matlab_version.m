function v = Matlab_version

% Matlab_version: returns MATLAB version as a number.
% The built-in function version returns a string,
% which is inconvenient for comparison purposes.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

version_str = version;				% a string
v = sscanf(version_str, '%f', 1);	% read one floating point number, e.g. '6.1'
