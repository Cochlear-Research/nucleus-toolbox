% FFT_VS_FIR_equivalence_demo: Demonstrate equivalence of FFT vector sum filterbank and complex FIR filterbank

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright: Cochlear Ltd
%   Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p = struct;
p.audio_sample_rate_Hz = 16000;
p.analysis_rate_Hz = 16000;

p_aud = Audio_proc(p);
p_fftv = FFT_VS_filterbank_proc(p);
p_fir = Get_coefficients_proc(p_fftv);

%% Process audio:
audio = Audio_proc(p_aud, 'asa.wav');
u_fftv = FFT_VS_filterbank_proc(p_fftv, audio);
% FIR output:
u_fir = zeros(p_fir.num_bands, length(audio));
for band = 1:p_fir.num_bands
    u_fir(band, :) = filter(p_fir.band_coeffs(band, :), 1, audio);
end

%% Plot shows no difference:
figure, hold on;
plot(real(u_fftv(1, :)), 'r');
plot(real(u_fir (1, :)), 'b');
zoom xon

%%
GUI_FTM(p_fftv, {u_fftv, u_fir}, {'FFT VS', 'CFIR'});