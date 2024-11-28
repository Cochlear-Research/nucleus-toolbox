function [x, calibration_gain_dB, audio_dB_SPL] = Audio_proc(p, a)

% Audio_proc: Read audio file, resample if necessary, and apply calibration gain.
%
% [x, calibration_gain_dB, audio_dB_SPL] = Audio_proc(p, a)
%
% If the arg "a" is a string, assume it is the name of an audio file,
% and read it from disk. If not, just apply calibration gain.
% There are two alternative methods for calibrating sound levels:
% 
% 1. Set p.audio_dB_SPL to the desired sound pressure level (default 65 dB SPL).
%    In this case, calibration_gain_dB will be calculated from the input audio 
%    to give the desired sound pressure level (relative to reference_dB_SPL).
%    The important return value is the calculated calibration_gain_dB 
%    (the returned audio_dB_SPL will be equal to p.audio_dB_SPL).
%
% 2. Set p.calibration_gain_dB to the desired gain in dB.
%    In this case, this pre-determined calibration gain will be applied to the input audio.
%    The important return value is the calculated audio_dB_SPL 
%    (the returned calibration_gain_dB will be equal to p.calibration_gain_dB).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch nargin

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 0	% Default parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	x = feval(mfilename, []);
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 1	% Parameter calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Clocks:
    p = Ensure_field(p, 'audio_sample_rate_Hz',         16000); % Hz
	p = Ensure_field(p, 'audio_sample_rate_tolerance',  1.06);

    % A reference pure tone with amplitude +/-1.0 is defined to represent a certain Sound Pressure Level:
    p = Ensure_field(p, 'reference_dB_SPL',             95);
    
    if ~isfield(p, 'calibration_gain_dB')
        % The desired audio Sound Pressure Level (the audio data will be scaled to produce this level):
	    p = Ensure_field(p, 'audio_dB_SPL',             65);
    end

	x = p;
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 2	% Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
    if ~ischar(a)
		x = a;		% skip to calibration
		
	else	% Assume it is the name of an audio file
	
        % Read entire file:
        [x, fs] = audioread(a);
        % If file has multiple channels, take first channel:
        if size(x, 2) > 1
            x = x(:, 1);
        end
        % Allow small sample rate differences:
        rate_ratio = fs / p.audio_sample_rate_Hz;
        if (rate_ratio   > p.audio_sample_rate_tolerance)...
        || (1/rate_ratio > p.audio_sample_rate_tolerance)
            x = resample(x, p.audio_sample_rate_Hz, fs);
        end

    end

    % Calculate the sound pressure level represented by the wav file before scaling:
    audio_dB_SPL = Calibrate_dB_SPL(p, x);

    if isfield(p, 'calibration_gain_dB')
        calibration_gain_dB = p.calibration_gain_dB;
    else
        % Calculate the calibration gain that will produce the desired sound pressure level:
        calibration_gain_dB = p.audio_dB_SPL - audio_dB_SPL;
    end

    % Apply gain:
    calibration_gain = From_dB(calibration_gain_dB);
    audio_dB_SPL = audio_dB_SPL + calibration_gain_dB;
    x = x * calibration_gain;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
