function u = Gen_AGC_test_signal(p, amplitudes_dB, durations)
% Gen_AGC_test_signal: generate a test signal for a front-end AGC.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Amplitudes are relative to AGC kneepoint:
a = From_dB(amplitudes_dB) * p.agc_kneepoint;

% Envelope:
v = Gen_step_signal(p.audio_sample_rate_Hz, a, durations);

% Tone:
freq = 1000;
x = Gen_tone(freq, sum(durations), p.audio_sample_rate_Hz);

% Amplitude-modulated tone:
u = v .* x;

