function result = Reject_fixed_channels_test

% Reject_fixed_channels_test: Test of Reject_fixed_channels_proc.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

verbose = Tester(mfilename);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Input FTM:
u = [
    16     2     3    13    17     6    10     5
     5    11    10     8     3    12     8    15
     9     7     6    12     4    11     7    16
     4    14    15     1    14     9    13     2
];
if verbose, u, end

% Reject 1 channel:

r1_ = [
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
     5    11    10     8     3    12     8    15
     9     7     6    12     4    11     7    16
     4    14    15     1    14     9    13     2
];
p.num_bands = 4;
p.rejected_channels = 1;
p = Reject_fixed_channels_proc(p);
r1 = Reject_fixed_channels_proc(p, u);
if verbose, r1, end
Tester(r1, r1_);

% Reject 2 channels:

r2_ = [
    16     2     3    13    17     6    10     5
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
     9     7     6    12     4    11     7    16
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
];
p.num_bands = 4;
p.rejected_channels = [2,4];
p = Reject_fixed_channels_proc(p);
r2 = Reject_fixed_channels_proc(p, u);
if verbose, r2, end
Tester(r2, r2_);

% Reject 3 channels:

r3_ = [
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
     9     7     6    12     4    11     7    16
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
];
p.num_bands = 4;
p.rejected_channels = [1,2,4];
p = Reject_fixed_channels_proc(p);
r3 = Reject_fixed_channels_proc(p, u);
if verbose, r3, end
Tester(r3, r3_);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

result = Tester;	% Report result
