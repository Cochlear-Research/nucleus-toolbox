function y = Process(p, x)

% Process: Process a signal according to a parameter struct. 
% function y = Process(p, x)
%
% Inputs:
% p:           Parameter struct.
% p.processes: Cell array containing a list of functions to call.
% x:           Input to the first function in the process chain.
%
% Outputs:
% y:           Output from the last function in the process chain.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch nargin

case 0
		error('First arg must be a parameter struct.');	
case 1
        y = Process_parameters(p);
case 2
		y = Process_signal(p, x);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function p = Process_parameters(p)

	for n = 1:length(p.processes)
        f = p.processes{n};
		p = f(p);		% Calculate parameters.
	end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function x = Process_signal(p, x)

    num_processes = length(p.processes);
    retained_signals = cell(num_processes, 1);
	for n = 1:length(p.processes)
        f = p.processes{n};     % Processing function.
        j = p.joiners{n};  % Index into previously-calculated signals.
        if j > 0
            % Processing that requires two input signals:
            x2 = retained_signals{j};
            assert(~isempty(x2));
            x = f(p, x, x2);
        else
            % Processing that requires one input signal:
		    x = f(p, x);
        end
        if p.retainers{n}
            retained_signals{n} = x;
        end
	end

