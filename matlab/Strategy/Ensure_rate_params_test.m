function result = Ensure_rate_params_test

% Ensure_rate_params_test: Test Ensure_rate_params. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Tester(mfilename);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Quantisation of analysis rate_Hz & channel stim rate_Hz:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Choose the audio sample rate_Hz for ease of testing:
p = struct;
p.audio_sample_rate_Hz = 16000;

% There are four cases:

% Specify neither rate_Hz:
%	both are set equal to a default (quantised) value.

p0 = Ensure_rate_params(p);
Tester(p0.analysis_rate_Hz,		 1000);
Tester(p0.channel_stim_rate_Hz,	 1000);
Tester(p0.implant_stim_rate_Hz, 12000);

% Specify channel_stim_rate_Hz only (most common):
%	analysis_rate_Hz is set equal to channel_stim_rate_Hz,
%	then both are quantised.

p1 = p;
p1.channel_stim_rate_Hz	=		  1005;
p1.num_selected			=		    12;
p1 = Ensure_rate_params(p1);
Tester(p1.analysis_rate_Hz,		 1000);
Tester(p1.channel_stim_rate_Hz,	 1000);
Tester(p1.implant_stim_rate_Hz, 12000);

% Specify analysis_rate_Hz only:
%	analysis_rate_Hz is quantised.
%	channel_stim_rate_Hz is set equal to quantised analysis_rate_Hz.

p2 = p;
p2.analysis_rate_Hz		=		  1005;
p2.num_selected			=		    12;
p2 = Ensure_rate_params(p2);
Tester(p2.analysis_rate_Hz,		 1000);
Tester(p2.channel_stim_rate_Hz,  1000);
Tester(p2.implant_stim_rate_Hz, 12000);

% Specify both analysis_rate_Hz & channel_stim_rate_Hz:
%	analysis_rate_Hz is quantised.
%	channel_stim_rate_Hz is not changed.
%	This will (usually) require Resample_FTM_proc.

p3 = p;
p3.analysis_rate_Hz		=		  1005;
p3.channel_stim_rate_Hz	=		  2400;
p3.num_selected			=		     6;
p3 = Ensure_rate_params(p3);
Tester(p3.analysis_rate_Hz,		 1000);
Tester(p3.channel_stim_rate_Hz,	 2400);
Tester(p3.implant_stim_rate_Hz, 14400);

p4 = p;
p4.analysis_rate_Hz		= p4.audio_sample_rate_Hz;
p4.channel_stim_rate_Hz	=		  1800;
p4.num_selected			=		     8;
p4 = Ensure_rate_params(p4);
Tester(p4.analysis_rate_Hz,	    16000);
Tester(p4.channel_stim_rate_Hz,	 1800);
Tester(p4.implant_stim_rate_Hz, 14400);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

result = Tester;
