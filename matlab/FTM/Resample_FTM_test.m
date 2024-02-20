function result = Resample_FTM_test

% Resample_FTM_test: Test of Resample_FTM_proc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

verbose = Tester(mfilename);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x = 10:10:80;
m = [x; x+1];
if verbose > 2
	disp(m)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Equal numbers of input & output samples (no operation):

p = Resample_FTM_proc;
Tester(p.analysis_rate_Hz, 1000);
Tester(p.channel_stim_rate_Hz, 1000);
v1 = Resample_FTM_proc(p, m);
Tester(v1, m);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Halve the sample rate:

ph = p;
ph.channel_stim_rate_Hz = 500;
vh = Resample_FTM_proc(ph, m);

x = 10:20:80;
vh_ = [x; x+1];
Tester(vh, vh_);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Double the sample rate:

p2 = p;
p2.channel_stim_rate_Hz = 2 * p2.analysis_rate_Hz;
v2 = Resample_FTM_proc(p2, m);

x = [10 10 20 20 30 30 40 40 50 50 60 60 70 70 80 80];
v2_ = [x; x+1];
Tester(v2, v2_);

p2l = p2;
p2l.resample_method = 'linear';
v2l = Resample_FTM_proc(p2l, m);
x = [10 15 20 25 30 35 40 45 50 55 60 65 70 75 80];
v2l_ = [x; x+1];
Tester(v2l, v2l_);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Non-integral multiple:

p3 = p;
p3.channel_stim_rate_Hz = (3/2) * p3.analysis_rate_Hz;
v3 = Resample_FTM_proc(p3, m);

x = [10 10 20 30 30 40 50 50 60 70 70 80];
v3_ = [x; x+1];
Tester(v3, v3_);

p3l = p3;
p3l.resample_method = 'linear';
v3l = Resample_FTM_proc(p3l, m);

x = [10, 10+20/3, 20+10/3, 30, 30+20/3, 40+10/3, 50, 50+20/3, 60+10/3, 70, 70+20/3];
v3l_ = [x; x+1];
Tester(v3l,  v3l_,  1e-10);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

result = Tester;	% Report result

