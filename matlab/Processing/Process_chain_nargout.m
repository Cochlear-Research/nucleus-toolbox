function y = Process_chain_nargout(p, x)

% Process_chain_nargout: Process a signal according to a parameter struct, return all intermediate signals.
% Each element is a cell array containing all outputs of each function.
%
% y = Process_chain_nargout(p, x)
%
% p:           Parameter struct.
% p.processes: Functions to call.
% x:           Input to the first process in the chain.
% y:           Cell array of cell arrays containing all of the outputs of each process in the chain.

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
    t = cell(1, nargout(f));
	[t{:}] = f(p, x);	                % Collect multiple outputs into cell array.
	y{n} = t;                           % Store multiple outputs.
	x = t{1};                           % First output becomes next input.
end
