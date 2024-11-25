function y = Process_chain(p, x)

% Process_chain: Process a signal and return first output of each process.
% This capability is available in Process,
% but this function is kept for backward compatibility.
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

y = Process(p, x, retain=1);
