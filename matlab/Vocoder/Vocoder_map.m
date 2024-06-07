function p = Vocoder_map(p)

% Vocoder_map: Calculate Vocoder map parameters.
% To perform processing, use:
%   audio_out = Process(p, audio_in)
% It only performs the minimal operations needed for an audio input;
% it does not create a pulse sequence as an intermediate step.
%
% p_out = Vocoder_map(p_in)
%
% p_in:  A struct containing the clinical parameters.
%          Any fields omitted will be set to default values.
% p_out: A struct containing the clinical and derived parameters.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin == 0
	p = struct;
end

p = Ensure_field(p, 'map_name', 'Vocoder');
p = Ensure_field(p, 'audio_sample_rate_Hz', 16000);
p = Ensure_field(p, 'analysis_rate_Hz', 500);
p = Ensure_field(p, 'resample_method', 'linear');

p.calibration_gain_dB = 0;                          % No need for calibration gain in Audio_proc.

p = Append_process(p, @Audio_proc);
p = Append_process(p, @FFT_VS_filterbank_proc);
p = Append_process(p, @Abs_proc);
p = Append_process(p, @Resynth_audio_proc);
