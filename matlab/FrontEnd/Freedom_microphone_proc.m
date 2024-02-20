function y = Freedom_microphone_proc(p, x)

% Freedom_microphone_proc: Emulate frequency response of Freedom microphone.
%
% y = Freedom_microphone_proc(p, x)
%
% p: Parameter struct.
% x: Sound level input.
% y: Microphone output.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%        $Date: 2024/01/29 $
%      Authors: Brett Swanson and Sean Lineaweaver
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch nargin

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 0	% Default parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	y = feval(mfilename, []);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 1	% Parameter calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 	% Defaults:
    p = Ensure_field(p, 'audio_sample_rate_Hz',  16000);
	p = Ensure_field(p, 'mic_order',            128);
    p = Ensure_field(p, 'directivity',        'dir');
  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Derived parameters:
    p.calibration_freq_Hz = p.audio_sample_rate_Hz/16;

    % Get the response data to use in the frequency sampling
    load('Freedom_avg_response_data.mat')
    % Loads column vector variables: freq, omni_mag, dir_mag
    switch p.directivity
        case 'dir'
            % Freedom directional microphone response:
            mag = dir_mag;
        case 'omni'
            % Freedom omnidirectional microphone response:
            % Note: requires separate pre-emphasis to be added.
            mag = omni_mag;
        otherwise
            error('directivity must be either "dir" or "omni", found "%s"', p.directivity);
    end

    % Normalise magnitudes, and convert to linear scale:
    mag = mag - max(mag);
    amplitude = From_dB(mag);
    % Zero any magnitudes more than 50 dB below max:
    kk = mag < -50;
    amplitude(kk) = 0;
    
    % Normalise the frequencies to the Nyquist frequency (fs/2).
    norm_freq = freq/(p.audio_sample_rate_Hz/2);
    % Remove any frequencies which are greater than Nyquist:
    if norm_freq(end) > 1
        kk = norm_freq > 1;
        norm_freq(kk) = [];
        amplitude(kk) = [];
    end
    % Append Nyquist response (needed for fir2):
    if norm_freq(end) < 1
        norm_freq = [norm_freq; 1];
        amplitude = [amplitude; 0];
    end
    % Prepend DC response (needed for fir2):
    if norm_freq(1) > 0
        norm_freq = [0; norm_freq];
        amplitude = [0; amplitude];
    end

    % Create filter using frequency sampling:
    b = fir2(p.mic_order, norm_freq, amplitude);
    p.mic_numer = b;
    p.mic_denom = 1;

	% Calculate gain at calibration frequency.
	% freqz requires a vector of at least 2 frequencies:
	h = freqz(p.mic_numer, p.mic_denom, [p.calibration_freq_Hz, p.calibration_freq_Hz*2], p.audio_sample_rate_Hz);
	h = h(1);	% discard 2nd frequency.
	
	% Add gain so that response at calibration_freq_Hz is 0 dB:
	p.mic_numer = p.mic_numer / abs(h);
	
	y = p;	% Return parameters.	
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 2	% Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	y = filter(p.mic_numer, p.mic_denom, x);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
