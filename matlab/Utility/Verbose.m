function v = Verbose(n)

% Verbose: Set and get verbosity level. Used to control amount of output.
%
% Verbose(n):   Set the verbosity level to n.
% v = Verbose;  Get the verbosity level.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

persistent verbose;		% integer level

if isempty(verbose)
	verbose = 0;
end

if nargin == 1
	verbose = n;
end
	
v = verbose;
	