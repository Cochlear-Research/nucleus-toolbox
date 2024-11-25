function x = Get_process_chain_output(p, c, f)

% Get_chain_output: Get the output of one process from Process_chain.
%
% x = Get_process_chain_output(p, c, f)
%
% p: Process parameter struct.
% c: Cell array produced by Process_chain.
% f: Processing function handle (or name).
%
% x: Output signal.
%
% Example:
% p = ACE_map;
% c = Process_chain(p, 'asa.wav');
% v = Get_process_chain_output(p, c, @Reject_smallest)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n = Find_process(p, f);
x = c{n};