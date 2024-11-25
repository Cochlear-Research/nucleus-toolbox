function y = Process_chain_nargout(p, x)

% Process_chain: Process a signal and return all outputs of each process.
% Each element is a cell array containing all outputs of each process.
% This capability is available in Process,
% but this function is kept for backward compatibility.
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

y = Process(p, x, retain=2);
