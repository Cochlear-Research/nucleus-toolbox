function v = Calibrate_dB_SPL(p, audio)

% Calibrate_dB_SPL: Calculate sound pressure level in dB of an audio signal.
% For calibration purposes, a full scale +-1 reference tone
% is arbitrarily defined to represent a certain Sound Pressure Level,
% specified by p.reference_dB_SPL. 
% A full scale tone has an RMS level of 1/sqrt(2), i.e. -3 dB.
% Sound pressure level is calculated from the RMS value of the audio,
% relative to the RMS value of the reference tone.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

v = To_dB(rms(audio)) + p.reference_dB_SPL + To_dB(sqrt(2));


