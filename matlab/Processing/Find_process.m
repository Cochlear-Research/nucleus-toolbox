function index = Find_process(p, f)

% Find_process: Return the index of a process in a process chain.
% 
% index = Find_process(p, proc)
%
% p:           Parameter struct describing a process chain.
% proc:        Function handle (or name) to search for.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isa(f, 'function_handle')
    f = str2func(f);
end

for index = 1:length(p.processes)
    if isequal(p.processes{index}, f)
        return
    end
end

error('Nucleus:Processing', 'Process %s not found.', func2str(f));
