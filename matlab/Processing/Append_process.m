function p = Append_process(p, f, branch)

% Append_process: Append a processing function to a chain.
% This function sets up the parameter struct for Process.
%
% p_out = Append_process(p_in, f, branch)
%
% p_in:     Input process parameter struct.
% f:        Processing function handle (or name).
% branch:   Optional name of process branch (else uses main processes chain).
% p_out:    Output process parameter struct.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isa(f, 'function_handle')
    f = str2func(f);
end
if nargin < 3
	branch = 'processes';
end
p = Ensure_field(p, branch, {});
p.(branch){end + 1, 1} = f;				% Append function to process list.	
p = f(p);						        % Set up parameters.	
