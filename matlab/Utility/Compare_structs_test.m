function result = Compare_structs_test

% Compare_structs_test: Test of Compare_structs.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

verbose = Tester(mfilename);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reference struct:

p.fa = 1;
p.fb = 2;
p.fc = 3;
p.fd = 4;

[z,m] = Compare_structs(p, p, verbose);
Tester(z, 1);
Tester(m, {});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Same as p, but fields declared in different order:

q.fb = 2;
q.fa = 1;
q.fc = 3;
q.fd = 4;

[z,m] = Compare_structs(p, q, verbose);
Tester(z, 1);
Tester(m, {});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% p with additional fields:

r = p;
r.fe = 5;
r.ff = 6;

[z,m] = Compare_structs(p, r, verbose);
Tester(z, 0);
Tester(m, {'Struct1 omits fe','Struct1 omits ff'});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Same as p with fields missing:

s.fb = 2;
s.fc = 3;

[z,m] = Compare_structs(p, s, verbose);
Tester(z, 0);
Tester(m, {'Struct2 omits fa','Struct2 omits fd'});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

result = Tester;		% Report result.
