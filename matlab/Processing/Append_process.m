function p = Append_process(p, f, second_source)

% Append_process: Append a processing function to a chain.
% This function sets up the parameter struct for Process.
%
% p_out = Append_process(p_in, f)
%
% p_in:     Input process parameter struct.
% f:        Processing function handle (or name).
% p_out:    Output process parameter struct.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isa(f, 'function_handle')
    f = str2func(f);
end

p = Ensure_field(p, 'processes', {});   % Processing functions
p = Ensure_field(p, 'retainers', {});   % If true, retain output
p = Ensure_field(p, 'joiners',   {});   % Index of second input signals  

if nargin < 3
    j = 0;
else
    j = Find_process(p, second_source);
    % The output of that process must be retained:
    p.retainers{j} = true;
end

p.processes{end + 1, 1} = f;	    % Append function to process list.
p.retainers{end + 1, 1} = false;	% Default is to not retain this output.	
p.joiners  {end + 1, 1} = j;	    % Append index to source of second input.	

p = f(p);					        % Set up parameters.	
