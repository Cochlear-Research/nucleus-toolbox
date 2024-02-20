function result = RMS_dB_SPL_test

% RMS_dB_SPL_test: Test of Calibrate_dB_SPL and RMS_from_dB_SPL

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

verbose = Tester(mfilename);
tol = 1e-2;

p = struct;
p.reference_dB_SPL = 95;

audio_sample_rate_Hz = 16000;
F0 = 1000;
duration = 0.1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Full scale pure tone:
[x, t] = Gen_tone(F0, duration, audio_sample_rate_Hz);
Tester(max(abs(x)), 1.0, tol);
level_dB_SPL = Calibrate_dB_SPL(p, x);
Tester(level_dB_SPL, 95.0, tol);

% Pure tone, 30 dB down from full scale:
level_dB_SPL = Calibrate_dB_SPL(p, x * From_dB(-30));
Tester(level_dB_SPL, 65.0, tol);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Full scale square wave, RMS == peak:
x = square(2 * pi * F0 * t);
level_dB_SPL = Calibrate_dB_SPL(p, x);
Tester(level_dB_SPL, 98.01, tol);

% Square wave, 40 dB down from full scale:
level_dB_SPL = Calibrate_dB_SPL(p, x * From_dB(-40));
Tester(level_dB_SPL, 58.01, tol);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For a scalar x, rms(x) = x.
% An RMS value of 1/sqrt(2) yields the reference level:

spl_values = [95.0,   75.0,    55.0];
rms_values = [0.7071, 0.07071, 0.007071];

for n = 1:length(spl_values)
    Tester(Calibrate_dB_SPL(p, rms_values(n)), spl_values(n), 0.01); % convert rms to dB SPL
    Tester(RMS_from_dB_SPL (p, spl_values(n)), rms_values(n), 0.01); % convert dB SPL to rms
end

% Check round-trip calculation:
for s1 = 40:100
    r = RMS_from_dB_SPL(p, s1);
    s2 = Calibrate_dB_SPL(p, r);
    Tester(s1, s2);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

result = Tester;	% Report result

