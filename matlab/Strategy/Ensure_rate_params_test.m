function result = Ensure_rate_params_test

% Ensure_rate_params_test: Test Ensure_rate_params. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Tester(mfilename);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Quantisation of analysis rate & channel stim rate:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Choose the audio sample rate_Hz for ease of testing:
p = struct;
p.audio_sample_rate_Hz = 16000;

% There are four cases:

%% Specify neither rate:
%	- both are set equal to a default (quantised) value.

p0 = Ensure_rate_params(p);
Tester(p0.tick_us, 0.2);
Tester(p0.analysis_rate_Hz,		 1000);
Tester(p0.channel_stim_rate_Hz,	 1000);
Tester(p0.epoch_us, 1000);
Tester(p0.epoch_tk, 5000);

%% Specify analysis_rate_Hz only:
%	- analysis_rate_Hz is quantised to next available higher rate.
%	- channel_stim_rate_Hz is set equal to quantised analysis_rate_Hz.

p1 = p;
p1.analysis_rate_Hz = 495;
p1 = Ensure_rate_params(p1);
Tester(p1.analysis_rate_Hz,		  500);
Tester(p1.channel_stim_rate_Hz,   500);
Tester(p1.epoch_us,  2000);
Tester(p1.epoch_tk, 10000);

%% Specify channel_stim_rate_Hz only:
%	- channel_stim_rate_Hz is quantised (to ticks).
%   - analysis_rate_Hz is quantised to next available higher rate.

p2 = p;
p2.channel_stim_rate_Hz	=		  499.99;
p2 = Ensure_rate_params(p2);
Tester(p2.analysis_rate_Hz,		  500);
Tester(p2.channel_stim_rate_Hz,	  500);
Tester(p2.epoch_us,  2000);
Tester(p2.epoch_tk, 10000);

p3 = p;
p3.channel_stim_rate_Hz	= 1e6/2001; % just under 500 Hz.
p3 = Ensure_rate_params(p3);
Tester(p3.analysis_rate_Hz,		  500);
Tester(p3.channel_stim_rate_Hz,	  1e6/2001);
Tester(p3.epoch_us,  2001);
Tester(p3.epoch_tk, 10005);

%% Specify both analysis_rate_Hz & channel_stim_rate_Hz:
%	- channel_stim_rate_Hz is quantised (to ticks).
%   - analysis_rate_Hz is quantised to ADC rate.

p4 = p;
p4.analysis_rate_Hz		=		   995;
p4.channel_stim_rate_Hz	=		  2000.001;
p4 = Ensure_rate_params(p4);
Tester(p4.analysis_rate_Hz,		 1000);
Tester(p4.channel_stim_rate_Hz,	 2000);

p5 = p;
p5.analysis_rate_Hz		= p5.audio_sample_rate_Hz;
p5.channel_stim_rate_Hz	=		  1800;
p5 = Ensure_rate_params(p5);
Tester(p5.analysis_rate_Hz,	    16000);
Tester(p5.channel_stim_rate_Hz,	 1800, 1);

%% N8 defaults:
p8 = Ensure_rate_params;
Tester(p8.audio_sample_rate_Hz,	15625);
Tester(p8.block_shift,			16);
Tester(p8.analysis_rate_Hz,		976.5625);
Tester(p8.channel_stim_rate_Hz,	976.5625);
Tester(p8.epoch_us,	1024);
Tester(p8.epoch_tk,	5120);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

result = Tester;
