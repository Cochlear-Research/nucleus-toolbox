function [v, gain_vec, log_env_vec, raw_gain, lpf_gain_vec] = Freedom_AGC_proc(p, u)

% Freedom_AGC_proc: Freedom Automatic Gain Control
%
% [v, gain, log_env, raw_gain, lpf_gain] = Freedom_AGC_proc(p, u)
%
% Inputs:
% p:    Parameter struct containing the following fields:
% p.audio_sample_rate_Hz: The sampling rate of the audio input
% u:    Audio input; row vector.
%
% Outputs
% v:            Audio output buffer.
% gain:         AGC gain.
% log_env:      Log envelope.
% raw_gain:     Preliminary gain value, before smoothing.
% lpf_gain:     Low-pass filtered gain, before overshoot limiting.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Koen Van Herck, Tim Neal, Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch nargin

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 0  % Default parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    v = feval(mfilename, []);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 1  % Parameter calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Set default values for parameters that are absent:
    % Basic parameters:
    p = FE_AGC_proc(p);
    
    % Additional parameters:
    p = Ensure_field(p, 'agc_compression_ratio',      inf);
	p = Ensure_field(p, 'agc_gain_dB',                  0); % Gain for signals below kneepoint.
	p = Ensure_field(p, 'agc_overshoot_dB',             3); % Maximum overshoot during attack.
    
    % Derived parameters:
    p.agc_release_weight        = 4.15/(p.agc_release_time_s * p.audio_sample_rate_Hz);
    p.agc_log_kneepoint         = log2(p.agc_kneepoint);
    p.agc_compression_scaler	= 1 - 1/p.agc_compression_ratio;
    p.agc_log_gain              = log2(From_dB(p.agc_gain_dB));
    p.agc_overshoot             = From_dB(p.agc_overshoot_dB);
    
    v = p;  % Return parameters.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 2  % Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    u = u(:);
    num_samples = length(u);

    % State variables:
    log_env_decay = -inf;
	g_lpf = 1.0;
	
	% Preallocate output buffers to improve speed:
	log_env_vec   = zeros(size(u));
	lpf_gain_vec  = zeros(size(u));
	gain_vec	  = zeros(size(u));
	
	% Envelope peak tracking (in log domain):
	w = warning('off', 'MATLAB:log:logOfZero');
	fwr = abs(u);           % Full wave rectify
    log_fwr = log2(fwr);    % Work in log domain (better for fixed-point DSP)
    for n = 1:num_samples
        x = max(log_fwr(n), log_env_decay);
        log_env_decay = x - p.agc_release_weight;
        log_env_vec(n) = x;
    end
    warning(w);	% Restore previous warning state.
    
    % Amount that envelope exceeds kneepoint:
    excess = max(0, log_env_vec - p.agc_log_kneepoint);
    
    % Compression ratio
    excess = excess * p.agc_compression_scaler;
    
    % Reduce gain:
    log_gain = p.agc_log_gain - excess;
    
    % Convert back to linear scale:
    raw_gain = 2 .^ log_gain;	% before smoothing
    
    % Smooth gain changes:
    for n = 1:num_samples    
        g = raw_gain(n); 
        
        % Low Pass Filter:
        g_lpf = p.agc_attack_weight * g + (1-p.agc_attack_weight) * g_lpf;
        lpf_gain_vec(n) = g_lpf;
        
        % Overshoot Limit
        g = min(g * p.agc_overshoot, g_lpf);
        gain_vec(n) = g;
    end

    % Apply the gain:
    v = u .* gain_vec;

end
