% Freedom_microphone_demo: Show measured response and synthesised FIRF.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Average measured response:
load('Freedom_avg_response_data.mat')
% Loads column vector variables: freq, omni_mag, dir_mag
mag = dir_mag;
mag_1000 = interp1(freq, mag, 1000);    % Interpolate to find mag at 1000 Hz
% Normalise to unity gain at 1000 Hz:
mag = mag - mag_1000;

% Default sample rate:
p = Freedom_microphone_proc;
sample_freqs = 100:100:(p.audio_sample_rate_Hz/2);
h = freqz(p.mic_numer, p.mic_denom, sample_freqs, p.audio_sample_rate_Hz);

figure;
semilogx(freq, mag, 'g');
hold on;
semilogx(sample_freqs, To_dB(abs(h)), 'r');

Window_title('Freedom microphone frequency response');
legend({'Measured', 'FIR'}, 'Location', 'SouthWest')
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');


