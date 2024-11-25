function a = Resynth_audio_proc(p, v)

% Resynth_audio_proc: Resynthesise audio from a Frequency-Time Matrix (FTM).
% Reconstructs an audio signal from an envelope FTM of a speech coding strategy.
% Pure tones are created at the centre frequency of each filter
% amplitude modulated by the envelope samples, and added together.
% Assumes that the FTM is sampled at the channel stimulation rate,
% and uses Resample_FTM_proc to up-sample it to the audio sample rate.
%
% audio = Resynth_audio_proc(p, v)
%
% p: A struct containing the strategy parameters.
% v: Envelope FTM.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson, Bas van Dijk
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch nargin

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 0	% Default parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	a = feval(mfilename, []);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 1	% Parameter calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	% Resample_FTM_proc uses the following parameters:
    % - p.analysis_rate_Hz: input sample rate
    % - p.channel_stim_rate_Hz: output sample rate
    % We want the output sample rate to be audio_sample_rate_Hz:
    p.channel_stim_rate_Hz = p.audio_sample_rate_Hz;
    p = Resample_FTM_proc(p);

    % Field to control whether to normalise reconstructed audio:
    p = Ensure_field(p, 'normalise', 1);

	a = p;	% Return parameters.	
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 2	% Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Upsample FTM to audio_sample_rate_Hz:
    u = Resample_FTM_proc(p, v);

    % Set up the matrix with a pure sine for each frequency band.
    n = 1:size(u, 2);
    t = n / p.audio_sample_rate_Hz;
    freqs = p.best_freqs_Hz;
    sine_component = sin(2 * pi * freqs * t);   % The order of the freq and t parameters is crucial!

    % Reconstruct the sound in each band
    audio_bands = sine_component .* u;
    
    % Sum each of the bands together to create the audio signal.
    a = sum(audio_bands)';
    
    % Optionally normalise:
    if p.normalise
        a = a / max(abs(a));
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
