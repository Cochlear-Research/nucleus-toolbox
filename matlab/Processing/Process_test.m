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

q1  = [];
q1  = Append_process(q1, @Example1_proc);
q1_ = p1_;
q1_.processes = {@Example1_proc};
Tester(q1,  q1_);

i1 = Process(q1, x1);				% Indirect
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

q2  = Append_process([], @Example2_proc);
q2_ = p2_;
q2_.processes = {@Example2_proc};
Tester(q2,  q2_);

i2 = Process(q2, x1);				% Indirect
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

qc  = [];
qc  = Append_process(qc, @Example1_proc);
qc  = Append_process(qc, @Example2_proc);
qc_.f1 = 10;
qc_.f2 = 20;
qc_.f3 = 30;
qc_.g1 = 2;
qc_.g2 = 4;
qc_.g3 = 8;
qc_.processes = {@Example1_proc; @Example2_proc};
Tester(qc,  qc_);

ic = Process(qc, x1);				% Indirect
Tester(ic, dc_);

cc = Process_chain(qc, x1);			% Indirect.
cc_ = {d1_; dc_};					% Cell array of signals in chain.

Tester(cc, cc_);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Append a 3rd process without any parameters:

qc  = Append_process(qc, @Abs_proc);
qc_.processes = {@Example1_proc; @Example2_proc; @Abs_proc};
Tester(qc, qc_);

ha = Process(qc,  5);				% Indirect
hb = Process(qc, -5);				% Indirect
Tester(ha,  ((30 * 5) + 8));
Tester(hb, -((30 *-5) + 8));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Automatic parameter recalculation:
% Change "clinical" parameters:
qc.f1 = 11;
qc.g2 =  3;
% Verify that the derived parameters are recalculated:
[hc, qc] = Process(qc,  5);			% return new param struct too.
qc_.f1 = 11;
qc_.f2 = 20;
qc_.f3 = 31;	% recalculated
qc_.g1 = 2;
qc_.g2 = 3;
qc_.g3 = 6;		% recalculated
qc_.processes = {@Example1_proc; @Example2_proc; @Abs_proc};

Tester(qc, qc_);
Tester(hc, ((31 * 5) + 6));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

result = Tester;	% Report result.

