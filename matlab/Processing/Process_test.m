function result = Process_test

% Process_test: Test process framework.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

verbose = Tester(mfilename);

x1 = 5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Only one function in the chain.

% Direct call:

p1 = Example1_proc; 				% All defaults
p1_.f1 = 10;
p1_.f2 = 20;
p1_.f3 = 30;
Tester(p1,  p1_);

d1  = Example1_proc(p1, x1);		% Direct
d1_ = 30 * x1;						% Expected output
Tester(d1,  d1_);

% Process:

pa  = struct;
pa  = Append_process(pa, @Example1_proc);
pa_ = p1_;
pa_.processes = {@Example1_proc};
Tester(pa,  pa_);

i1 = Process(pa, x1);				% Indirect
Tester(i1, d1_);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Direct call:

p2 = Example2_proc; 				% All defaults
p2_.g1 = 2;
p2_.g2 = 4;
p2_.g3 = 8;
Tester(p2,  p2_);

d2  = Example2_proc(p2, x1);		% Direct
d2_ = x1 + 8;						% Expected output
Tester(d2,  d2_);

% Process:

pb  = Append_process(struct, @Example2_proc);
pb_ = p2_;
pb_.processes = {@Example2_proc};
Tester(pb,  pb_);

i2 = Process(pb, x1);				% Indirect
Tester(i2, d2_);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Two functions in the chain.

% Direct:

d1  = Example1_proc(p1, x1);		% Direct
dc  = Example2_proc(p2, d1);		% Direct
dc_ = (30 * x1) + 8;				% Expected output
Tester(d1,  d1_);
Tester(dc,  dc_);

% Process:

pc  = struct;
pc  = Append_process(pc, @Example1_proc);
pc  = Append_process(pc, @Example2_proc);
pc_.f1 = 10;
pc_.f2 = 20;
pc_.f3 = 30;
pc_.g1 = 2;
pc_.g2 = 4;
pc_.g3 = 8;
pc_.processes = {@Example1_proc; @Example2_proc};
Tester(pc,  pc_);

ic = Process(pc, x1);				% Indirect
Tester(ic, dc_);

cc = Process_chain(pc, x1);			% Indirect.
cc_ = {d1_; dc_};					% Cell array of signals in chain.

Tester(cc, cc_);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Append a 3rd process without any parameters:

pc  = Append_process(pc, @Abs_proc);
pc_.processes = {@Example1_proc; @Example2_proc; @Abs_proc};
Tester(pc, pc_);

ha = Process(pc,  5);				% Indirect
hb = Process(pc, -5);				% Indirect
Tester(ha,  ((30 * 5) + 8));
Tester(hb, -((30 *-5) + 8));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Automatic parameter recalculation:
% Change "clinical" parameters:
pc.f1 = 11;
pc.g2 =  3;
% Verify that the derived parameters are recalculated:
[hc, pc] = Process(pc,  5);			% return new param struct too.
pc_.f1 = 11;
pc_.f2 = 20;
pc_.f3 = 31;	% recalculated
pc_.g1 = 2;
pc_.g2 = 3;
pc_.g3 = 6;		% recalculated
pc_.processes = {@Example1_proc; @Example2_proc; @Abs_proc};

Tester(pc, pc_);
Tester(hc, ((31 * 5) + 6));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

result = Tester;	% Report result.

