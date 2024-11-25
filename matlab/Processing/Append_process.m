function p = Append_process(p, f)

% Append_process: Append a processing function to a chain.
% This function sets up the parameter struct for Process.
%
% p_out = Append_process(p_in, f)
%
% p_in:     Input process parameter struct.
% f:        Processing function handle (or name).
%
% p_out:    Output process parameter struct.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

arguments
    p struct 
    f {mustBeA(f, ["char", "string", "function_handle"])}
end 

if ~isa(f, 'function_handle')
    f = str2func(f);
end
p = Ensure_field(p, 'processes', {});
p.processes{end + 1, 1} = f;			% Append function to process list.	
p = f(p);						        % Set up parameters.	
