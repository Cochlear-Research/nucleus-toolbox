function Plot_sequence_spectrogram(p, qe, title, file_format, times_sec)

% Plot_sequence_spectrogram: Plot a sequence spectrogram
%
% Plot_sequence_spectrogram(p, qe, title, file_format, times_sec)
%
% p:           Parameter struct, fields: (threshold_levels, comfort_levels, channel_stim_rate_Hz)
% qe:          Sequence, fields: (electrodes, current_levels, periods_us).
% title:       Optional title of window and file name
% file_format: Optional format to save file (no file if empty)
% times_sec:   Optional start and end time, in seconds (length 2 vector).
%              Defaults to entire sequence.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 3
    title = 'Electrodogram';
end   

if nargin >= 5
    times_us = times_sec * 1e6;
    pulse_times = Get_pulse_times(qe);
    start_index = find(pulse_times >= times_us(1), 1, 'first');
    end_index   = find(pulse_times <= times_us(2), 1, 'last');
    qe = Subsequence(qe, start_index:end_index);
end

qc = Channel_mapping_inv_proc(p, qe);
% Append zero-magnitude pulses to ensure all channels are visible, 
% even if not stimulated:
idle.channels = [1; 22];
idle.magnitudes = 0;
idle.periods_us = min(qc.periods_us);
qc = Concatenate_sequences(qc, idle);

v = Uncollate_sequence(qc, 1e6 / p.channel_stim_rate_Hz);
v = flipud(v);
p.sample_rate_Hz = p.channel_stim_rate_Hz;
GUI_FTM(p, v, title);
colormap(hot);

if nargin >= 4 && ~isempty(file_format)
    print(title, file_format);
end