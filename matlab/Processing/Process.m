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
%   retain:      0: Do not retain intermediate signals (default).
%                1: Retain first output of each process.
%                2: Retain all outputs of each process.
%
% Outputs:
% y:           Output with format depending on options.retain.
% p:           Updated parameter struct.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

arguments
    p struct
    x = {}
    options.recalc = true
    options.retain = 0
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
    return
end

% Perform processing:
retained_signals = cell(num_processes, 1);

for n = 1:num_processes
    f = p.processes{n};
    t = cell(1, nargout(f));
	[t{:}] = f(p, x);	       % Collect multiple outputs into cell array.
    x = t{1};
    if options.retain > 0
        retained_signals{n} = t;
    end
end

switch options.retain
    case 0
        y = x;
    case 1
        y = cell(num_processes, 1);
        for n = 1:num_processes
            y{n} = retained_signals{n}{1};
        end
    case 2
        y = retained_signals;
end

