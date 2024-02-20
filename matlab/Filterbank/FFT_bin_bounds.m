function bin_bounds = FFT_bin_bounds(fft_length, audio_sample_rate_Hz)

% FFT_bin_bounds: Calculate FFT bin frequency boundaries
%
% bin_bounds = FFT_bin_bounds(fft_length, audio_sample_rate_Hz)
%
% fft_length:           FFT length.
% audio_sample_rate_Hz: Audio sample rate (in Hertz).
% bin_bounds:           Frequency boundaries of FFT bins; matrix size = (num_bins, 2)
%
% Each row of the bin_bounds matrix is a pair of frequencies: upper and lower boundary.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

freq_spacing = audio_sample_rate_Hz/fft_length;
K = fft_length/2;
k = (0:K)';
kk = [k - 0.5, k + 0.5];
bin_bounds = kk * freq_spacing;
