function channel_bounds = FFT_filterbank_freq_bounds(weights, fft_length, audio_sample_rate_Hz)

% FFT_filterbank_freq_bounds: Calculate FFT filterbank frequency boundaries
%
% channel_bounds = FFT_filterbank_freq_bounds(weights, fft_length, audio_sample_rate_Hz)
%
% weights:           Weights matrix used to combine FFT bins into filter bands.
% fft_length:        FFT length.
% audio_sample_rate_Hz: Audio sample rate (in Hertz).
% channel_bounds:    Frequency boundaries of filter bands; matrix size = (num_channels, 2)
%                    Each row is a pair of frequencies: the upper and lower boundary.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[num_channels, num_bins] = size(weights);

bin_bounds = FFT_bin_bounds(fft_length, audio_sample_rate_Hz);

[num_bins_x, num_cols] = size(bin_bounds);
if num_cols ~= 2
	error('bin_bounds must have two columns');
end
if num_bins ~= num_bins_x
	error('weights has incorrect number of columns'); 
end

bin_widths = bin_bounds(:, 2) - bin_bounds(:, 1);

% Each channel has a pair of frequencies: upper and lower boundary:
channel_bounds = zeros(num_channels, 2);

for chan = 1:num_channels
	used_bins  = find(weights(chan, :));
	
	% Lower freq bound determined by first non-zero weight:
	lower_bin = used_bins(1);
	channel_bounds(chan, 1) = bin_bounds(lower_bin, 2) ...
							- weights(chan, lower_bin) * bin_widths(lower_bin);
	
	% Upper freq bound determined by last non-zero weight:
	upper_bin = used_bins(end);
	channel_bounds(chan, 2) = bin_bounds(upper_bin, 1) ...
							+ weights(chan, upper_bin) * bin_widths(upper_bin);
end

for k = 1:num_channels-1
	delta_freq(k) = channel_bounds(k+1,1) - channel_bounds(k,2);
end
if max(abs(delta_freq)) < 1
	channel_bounds = [channel_bounds(:,1); channel_bounds(end,2)];
end