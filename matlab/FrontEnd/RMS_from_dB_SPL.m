function r = RMS_from_dB_SPL(p, spl)

% RMS_from_dB_SPL: Calculate RMS value corresponding to a Sound Pressure Level in dB.
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

r = From_dB(spl - p.reference_dB_SPL - To_dB(sqrt(2)));
