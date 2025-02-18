% FFT_VS_FIR_equivalence_demo: Demonstrate equivalence of FFT vector sum filterbank and complex FIR filterbank

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright: Cochlear Ltd
%   Authors: Brett Swanson, Jamon Windeyer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p = struct;
p.audio_sample_rate_Hz = 16000;
p.analysis_rate_Hz = 16000;

pa = Audio_proc(p);
pv = FFT_VS_filterbank_proc(p);

% Calculate complex FIR coefficients (impulse response) for each band:
pf = p;
bin_coeffs = zeros(pv.block_length/2 + 1, pv.block_length);
nn = (0:(pv.block_length - 1))';
rr = -2i * pi * nn / pv.block_length; % factor out common sub-expression from loopv.
K = pv.block_length/2;
for k = 0:K
    % Each bin impulse response is a modulated window function:
    bin_coeffs(k + 1, :) = pv.window .* exp(rr * k); 
end
% Band impulse responses are weighted sums of bin impulse responses:
band_coeffs = pv.weights * bin_coeffs;
% When considering as traditional FIR, the coefficients are reversed:
band_coeffs = flip(band_coeffs, 2);
for n = 1:pv.num_bands
    pf.numer{n} = band_coeffs(n, :);
end
pf = FIR_filterbank_proc(pf);

%% Process audio:
audio = Audio_proc(pa, 'asa.wav');
uv = FFT_VS_filterbank_proc(pv, audio);
uf = FIR_filterbank_proc(pf, audio);

%% Quantify differences:
u_delta = uv - uf; % complex
rms_delta = rms(u_delta(:))

%% Plot shows no difference:
figure, hold on;
plot(real(uv(1, :)), 'r');
plot(real(uf(1, :)), 'b');
zoom xon

%%
GUI_FTM(pv, {uv, uf}, {'FFT VS', 'CFIR'});
