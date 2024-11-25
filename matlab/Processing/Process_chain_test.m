function result = Process_chain_test

% Process_chain_test: Test Process_chain and Process_chain_nargout.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

verbose = Tester(mfilename);

x1 = 5;

pa = struct;
pa = Append_process(pa, @Example1_proc);
pa = Append_process(pa, @Example_2out_proc);
pa = Append_process(pa, @Example2_proc);

% Collect primary outputs into cell array:
ca = Process_chain(pa, x1);
Tester(ca, {150; 165; 173});
Tester(Get_process_chain_output(pa, ca, @Example1_proc), 150);
Tester(Get_process_chain_output(pa, ca, @Example_2out_proc), 165);
Tester(Get_process_chain_output(pa, ca, @Example2_proc), 173);

% Collect all outputs into cell array;
% Example_2out_proc has 2 outputs.

na = Process_chain_nargout(pa, x1);
Tester(na, {{150}; {165, 155}; {173}});
Tester(Get_process_chain_output(pa, na, @Example1_proc), {150});
Tester(Get_process_chain_output(pa, na, @Example_2out_proc), {165, 155});
Tester(Get_process_chain_output(pa, na, @Example2_proc), {173});

% Check that parameters are updated before processing:
pa.h2 = 6;
cb = Process_chain(pa, x1);
Tester(cb, {150; 168; 176});
nb = Process_chain_nargout(pa, x1);
Tester(nb, {{150}; {168, 156}; {176}});

% Multiple output first in chain:
pc = pa;
pc.processes = pa.processes([2,1,3]);

cc = Process_chain(pc, -17);
Tester(cc, {1; 30; 38});
nc = Process_chain_nargout(pc, -17);
Tester(nc, {{1, -11}; {30}; {38}});

if verbose > 1
	ca
	na
	cb
	nb
	cc
	nc
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

result = Tester;	% Report result.
