function result = Audio_test

% Audio_test: Test of Audio_proc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Tester(mfilename);
tol = 1e-5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input is audio data; check scaling:

% Case 1: Specify the desired audio level (audio_dB_SPL)

p = struct;
p.audio_sample_rate_Hz = 16000;
p = Audio_proc(p);
Tester(p.reference_dB_SPL, 95);
Tester(p.audio_dB_SPL, 65);
% Generate a full scale input tone:
tone_in = Gen_tone(250, 0.1, p.audio_sample_rate_Hz);
Tester(max(abs(tone_in)), 1.0, tol);
[tone_out, gain_dB, audio_dB_SPL] = Audio_proc(p, tone_in);
% Output tone should be 30 dB down from full scale:
Tester(tone_in * From_dB(gain_dB), tone_out, tol);
Tester(gain_dB, -30, tol);
Tester(audio_dB_SPL, 65, tol);

% If the amplitude of the input tone is changed, the gain compensates,
% so that the output is still at the desired level:
[tone_out2, gain2_dB] = Audio_proc(p, tone_in / 2);
Tester(tone_out2, tone_out, tol);
Tester(gain2_dB, gain_dB + To_dB(2), tol);
Tester(audio_dB_SPL, 65, tol);

% Change desired output level to 95 dB SPL:
p = struct;
p.audio_sample_rate_Hz = 16000;
p.audio_dB_SPL = 95;
p = Audio_proc(p);
[tone_out, gain_dB, audio_dB_SPL] = Audio_proc(p, tone_in);
% Output tone should be at full scale:
Tester(max(abs(tone_out)), 1.0, tol);
Tester(tone_in, tone_out, tol);
Tester(gain_dB, 0, tol);
Tester(audio_dB_SPL, 95, tol);

% Case 2: Use pre-determined calibration gain:

p = struct;
p.audio_sample_rate_Hz = 16000;
p.calibration_gain_dB = -20;
p = Audio_proc(p);
[tone_out, gain_dB, audio_dB_SPL] = Audio_proc(p, tone_in);
Tester(tone_out, tone_in * From_dB(gain_dB), tol);
Tester(gain_dB, -20, tol);
Tester(audio_dB_SPL, 75, tol);

% If the amplitude of the input tone is reduced, the output is reduced:
[tone_out2, gain2_dB, audio2_dB_SPL] = Audio_proc(p, tone_in/2);
Tester(tone_out2, tone_out/2, tol);
Tester(gain2_dB, -20, tol);
Tester(audio2_dB_SPL, 75 - To_dB(2), tol);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input is wav file at exact rate:

p = struct;
p.audio_sample_rate_Hz = 16000;
p = Audio_proc(p);
[choice_wav, fs] = audioread('Choice.wav');
Tester(fs, 16000);
[choice_out, gain_dB] = Audio_proc(p, 'Choice.wav');
Tester(choice_wav * From_dB(gain_dB), choice_out);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input is wav file at close rate: no resampling

[asa_wav, fs] = audioread('asa.wav');
Tester(fs, 16537);
[asa_out, gain_dB] = Audio_proc(p, 'asa.wav');
Tester(asa_wav * From_dB(gain_dB), asa_out);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input is wav file at not close enough rate:

p.audio_sample_rate_tolerance = 1.02;
Tester(fs, 16537);
asa_out = Audio_proc(p, 'asa.wav');
Tester(length(asa_wav) > length(asa_out));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

result = Tester;	% Report result

