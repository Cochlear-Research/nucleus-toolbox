function Plot_AGC_signals(p, signals, gains, descriptions)
% Plot_AGC_signals: Plot AGC input and output signals, and gains.
%
% Plot_AGC_signals(p, signals, gains, descriptions)
%
% p:            Parameter struct.
% signals:      Cell array of signals. 
%               signals{1}:   AGC input signal
%               signals{end}: AGC output signal
%               Other elements can be intermediate signals (e.g. envelope).
% gains:        Cell array of gains.
% descriptions: Cell array of strings.
%               The first elements describe the intermediate signals,
%               the remaining elements describe the gains.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N = length(signals);
assert(N >= 2);
u = signals{1};     % input
v = signals{end};   % output
assert(length(descriptions) == length(gains) + N - 2);

t = (1:length(u))/p.audio_sample_rate_Hz;
t_ms = t * 1000;
y_scale = 1.2;

Get_axes(3, 1);

% Output signal:
pa = Get_axes;
plot(t_ms, v);
set(gca, 'YLim', [-1, 1] * max(v) * y_scale);
xlabel('Time (ms)');
ylabel('Amplitude');
legend({'Output'}, 'Location', 'SouthWest')
legend boxoff

% Gain signals:
pa = Get_axes;
gain_colors = 'crb';
min_gain_dB = 0;
for n = 1:length(gains)
    gain_dB = To_dB(gains{n});
    min_gain_dB = min(min_gain_dB, min(gain_dB));
    plot(t_ms, gain_dB, gain_colors(n));
    hold on
end
ylabel('Gain (dB)')
num_gains = length(gains);
% The last descriptions are for the gains:
gain_descriptions = descriptions(end + 1 - num_gains : end);
legend(gain_descriptions, 'Location', 'SouthWest')
legend boxoff
set(gca, 'YLim', [min_gain_dB - 1, 1]);
set(gca, 'XTick', []);

% Input signal & envelope(s):
pa = Get_axes;
sig_colors = 'bcgm';
num_signals = N-1; % Don't plot output here.
for n = 1:num_signals
    plot(t_ms, signals{n}, sig_colors(n));
    hold on
end
sig_descriptions = [{'Input'}, descriptions(1:(N-2))];
if isfield(p, 'agc_kneepoint')
    plot(t_ms([1,end]), p.agc_kneepoint * [1,1], 'r');
    sig_descriptions{end+1} = 'AGC kneepoint';
end
if isfield(p, 'asc_breakpoint')
    plot(t_ms([1,end]), p.asc_breakpoint * [1,1], 'm');
    sig_descriptions{end+1} = 'ASC breakpoint';
end
ylabel('Amplitude');
legend(sig_descriptions, 'Location', 'SouthWest')
legend boxoff
set(gca, 'YLim', [-1, 1] * max(u) * y_scale);
set(gca, 'XTick', []);

set(pa.axes_vec, 'XLim', t_ms([1,end]));
