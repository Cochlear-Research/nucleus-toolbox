function FFT_VS_filterbank_demo(audio)

% FFT_VS_filterbank_demo: GUI demonstrating FFT VS filterbank.
% See GUI_audio_spectra, GUI_audio_FTM for more information.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 1
    audio = 'asa.wav';
end
if ischar(audio)
	audio = audioread(audio);
end

p1 = struct;
p1.num_bands = 6;
p1.audio_sample_rate_Hz = 16000;
p1.analysis_rate_Hz = p1.audio_sample_rate_Hz;
p1 = FFT_VS_filterbank_proc(p1);

v1 = FFT_VS_filterbank_proc(p1, audio);
GUI_FTM(p1, v1, 'Filterbank output');

audio = [audio'; real(v1)];
GUI_audio_spectra(audio, p1.audio_sample_rate_Hz);
