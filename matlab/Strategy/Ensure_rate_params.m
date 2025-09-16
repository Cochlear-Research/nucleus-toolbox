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
%   epoch_us:			The duration of an epoch, in microseconds.
%   epoch_tk:			The duration of an epoch, in ticks.
%
% Sound processing analysis occurs after an integer number of audio samples.
% i.e. the analysis_rate_Hz is quantised to a sub-multiple of the audio_sample_rate_Hz.
% Stimulation timing, including channel_stim_rate_Hz, is quantised by tick_us.
% An epoch is defined as the reciprocal of the channel_stim_rate_Hz.
% 
% If the analysis_rate_Hz is specified, but not channel_stim_rate_Hz,
% then the channel_stim_rate_Hz is set equal to the quantised analysis_rate_Hz.
% If the channel_stim_rate_Hz is specified, but not analysis_rate_Hz,
% then the analysis_rate_Hz is set to the next available rate higher than channel_stim_rate_Hz.
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

if ~isfield(p, 'channel_stim_rate_Hz')
	p = Ensure_field(p, 'analysis_rate_Hz', 975);
	p = Quantise_analysis_rate(p);
	p.channel_stim_rate_Hz = p.analysis_rate_Hz;
	p = Quantise_channel_stim_rate(p);
else
	p = Quantise_channel_stim_rate(p);
	p = Ensure_field(p, 'analysis_rate_Hz', p.channel_stim_rate_Hz);
	p = Quantise_analysis_rate(p);
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function p = Quantise_analysis_rate(p)

p.block_shift = floor(p.audio_sample_rate_Hz / p.analysis_rate_Hz);
p.analysis_rate_Hz = p.audio_sample_rate_Hz / p.block_shift;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function p = Quantise_channel_stim_rate(p)

% Epoch duration is inverse of channel stimulation rate,
% quantised to an integer number of ticks:
[p.epoch_us, p.epoch_tk] = Quantise_us(p, 1e6 / p.channel_stim_rate_Hz);
p.channel_stim_rate_Hz = 1e6 / p.epoch_us;

end

