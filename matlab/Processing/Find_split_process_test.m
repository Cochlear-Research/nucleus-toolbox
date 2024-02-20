function result = Find_split_process_test

% Find_split_process_test: Test Find_process and Split_process.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright: Cochlear Ltd
%   Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

verbose = Tester(mfilename);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The processes field is a cell array of function handles:

p = struct;
p = Append_process(p, @Example1_proc);
p = Append_process(p, @Example2_proc);
p = Append_process(p, @Abs_proc);

% For backward compatibility, convert strings to function handles:
ps = struct;
ps = Append_process(ps, 'Example1_proc');
ps = Append_process(ps, 'Example2_proc');
ps = Append_process(ps, 'Abs_proc');

Tester(p, ps);
clear ps;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test Find_process:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Tester(Find_process(p, @Example1_proc), 1);
Tester(Find_process(p, @Example2_proc), 2);
Tester(Find_process(p, @Abs_proc),      3);

% For backward compatibility, accept string argument:
Tester(Find_process(p, 'Example1_proc'), 1);
Tester(Find_process(p, 'Example2_proc'), 2);
Tester(Find_process(p, 'Abs_proc'),      3);

try
    k = Find_process(p, @Gain_proc);    % Should cause an error and be caught.
    Tester(0);                          % Fail if we reach this statement.
catch ME
    Tester(ME.identifier, 'Nucleus:Processing');
end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test Split_process:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Remove processes from head:
[p_head0, p_tail0] = Split_process(p, 0);

p_head0_ = p;
p_head0_.processes = {};

Tester(p_head0, p_head0_);
Tester(p_tail0, p);

% Split after 1st process:
[p_head1, p_tail1] = Split_process(p, 1);

p_head1_ = p;
p_tail1_ = p;
p_head1_.processes = {@Example1_proc};
p_tail1_.processes = {@Example2_proc; @Abs_proc};

Tester(p_head1, p_head1_);
Tester(p_tail1, p_tail1_);

% Split after 2nd process:
[p_head2, p_tail2] = Split_process(p, 2);

p_head2_ = p;
p_tail2_ = p;
p_head2_.processes = {@Example1_proc; @Example2_proc};
p_tail2_.processes = {@Abs_proc};

Tester(p_head2, p_head2_);
Tester(p_tail2, p_tail2_);

% Split after 3rd process (remove processes from tail):
[p_head3, p_tail3] = Split_process(p, 3);

p_head3_ = p;
p_tail3_ = p;
p_tail3_.processes = {};

Tester(p_head3, p_head3_);
Tester(p_tail3, p_tail3_);

% Split before last process:
% (same as after 2nd process)
[p_head_m1, p_tail_m1] = Split_process(p, -1);

Tester(p_head_m1, p_head2_);
Tester(p_tail_m1, p_tail2_);

% Split before 2nd last process:
% (same as after 1st process)
[p_head_m2, p_tail_m2] = Split_process(p, -2);

Tester(p_head_m2, p_head1_);
Tester(p_tail_m2, p_tail1_);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Split process by function handle:

% Split after 1st process, by function handle:
[p_head1, p_tail1] = Split_process(p, @Example1_proc);
Tester(p_head1, p_head1_);
Tester(p_tail1, p_tail1_);

% Split after 2nd process, by function handle:
[p_head2, p_tail2] = Split_process(p, @Example2_proc);
Tester(p_head2, p_head2_);
Tester(p_tail2, p_tail2_);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Split process by name (for backward compatibility):

% Split after 1st process, by name:
[p_head1, p_tail1] = Split_process(p, 'Example1_proc');
Tester(p_head1, p_head1_);
Tester(p_tail1, p_tail1_);

% Split after 2nd process, by name:
[p_head2, p_tail2] = Split_process(p, 'Example2_proc');
Tester(p_head2, p_head2_);
Tester(p_tail2, p_tail2_);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

result = Tester;	% Report result.
