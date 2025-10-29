function [x, calibration_gain_dB, audio_dB_SPL] = Audio_calibration_proc(p, a)

% Audio_proc: Calculate and apply calibration gain.
%
% [x, calibration_gain_dB, audio_dB_SPL] = Audio_proc(p, a)
%
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

	x = feval(mfilename, struct);
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 1	% Parameter calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % A reference pure tone with amplitude +/-1.0 is defined to represent a certain Sound Pressure Level:
    p = Ensure_field(p, 'reference_dB_SPL',             95);
    
	check(p);

    if ~isfield(p, 'calibration_gain_dB')
        % The desired audio Sound Pressure Level (the audio data will be scaled to produce this level):
	    p = Ensure_field(p, 'audio_dB_SPL',             65);
    end

	x = p;
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 2	% Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
	check(p);

	% Calculate the sound pressure level represented by the wav file before scaling:
    audio_dB_SPL = Calibrate_dB_SPL(p, a);

    if isfield(p, 'calibration_gain_dB')
        calibration_gain_dB = p.calibration_gain_dB;
    else
        % Calculate the calibration gain that will produce the desired sound pressure level:
        calibration_gain_dB = p.audio_dB_SPL - audio_dB_SPL;
    end

    % Apply gain:
    calibration_gain = From_dB(calibration_gain_dB);
    audio_dB_SPL = audio_dB_SPL + calibration_gain_dB;
    x = a * calibration_gain;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
end

function check(p)
	if isfield(p, 'calibration_gain_dB') && isfield(p, 'audio_dB_SPL')
		error("Nucleus:Audio_calibration", "Cannot specify both calibration_gain_dB and audio_dB_SPL");
	end
end