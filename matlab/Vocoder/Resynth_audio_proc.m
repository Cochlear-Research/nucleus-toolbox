function a = Resynth_audio_proc(p, v)

% Resynth_audio_proc: Resynthesise audio from a Frequency-Time Matrix (FTM).
% Reconstructs an audio signal from an envelope FTM of a speech coding strategy.
% Pure tones are created at the centre frequency of each filter
% amplitude modulated by the envelope samples, and added together.
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

	% Set default values for parameters that are absent:

    % Field to control whether to normalise reconstructed audio:
    p = Ensure_field(p, 'normalise', 1);

	a = p;	% Return parameters.	
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 2	% Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Set up the matrix with a pure sine for each frequency band.
    t = 1:size(v, 2);
    t = t / p.audio_sample_rate_Hz;
    freqs = p.best_freqs_Hz;
    sine_component = sin(2 * pi * freqs * t);   % The order of the freq and t parameters is crucial!

    % Reconstruct the sound in each band
    audio_bands = sine_component .* v;
    
    % Sum each of the bands together to create the audio signal.
    a = sum(audio_bands)';
    
    % Optionally normalise:
    if p.normalise
        a = a / max(abs(a));
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
