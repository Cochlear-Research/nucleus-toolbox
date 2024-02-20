function [v, gain_vec, env_vec, raw_gain_vec] = FE_AGC_proc(p, u)

% FE_AGC_proc: Front-end Automatic Gain Control
%
% [v, gain_vec, env_vec, raw_gain_vec] = FE_AGC_proc(p, u)
%
% Inputs:
% p:    Parameter struct containing the following fields:
% p.audio_sample_rate_Hz: The sampling rate of the audio input.
% p.agc_kneepoint:        The input level above which the AGC is active.
% p.agc_step_dB:          The step (in dB) in the input level used to define
%                         the AGC attack and release times.
% p.agc_attack_time_s:    The time taken (in seconds) for the gain to stabilise in response
%                         to an increase in the input level of agc_step_dB.
% p.agc_release_time_s:   The time taken (in seconds) for the gain to recover after a
%                         subsequent decrease in the input level of agc_step_dB.
% u:    Audio input vector.
%
% Outputs
% v:            Audio output vector.
% gain_vec:     Gain vector.
% env_vec:      Envelope vector.
% raw_gain_vec: Preliminary gain vector, before smoothing.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% State variables:

persistent agc_gain_state
persistent agc_env_state

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
    p = Ensure_field(p, 'audio_sample_rate_Hz',       16000);
    p = Ensure_field(p, 'agc_kneepoint',              1.0);
    p = Ensure_field(p, 'agc_attack_time_s',          0.005);
	p = Ensure_field(p, 'agc_release_time_s',         0.075);
	p = Ensure_field(p, 'agc_step_dB',                25);

    % Derived parameters:
    
    p.agc_attack_weight  = 3.912/(p.agc_attack_time_s * p.audio_sample_rate_Hz);

    % The release time calculation is done as per the Freedom processor,
    % assuming that the gain changes by p.agc_step_dB during p.agc_release_time_s. 
    % This ignores the 2 dB margin mentioned in IEC 60118-2.
    % When measured, the actual release time will be shorter by a factor of
    % about 2/p.agc_step_dB; i.e. default 2/25, about 8 percent shorter.
    p.agc_release_scaler = From_dB(-p.agc_step_dB / (p.agc_release_time_s * p.audio_sample_rate_Hz));

    % State variables:
	agc_gain_state = 1.0;
    agc_env_state  = 0.0;
    
    v = p;  % Return parameters.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 2  % Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    u = u(:);
    num_samples = length(u);
	
	% Preallocate output buffers to improve speed:
	env_vec	     = zeros(size(u));
	gain_vec     = zeros(size(u));
	raw_gain_vec = zeros(size(u));
	
	fwr = abs(u);           % Full wave rectify
    for n = 1:num_samples
        
        % Level dynamics:
        % - envelope peak tracking
        % - implements release time
        x = fwr(n);
        y = agc_env_state * p.agc_release_scaler;
        agc_env_state = max(x, y);
        
        % Static compression:
        % - infinite compression
        if agc_env_state < p.agc_kneepoint
            raw_gain = 1.0;
        else
            raw_gain = p.agc_kneepoint / agc_env_state;
        end
        
        % Gain dynamics:
        % - smooth gain changes with a first order IIR Low Pass Filter,
        % - implements attack time
        agc_gain_state = p.agc_attack_weight * raw_gain + (1-p.agc_attack_weight) * agc_gain_state;
        
        % Save intermediate signals:
        env_vec(n)      = agc_env_state;
        gain_vec(n)     = agc_gain_state;
        raw_gain_vec(n) = raw_gain;
    end
        
    % Apply the gain:
    v = u .* gain_vec;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end


    

