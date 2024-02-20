% Resample_FTM_demo: Shows effect of analysis rate_Hz lower than stim rate_Hz on ACE filterbank

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

audio = 'asa.wav';

p = struct;
p.num_bands = 22;
p.audio_sample_rate_Hz = 16000;
p.channel_stim_rate_Hz = p.audio_sample_rate_Hz / 8;
p.analysis_rate_Hz = p.channel_stim_rate_Hz;

p = Append_process(p, @Audio_proc);
p = Append_process(p, @Freedom_microphone_proc);
p = Append_process(p, @FFT_VS_filterbank_proc);
p = Append_process(p, @Abs_proc);
p = Append_process(p, @Resample_FTM_proc);
p = Append_process(p, @LGF_proc);

resample_factors = 1:4;
N = length(resample_factors);
vv = cell(N, 1);
dd = cell(N, 1);
for n = 1:length(resample_factors)
    p.analysis_rate_Hz = p.channel_stim_rate_Hz / n;
    vv{n} = Process(p, audio);
    dd{n} = sprintf('Interpolate by %d', n);
end

GUI_FTM(p, vv, dd);