function v = Constrain_parameter_proc(p, u)

% Constrain_parameter_proc: Constrain a parameter between min and max values.
% This is a special type of process. 
% Its action depends on the number of arguments.
%
% It can be called with a single argument, an existing parameter struct,
% which has been created by using Append_process.
% The first time it is called like this, it prepends itself to the processes field.
% It also constrains the parameter named by p.parameter_name
% to lie between the values p.parameter_min and p.parameter_max.
%
% pout = Constrain_parameter_proc(p)
% p:    Parameter struct.
% pout: Updated parameter struct.
%
% If it is called with two arguments, 
% it copies the second argument to the output.
%
% v = Constrain_parameter_proc(p, u)
% p:    Parameter struct.
% u:    Input signal.
% v:    Output signal, identical to input signal.
%
% It is designed to work with the Process function.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch nargin

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 0	% Default parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	error('Param struct must be supplied');
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 1	% Parameter calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	if ~isfield(p, 'processes')
		error('Argument must be a parameter struct created with Append_process');
	end
	
	if ~isequal(p.processes{1}, @Constrain_parameter_proc)
		p.processes = {@Constrain_parameter_proc; p.processes{:} };
	end

	p = Ensure_field(p, 'parameter_fmt', '%3d');
	
	value = getfield(p, p.parameter_name);	
	value = min(value, p.parameter_max);
	value = max(value, p.parameter_min);
	
	v = setfield(p, p.parameter_name, value);
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 2	% Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	v = u;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
