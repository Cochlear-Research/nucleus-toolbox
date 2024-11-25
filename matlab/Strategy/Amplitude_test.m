function result = Amplitude_test

% Amplitude_test: Test amplitude calibration of ACE_map, CIS_map, Ensure_amplitude_params.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

verbose = Tester(mfilename);

duration = 0.050;
tol = 1e-3;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
description = 'Reference tone, amplitude equal to AGC kneepoint.';

p0 = Create_map(73);
[x0, t] = Gen_tone(p0.calibration_freq_Hz, duration, p0.audio_sample_rate_Hz);
num_samples = length(x0);
middle = round(num_samples/2);

c0 = Process_chain(p0, x0);
plot_agc(verbose, p0, t, c0(2:end), description);

% Audio should be scaled so that peak reaches kneepoint:
Tester(max(abs(c0{1})), p0.agc_kneepoint, tol);
% Microphone freq response should be 0 dB at this freq:
y = c0{2}(middle:end);
Tester(max(abs(y)), p0.agc_kneepoint, tol);
% AGC should not be active:
y = c0{3}(middle:end);
Tester(max(abs(y)), p0.agc_kneepoint, tol);

% Envelope:
env = c0{5};
num_channels = size(env, 1);
Tester(num_channels == p0.num_bands);
% Stable envelope at end:
env_end = env(:, end);
% Find spectral peak:
[max_env, chan] = max(env_end);
Tester(chan == 7);
Tester(p0.best_freqs_Hz(7) == p0.calibration_freq_Hz);
% Filterbank has unity gain: envelope amplitude is peak value of tone:
Tester(max_env, p0.agc_kneepoint, tol);
% Adjacent channels should be half the amplitude:
Tester(env_end(6), p0.agc_kneepoint/2, tol);
Tester(env_end(8), p0.agc_kneepoint/2, tol);

% LGF:
kp = Find_process(p0, @LGF_proc);
mag = c0{kp};
mag_end = mag(:, end);
% Pure tone at AGC kneepoint will saturate LGF,
% on both centre channel and adjacent channels:
Tester(mag_end(6:8) == 1);

% Channel-magnitude sequence:
kp = Find_process(p0, @Collate_into_sequence_proc);
q = c0{kp};
q = Subsequence(q, -p0.num_selected); % last scan.
% Check that magnitude is 1 on centre channel and adjacent channels:
for c = 6:8
    b = q.channels == c;
    Tester(q.magnitudes(b), 1);
end

% Electrode current-level sequence:
q = c0{end};
q = Subsequence(q, -p0.num_selected); % last scan.
% Check that current is at C-level on centre channel and adjacent channels:
for c = 6:8
    b = q.electrodes == (23 - c);
    Tester(q.current_levels(b), 100);
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
description = 'Reference tone, amplitude 3 dB above AGC kneepoint.';

p1 = Create_map(76);
[x1, t] = Gen_tone(p1.calibration_freq_Hz, duration, p1.audio_sample_rate_Hz);
c1 = Process_chain(p1, x1);
plot_agc(verbose, p1, t, c1(2:end), description);

% Audio should be scaled so that peak exceeds kneepoint:
Tester(max(abs(c1{1})), p1.agc_kneepoint * From_dB(3), tol);
% Microphone freq response should be 0 dB at this freq:
y = c1{2}(middle:end);
Tester(max(abs(y)), p1.agc_kneepoint * From_dB(3), tol);
% AGC should be active:
y = c1{3}(middle:end);
Tester(max(abs(y)), p1.agc_kneepoint, tol);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
description = 'Reference tone to just reach C-level.';

p2 = Create_map(59);
[x2, t] = Gen_tone(p2.calibration_freq_Hz, duration, p2.audio_sample_rate_Hz);
c2 = Process_chain(p2, x2);
plot_agc(verbose, p2, t, c2(2:end), description);

% Audio should be scaled to be well below kneepoint:
Tester(max(abs(c2{1})), p2.agc_kneepoint * From_dB(-14), tol);
% Microphone freq response should be 0 dB at this freq:
agc_in = c2{2}(middle:end);
agc_in_peak = max(abs(agc_in));
Tester(agc_in_peak, p2.agc_kneepoint * From_dB(-14), tol);
% AGC should be inactive:
agc_out = c2{3}(middle:end);
Tester(max(abs(agc_in - agc_out)) < 1e-5);

% Envelope:
k_env = Find_process(p2, @Gain_proc) - 1;
env = c2{k_env};
num_channels = size(env, 1);
Tester(num_channels == 22);
% Stable envelope at end:
env_end = env(:, end);
% Find spectral peak:
[max_env, chan] = max(env_end);
Tester(chan == 7);
% Filterbank has unity gain: envelope amplitude is peak value of tone:
Tester(max_env, agc_in_peak, tol);
% Adjacent channels should be half the amplitude:
Tester(env_end(6), agc_in_peak/2, tol);
Tester(env_end(8), agc_in_peak/2, tol);

% LGF:
kp = Find_process(p2, @LGF_proc);
mag = c2{kp};
mag_end = mag(:, end);
% Should just reach saturation level:
Tester(mag_end(7) == 1);
% Adjacent channels will be lower:
Tester(mag_end(6), mag_end(8), tol);
Tester(mag_end(6) < 1.0);
% Q = 20 means an input 10 dB below sat_level gives mag = 0.8; 
% adjacent channels were 6 dB below sat_level, so mag > 0.8.
Tester(mag_end(6) > 0.8); 

% Channel-magnitude sequence:
kp = Find_process(p2, @Collate_into_sequence_proc);
q = c2{kp};
q = Subsequence(q, -p2.num_selected); % last scan.
% Check that magnitude is 1 on centre channel:
b = q.channels == 7;
Tester(q.magnitudes(b), 1);

% Electrode current-level sequence:
q = c2{end};
q = Subsequence(q, -p2.num_selected); % last scan.
% Check that current is at C-level on centre channel:
b = q.electrodes == (23 - 7);
Tester(q.current_levels(b), 100);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
description = 'Pulse train with 12 dB crest factor.';
% For this test, the microphone frequence response is undesirable,
% so it is removed.

p3 = Create_map(p2.C_dB_SPL);

% Remove Freedom_microphone_proc from processing chain:
k = Find_process(p3, @Freedom_microphone_proc);
p3.processes(k) = [];

% Pulse train. Crest factor = sqrt(N) = sqrt(16) = 4 => 12 dB
N = 16;
u = [1; repmat(-1/N, N, 1)];
period_us = (N + 1) / p3.audio_sample_rate_Hz;
num_periods = round(duration / period_us);
u = repmat(u, num_periods, 1);
Tester(mean(u), 0); % No DC component.
t = (0:(length(u) - 1)) / p3.audio_sample_rate_Hz;
Tester(Crest_factor_dB(u), To_dB(4), 0.001);

cu = Process_chain(p3, u);
plot_agc(verbose, p3, t, cu, description);

% Audio should be scaled so that level is C_dB_SPL:
audio = cu{1};
level_dB_SPL = Calibrate_dB_SPL(p3, audio);
Tester(level_dB_SPL, p3.C_dB_SPL, tol);
% Peaks should be about 1 dB above AGC kneepoint:
Tester(max(abs(audio)), p3.agc_kneepoint * From_dB(1), 0.1);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
description = 'Harmonic tone with high crest factor.';
% The number of harmonics was chosen to give a crest factor of about 8 dB,
% (less than speech).
% For this test case, the microphone frequence response is undesirable,
% so it is removed (as per previous test case).

[x3, t] = Gen_tone(p3.calibration_freq_Hz, duration, p3.audio_sample_rate_Hz);
for n = 2:5
    x3 = x3 + Gen_tone(n * p3.calibration_freq_Hz, duration, p3.audio_sample_rate_Hz);
end
Tester(Crest_factor_dB(x3), 8, 0.1);

c3 = Process_chain(p3, x3);
plot_agc(verbose, p3, t, c3, description);

% Audio should be scaled so that level is C_dB_SPL:
audio = c3{1};
level_dB_SPL = Calibrate_dB_SPL(p3, audio);
Tester(level_dB_SPL, p3.C_dB_SPL, tol);
% Peak level should be about 3 dB below AGC kneepoint:
Tester(max(abs(audio)), p3.agc_kneepoint * From_dB(-3), 0.1);

% AGC should be inactive:
agc_out = c3{2};
Tester(max(abs(audio - agc_out)) < 1e-5);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
description = 'Speech';
% Speech at 65 dB should occasionally activate AGC.

p4 = Create_map(65);
x4 = 'L001s04r.wav';
c4 = Process_chain_nargout(p4, x4); % get all intermediate outputs

% AGC should not be very active:
agc_in       = c4{2}{1};
agc_out_cell = c4{3};
agc_out  = agc_out_cell{1};
agc_gain = agc_out_cell{2};
agc_env  = agc_out_cell{3};
agc_gain_dB = To_dB(agc_gain);
% Check that gain is never reduced by more than 3 dB:
Tester(min(agc_gain_dB) > -3.0);
% Check that gain is reduced less than 5% of the time:
agc_active = agc_gain_dB < -0.1;
agc_duty_cycle = sum(agc_active) / length(agc_active);
Tester(agc_duty_cycle < 0.05);

if verbose > 2
    Plot_AGC_signals(p4, {agc_in, agc_env, agc_out}, {agc_gain}, {'Env', 'Gain'});
    Window_title(description);

    Plot_sequence(c4{end-1}{1});
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

result = Tester;	% Report result

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Local functions

function p = Create_map(audio_dB_SPL)

    p = struct;
    p.audio_sample_rate_Hz = 16000; % for convenience.
    p.audio_dB_SPL = audio_dB_SPL;
    p = ACE_map(p);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function plot_agc(verbose, p, t, c, description)
    if verbose > 2
        figure, hold on
        plot(t, c{1}, 'g')
        plot(t, c{2}, 'm')
        plot(t([1,end]),  p.agc_kneepoint * [1,1], 'r');
        plot(t([1,end]), -p.agc_kneepoint * [1,1], 'r');
        legend({'AGC input', 'AGC output', 'AGC kneepoint'}, 'Location', 'SouthWest')
        legend boxoff
        zoom xon
        Window_title(description);
    end
end