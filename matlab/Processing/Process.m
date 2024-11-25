function [y, p] = Process(p, x, options)

% Process: Process a signal according to a parameter struct.
%
% [y, p] = Process(p, x, options)
%
% Inputs:
% p:           Parameter struct.
% p.processes: Cell array containing a list of functions to call.
% x:           Input to the first function in the process chain.
% options:     Name-Value arguments:
%   recalc:      true:  Recalculate parameter struct before processing (default).
%                false: Specify if parameters are unchanged (saves time).
%
% Outputs:
% y:           Output from the last function in the process chain.
% p:           Updated parameter struct.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

arguments
    p struct
    x = []
    options.recalc = true
end 

num_processes = length(p.processes);

if options.recalc
	for n = 1:num_processes
        f = p.processes{n};
		p = f(p);		% Calculate parameters.
	end
end

if isempty(x)
    y = p;              % Allows: p = Process(p)
else
    for n = 1:num_processes
        f = p.processes{n};
		x = f(p, x);   % Perform processing.
    end
    y = x;
end
