function [a, signal, noise] = Audio_mixer_proc(p, sources)

% Audio_mixer_proc: Mix signal and noise.
%
% a = Audio_mixer_proc(p, sources)
%
% p: parameter struct
% p.audio_dB_SPL: speech level.
% p.noise_dB_SPL: noise level.
% sources: a 2-element cell array of sources {speech, noise}, 
%           where each source is either a wav file name, or a signal.
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch nargin

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 0  % Default parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    a = feval(mfilename, struct);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 1  % Parameter calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Set default values for parameters that are absent:
    p = Audio_proc(p);
    p = Ensure_field(p, 'noise_dB_SPL', 65);

    a = p;  % Return parameters.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 2  % Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    assert(length(sources) == 2);
    signal = Audio_proc(p, sources{1});

    % Make a copy of the parameter struct, to set the noise level:
    pn = p;
    pn.audio_dB_SPL = p.noise_dB_SPL;
    noise = Audio_proc(pn, sources{2});

    % Truncate the noise to the same length as the signal:
    signal_len = length(signal);
    noise = noise(1:signal_len);

    % Mix signal and noise:
    a = signal + noise;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
