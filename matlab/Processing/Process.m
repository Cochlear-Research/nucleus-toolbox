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
%   retain:      false: Do not retain intermediate signals (default).
%                true: retain intermediate signals.
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
    switch options.retain
        case 0
            % no action
        case 1
            retained_signals{n} = x;
        case 2
            retained_signals{n} = t;
        otherwise
            error("invalid retain option")
    end
end

if options.retain > 0
    y = retained_signals;
else
    y = x;
end

