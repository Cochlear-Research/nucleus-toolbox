function a = Audio_mixer_proc(p, file_names)

% Audio_mixer_proc: Mix signal and noise audio files.
%
% a = Audio_mixer_proc(p, file_names)
% 
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
    p = Ensure_field(p, 'input_snr_dB', 0);

    a = p;  % Return parameters.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 2  % Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    assert(length(file_names) == 2);
    signal = Audio_proc(p, file_names{1});

    % Make a copy of the parameter struct, to set the noise level:
    pn = p;
    pn.audio_dB_SPL = p.audio_dB_SPL - p.input_snr_dB;
    noise = Audio_proc(pn, file_names{2});

    % Truncate the noise to the same length as the signal:
    signal_len = length(signal);
    noise = noise(1:signal_len);

    % Mix signal and noise at the specified SNR:
    a = signal + noise;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
