function p = Ensure_rate_params(p)

% Ensure_rate_params: Ensure rate parameters are valid.
%
% p_out = Ensure_rate_params(p_in)
%
% p_in:  A struct containing the clinical parameters.
%          Any fields omitted will be set to default values.
% p_out: A struct containing the clinical and derived parameters.
%
% Fundamental parameters:
%   audio_sample_rate_Hz:  The sample rate (in Hertz) for the audio input signal.
%   analysis_rate_Hz:      The number of input blocks analysed per second.
%   channel_stim_rate_Hz:  The peak number of pulses per second on a channel.
% Derived parameters:
%   block_shift:        The number of new samples in each block.
%
% The analysis_rate_Hz is quantised to a sub-multiple of the audio_sample_rate_Hz.
% The channel_stim_rate_Hz may also be quantised, as follows:
% If the analysis_rate_Hz is specified, but not channel_stim_rate_Hz,
% then the channel_stim_rate_Hz is set equal to the quantised analysis_rate_Hz.
% If the channel_stim_rate_Hz is specified, but not analysis_rate_Hz,
% then the analysis_rate_Hz is set equal to the quantised channel_stim_rate_Hz.
% If both the channel_stim_rate_Hz and analysis_rate_Hz are specified,
% then the channel_stim_rate_Hz is not adjusted, and Resample_FTM_proc will be required.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin == 0
	p = struct;
end

p = Ensure_implant_params(p);
p = Ensure_field(p, 'audio_sample_rate_Hz', p.RF_clock_Hz / 320);

if ~isfield(p, 'analysis_rate_Hz')
	p = Ensure_field(p, 'channel_stim_rate_Hz', 1000);
	p.analysis_rate_Hz = p.channel_stim_rate_Hz;
	p = Quantise_analysis_rate(p);
	p.channel_stim_rate_Hz = p.analysis_rate_Hz;
else
	p = Quantise_analysis_rate(p);
	p = Ensure_field(p, 'channel_stim_rate_Hz', p.analysis_rate_Hz);
end

p = Ensure_electrodes(p);
p = Ensure_field(p, 'num_selected',	min(p.num_bands, 12));

p.interval_length = round(p.analysis_rate_Hz / p.channel_stim_rate_Hz);
p.implant_stim_rate_Hz = p.channel_stim_rate_Hz * p.num_selected;

period_tk = round(p.RF_clock_Hz / p.implant_stim_rate_Hz);
p.period_us = 1e6 * period_tk / p.RF_clock_Hz;	% microseconds

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function p = Quantise_analysis_rate(p)

p.block_shift = ceil(p.audio_sample_rate_Hz / p.analysis_rate_Hz);
p.analysis_rate_Hz = p.audio_sample_rate_Hz / p.block_shift;
