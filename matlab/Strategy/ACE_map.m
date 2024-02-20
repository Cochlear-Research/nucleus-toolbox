function p = ACE_map(p)

% Calculate ACE map parameters.
%
% p = ACE_map(p)
%
% Args:
%     p: A struct containing the clinical parameters.
%
% Returns:
%     p: A struct containing the clinical and derived parameters.
%     Any fields omitted from the input struct will be set to default values.
%
% To perform processing, use::
%
%   q = Process(p, audio)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin == 0
	p = struct;
end

p = Ensure_field(p, 'map_name', 'ACE');
p = Ensure_amplitude_params(p);
p = Ensure_rate_params(p);

p = Append_process(p, @Audio_proc);
p = Append_process(p, @Freedom_microphone_proc);
p = Append_process(p, @FE_AGC_proc);

p = Ensure_field(p, 'envelope_method', 'vector sum');
switch p.envelope_method
case 'power sum'
	p = Append_process(p, @FFT_PS_filterbank_proc);
case 'vector sum'
	p = Append_process(p, @FFT_VS_filterbank_proc);
	p = Append_process(p, @Abs_proc);
otherwise
	error('envelope_method must be either "power sum" or "vector sum"');
end

p = Append_process(p, @Gain_proc);

if (p.channel_stim_rate_Hz ~= p.analysis_rate_Hz)
	p = Append_process(p, @Resample_FTM_proc);
end

p = Append_process(p, @Reject_smallest_proc);
p = Append_process(p, @LGF_proc);
p = Append_process(p, @Collate_into_sequence_proc);
p = Append_process(p, @Channel_mapping_proc);
