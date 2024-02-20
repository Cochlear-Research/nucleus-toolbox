function varargout = Process(p, x, recalc)

% Process: Process a signal according to a parameter struct. 
% function [x, p] = Process(p, x)
%
% Inputs:
% p:           Parameter struct.
% p.processes: Cell array containing a list of functions to call.
% x:           Input to the first function in the process chain.
% recalc:      If true, then parameters are recalculated before
%                processing the input signal.
%                Defaults to true if the argument is omitted.
%
% Outputs:
% x:           Output from the last function in the process chain.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch nargin

case 0
		error('First arg must be a parameter struct.');	
case 1
		p = Process_parameters(p);
		varargout = {p};	
case 2
		p = Process_parameters(p);
		y = Process_signal(p, x);
		varargout = {y, p};	
case 3
		if (recalc)
			p = Process_parameters(p);
		end
		y = Process_signal(p, x);
		varargout = {y, p};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function p = Process_parameters(p)

	for n = 1:length(p.processes)
        f = p.processes{n};
		p = f(p);		% Calculate parameters.
	end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function x = Process_signal(p, x)

	for n = 1:length(p.processes)
        f = p.processes{n};
		x = f(p, x);     % Perform processing.
	end

