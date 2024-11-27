% Quadrature_envelope_demo: Plot example FFT filterbank outputs,
% showing how the quadrature envelope can be sampled at a lower rate
% than the real and imaginary filter outputs.
%
% The original version of this file produced Fig. 9 in the paper:
% Swanson, B, Van Baelen, E, Janssens, M, Goorevich, M, Nygard, T and Van Herck, K (2007).
% Cochlear implant signal processing ICs. 
% IEEE Custom Integrated Circuits Conference, 2007.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright: Cochlear Ltd
%   Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	

p = struct;
p.audio_sample_rate_Hz = 16000;
p.analysis_rate_Hz = p.audio_sample_rate_Hz;
p.calibration_gain_dB = 0;
p = Append_process(p, 'Audio_proc');
p = Append_process(p, 'FFT_VS_filterbank_proc');

v = Process(p, 'asa.wav');
u = v(4, :);

%%
figure
hold on

N = size(v, 2);
t = 1000*(1:N)/p.analysis_rate_Hz;
line_width = 2;
plot(t, real(u), 'r:', 'LineWidth', line_width);
plot(t, imag(u), 'g:', 'LineWidth', line_width);
plot(t, abs(u),  'k:', 'LineWidth', line_width);

ts = t(1:16:end);
us = u(1:16:end);
plot(ts, real(us), 'ro', 'MarkerFaceColor', 'r');
plot(ts, imag(us), 'go', 'MarkerFaceColor', 'g');
plot(ts, abs(us),  'ko', 'MarkerFaceColor', 'k');

% Find an interesting section:
t1 = 544;
t2 = 560;
set(gca, 'XLim', [t1, t2]);
xlabel('Time (ms)');
ylabel('Amplitude');

