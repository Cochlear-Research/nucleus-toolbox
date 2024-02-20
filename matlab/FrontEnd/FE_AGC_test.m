function result = FE_AGC_test

% FE_AGC_test: Test of FE_AGC_proc and Freedom_AGC_proc.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

verbose = Tester(mfilename);

% Test cases:
cases = {
    @FE_AGC_proc;
    @Freedom_AGC_proc;
    };

for n = 1:length(cases)
    
    p = Append_process(struct, cases{n});
    agc_name = func2str(p.processes{1});
    
    % Define input signal:
    pre_duration  = 0.010;
    step_duration = 0.020;
    post_duration = 0.100;

    margin_dB = 2; % Gain margin for attack time.
    attack_time_tolerance  = 0.1 * p.agc_attack_time_s;
    release_time_tolerance = 0.1 * p.agc_release_time_s;

    u = Gen_AGC_test_signal(p, [0, p.agc_step_dB, 0], [pre_duration, step_duration, post_duration]);

    % Process input signal
    [v, gain, env, aux_signals, descriptions] = Process_AGC(p, u); % local function
    gain_dB = To_dB(gain);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% AGC Attack Time

    % Attack time: time taken for output to reach 2 dB from final value,
    % after a 25 dB step up in input level.
    % Here, easiest to measure it on gain signal.
    % Input steps up, so gain should decrease.

    target_dB = -(p.agc_step_dB - margin_dB);
    target_index = find(gain_dB <= target_dB, 1);
    target_time = target_index / p.audio_sample_rate_Hz;
    attack_time = target_time - pre_duration;
    Tester(attack_time, p.agc_attack_time_s, attack_time_tolerance);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% AGC Release Time

    % Release time: time taken for output to recover to within 2 dB of final value,
    % after a 25 dB step down in input level.
    % Here, easiest to measure it on gain signal.
    % Input steps down, so gain should increase.

    target_dB = - margin_dB;
    target_indices = find(gain_dB <= target_dB);
    target_index = target_indices(end);
    target_time = target_index / p.audio_sample_rate_Hz;
    release_time = target_time - (pre_duration + step_duration);
    Tester(release_time, p.agc_release_time_s, release_time_tolerance);

    if verbose > 1
        fprintf('%s\n', agc_name);
        fprintf('Attack time:  %.3f (spec), %.3f (measured)\n', p.agc_attack_time_s, attack_time);
        fprintf('Release time: %.3f (spec), %.3f (measured)\n', p.agc_release_time_s, release_time);
        if verbose > 2
            Plot_AGC_signals(p, {u, env, v}, aux_signals, descriptions);
            Window_title('%s Attack & Release Time', agc_name);
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% AGC Kneepoint & Compression
    % AGC shouuld be inactive for signals below kneepoint,
    % then infinite compression above kneepoint.

    % Use slow ramp to be fairly independent of attack time:
    duration = 10; % seconds
    env_dB = linspace(-10, +10, duration * p.audio_sample_rate_Hz)';
    env_in = From_dB(env_dB) * p.agc_kneepoint;
    % Tone:
    freq = 1000;
    u = env_in .* Gen_tone(freq, duration, p.audio_sample_rate_Hz);

    [v, gain, env, aux_signals, descriptions] = Process_AGC(p, u);  % local function

    % Find the point at which the envelope first reaches the kneepoint:
    kneepoint_index = find(env >= p.agc_kneepoint, 1);
    % Gains prior to this should be unity, i.e. AGC is inactive:
    inactive_gains = gain(1:(kneepoint_index-1));
    Tester(max(inactive_gains), 1.0, 1e-6);
    Tester(min(inactive_gains), 1.0, 1e-6);
    % Output after this should be close to kneepoint, i.e. infinite compression:
    compressed_out = v(kneepoint_index:end);
    Tester(max(abs(compressed_out)), p.agc_kneepoint, 0.01);

    if verbose > 2
        Plot_AGC_signals(p, {u, env, v}, aux_signals, descriptions);
        Window_title('%s Kneepoint', agc_name);
    end
end
%%
result = Tester;	% Report result

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function gives the two AGCs a consistent interface:

function [v, gain, env, aux_signals, descriptions] = Process_AGC(p, u)

switch func2str(p.processes{1})
    
    case 'FE_AGC_proc'
        [v, gain, env, raw_gain] = FE_AGC_proc(p, u);
        aux_signals = {raw_gain, gain};
        descriptions = {'Envelope', 'Raw gain', 'Gain'};
        
    case 'Freedom_AGC_proc'
        [v, gain, log_env, raw_gain, lpf_gain] = Freedom_AGC_proc(p, u);
        env = 2 .^ log_env;
        aux_signals = {raw_gain, lpf_gain, gain};
        descriptions = {'Envelope', 'Raw gain', 'LPF gain', 'Gain'};
end
