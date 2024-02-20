function p = Ensure_amplitude_params(p)

% Ensure_amplitude_params: Set default amplitude parameters for AGC and LGF.
% p = Ensure_amplitude_params(p)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin == 0
    p = struct;
end

% A reference pure tone with amplitude +/-1.0 is defined to 
% represent a certain Sound Pressure Level:
p = Ensure_field(p, 'reference_dB_SPL',             95);

% These are the speech SPLs that give C-level and T-level stimulation:
p = Ensure_field(p, 'C_dB_SPL',                     65);
p = Ensure_field(p, 'T_dB_SPL',                     25);

% Crest factor is the ratio between peak and RMS levels:
p = Ensure_field(p, 'speech_crest_factor_dB',       11);

% A reference pure tone will achieve C-level stimulation
% at a lower RMS level than a speech signal:
p = Ensure_field(p, 'speech_bandwidth_factor_dB',   6);

% Envelope level that produces C-level stimulation:
p = Ensure_field(p, 'sat_level',                    1.0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Derived parameters:

% FE AGC calibration:
% Speech at C-SPL should just reach the AGC kneepoint.
% Firstly calculate the RMS level for this speech:
speech_rms_C = RMS_from_dB_SPL(p, p.C_dB_SPL);
% Then calculate the peak level for this speech:
p.agc_kneepoint = From_dB(p.speech_crest_factor_dB) * speech_rms_C;

% LGF calibration:
% Saturation in LGF is just reached for speech at C-SPL,
% or for a reference tone that is a specified number of dB lower.
tone_sat_level_dB_SPL = p.C_dB_SPL - p.speech_bandwidth_factor_dB;
% Calculate the RMS level for this reference tone:
tone_rms_sat_level = RMS_from_dB_SPL(p, tone_sat_level_dB_SPL);
% Calculate the peak level for this reference tone:
tone_peak_sat_level = tone_rms_sat_level * sqrt(2);
% The filterbank has unity gain, so for a pure tone,
% the envelope amplitude equals the peak value of the tone.
% Calculate the gain needed to amplify this reference tone to sat level:
p.gain_dB = To_dB(p.sat_level / tone_peak_sat_level);

p.dynamic_range_dB = p.C_dB_SPL - p.T_dB_SPL;

