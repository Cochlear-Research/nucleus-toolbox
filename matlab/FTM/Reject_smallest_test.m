function result = Reject_smallest_test(p)

% Reject_smallest_test: Test of Reject_smallest_proc.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

verbose = Tester(mfilename);

if nargin == 0
	p = Append_process(struct, @Reject_smallest_proc);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Input is a non-square matrix:
m = magic(4);
u = [ m, (m+1)', [5; 5; 6; 6] ];
[p.num_bands, num_times] = size(u);

if verbose, u, end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p.num_selected = 1;
v1  = Process(p, u);
v1_ = [
    16   NaN   NaN    13    17   NaN   NaN   NaN   NaN
   NaN   NaN   NaN   NaN   NaN    12   NaN   NaN   NaN
   NaN   NaN   NaN   NaN   NaN   NaN   NaN    16   NaN
   NaN    14    15   NaN   NaN   NaN    13   NaN     6
];
Tester(v1, v1_);
if verbose, v1, end

p.num_selected = 2;
v2  = Process(p, u);
v2_ = [
    16   NaN   NaN    13    17   NaN    10   NaN   NaN
   NaN    11    10   NaN   NaN    12   NaN    15   NaN
     9   NaN   NaN    12   NaN    11   NaN    16     6
   NaN    14    15   NaN    14   NaN    13   NaN     6
];
Tester(v2, v2_);
if verbose, v2, end

p.num_selected = 3;
v3  = Process(p, u);
v3_ = [
    16   NaN   NaN    13    17   NaN    10     5   NaN
     5    11    10     8   NaN    12     8    15     5
     9     7     6    12     4    11   NaN    16     6
   NaN    14    15   NaN    14     9    13   NaN     6
];
Tester(v3, v3_);
if verbose, v3, end

% The SP5 implementation does not need to handle the
% CIS case (where all bands are selected),
% because this routine won't be included in the image.
try
	p.num_selected = p.num_bands;	% Reject none
	v4 = Process(p, u);
	Tester(v4, u);	
	if verbose, v4, end
catch
	if verbose, disp('Reject none is not supported'), end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% These input signals are good for measuring execution times:
% Ramp up
% Ramp down
% Ramp up then down
% Unordered
% All values equal (shows that if there are ties, it rejects the lowest index)

u = [
	11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32;
	32,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11;
	11,12,13,14,15,16,17,18,19,20,21,21,20,19,18,17,16,15,14,13,12,11;
	66,22,55,33,11,44,22,77,99,66,11,22,33,11,44,55,11,99,88,22,55,66;
	 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3;
]';
p.num_bands    = 22;
x = NaN;

p.num_selected =  9;
v = Process(p, u);
v_ = [
	 x, x, x, x, x, x, x, x, x, x, x, x, x,24,25,26,27,28,29,30,31,32;
	32,31,30,29,28,27,26,25,24, x, x, x, x, x, x, x, x, x, x, x, x, x;
	 x, x, x, x, x, x, x,18,19,20,21,21,20,19,18,17, x, x, x, x, x, x;
	66, x, x, x, x, x, x,77,99,66, x, x, x, x, x,55, x,99,88, x,55,66;
	 x, x, x, x, x, x, x, x, x, x, x, x, x, 3, 3, 3, 3, 3, 3, 3, 3, 3;
]';
Tester(v, v_);
if verbose, v, end

p.num_selected = 10;
v = Process(p, u);
v_ = [
	 x, x, x, x, x, x, x, x, x, x, x, x,23,24,25,26,27,28,29,30,31,32;
	32,31,30,29,28,27,26,25,24,23, x, x, x, x, x, x, x, x, x, x, x, x;
	 x, x, x, x, x, x,17,18,19,20,21,21,20,19,18,17, x, x, x, x, x, x;
	66, x,55, x, x, x, x,77,99,66, x, x, x, x, x,55, x,99,88, x,55,66;
	 x, x, x, x, x, x, x, x, x, x, x, x, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3;
]';
Tester(v, v_);
if verbose, v, end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

result = Tester;	% Report result
