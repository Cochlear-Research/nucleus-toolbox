function [p1, p2] = Split_process(p, n)

% Split_process: Split a process chain into two sub-chains. 
% 
% [p1, p2] = Split_process(p, n)
%
% p:           Parameter struct describing a process chain.
% n:           Specifies the last process in the head of the chain;
%              either as an integer, or as a function handle or name.
%              Positive integers count from the start,
%              negative integers count from the end.
% p1:          Parameter struct containing the head of the process chain.
% p2:          Parameter struct containing the tail of the process chain.
%
% The field processes of struct p is split into two.
% All other parameters are copied into both the head and tail.
%
% Examples:
% [p1, p2] = Split_process(p, 2);    % Split after the second process.
% [p1, p2] = Split_process(p, -1);   % Split before the last process.
% [p1, p2] = Split_process(p, @Channel_mapping_proc);   % Split after Channel_mapping_proc.
% [p1, p2] = Split_process(p, 'Channel_mapping_proc');  % Split after Channel_mapping_proc.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isnumeric(n)    % arg is function handle or name
	n = Find_process(p, n);
end

num_processes = length(p.processes);
if (n > num_processes)
	error('n exceeds number of processes.');
end
if (n < 0)
	n = num_processes + n;
end

p1 = p;
p2 = p;

if (n == 0)
	p1.processes = {};
	
elseif (n == num_processes)
	p2.processes = {};

else
	p1.processes = p.processes(1:n);
	p2.processes = p.processes(n+1:end);
end