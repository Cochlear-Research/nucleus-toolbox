function GUI_audio_spectra(audio, audio_sample_rate_Hz)

% GUI_audio_spectra: GUI to display and play an array of audio spectra.
%
% GUI_audio_spectra(audio, audio_sample_rate_Hz)
%
% audio:                An array of audio signals.
%                       Audio can run across rows or columns.
% audio_sample_rate_Hz:	The sample rate of each signal.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate spectra:

[num_rows, num_cols] = size(audio);
if (num_rows > num_cols)
	u.audio = audio';
else
	u.audio = audio;
end
num_audio_signals = size(u.audio, 1);
if (num_audio_signals == 1)
	error('Must have more than one band');
end

u.audio_sample_rate_Hz = audio_sample_rate_Hz;	

p = FFT_filterbank_proc(u);
for n = 1:num_audio_signals
	cmplx = FFT_filterbank_proc(p, u.audio(n,:));
	u.mag{n} = sqrt(abs(cmplx));
end

GUI_audio_FTM(u);

