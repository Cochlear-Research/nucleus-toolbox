function y = Process_chain(p, x)

% Process_chain: Process a signal according to a parameter struct, return intermediate signals.
%
% y = Process_chain(p, x)
%
% p:           Parameter struct.
% p.processes: Functions to call.
% x:           Input to the first process in the chain.
% y:           Cell array containing the outputs of each process in the chain.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

num_processes = length(p.processes);

for n = 1:num_processes
	p = feval(p.processes{n}, p);		% Calculate parameters.
end

y = cell(num_processes, 1);
for n = 1:num_processes
    f = p.processes{n};
	y{n} = f(p, x);
	x = y{n};
end
