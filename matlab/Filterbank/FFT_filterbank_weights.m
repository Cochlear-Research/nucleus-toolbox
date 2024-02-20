function weights = FFT_filterbank_weights(channel_spec_Hz, fft_length, audio_sample_rate_Hz)

% FFT_filterbank_weights: Calculate FFT filterbank weights
%
% weights = FFT_filterbank_weights(channel_bounds, fft_length, audio_sample_rate_Hz)
% weights = FFT_filterbank_weights(channel_edges,  fft_length, audio_sample_rate_Hz)
%
% fft_length:           FFT length.
% audio_sample_rate_Hz: Audio sample rate (in Hertz).
% channel_bounds:       Frequency boundaries of filter bands; matrix size = (num_channels, 2)
%                       Each row is a pair of frequencies: the upper and lower boundary.
% channel_edges:        Frequency boundaries of filter bands; matrix size = (num_channels+1, 1)
% weights:              Weights matrix used to combine FFT bins into filter bands.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bin_bounds = FFT_bin_bounds(fft_length, audio_sample_rate_Hz);
[num_bins,     num_cols] = size(bin_bounds);
if num_cols ~= 2
	error('bin_bounds must have two columns');
end
bin_width = audio_sample_rate_Hz / fft_length;

[num_rows, num_cols] = size(channel_spec_Hz);
switch num_cols
case 1
	% Edge frequencies specified:
	channel_bounds_Hz = [channel_spec_Hz(1:end-1), channel_spec_Hz(2:end)];
	num_channels = num_rows - 1;
case 2
	% Upper & lower boundary frequencies specified:
	channel_bounds_Hz = channel_spec_Hz;
	num_channels = num_rows;
otherwise
	error('channel_spec_Hz must have one or two columns');
end

weights = zeros(num_channels, num_bins);

for chan = 1:num_channels
	for bin = 1:num_bins
		% Lower bound is the maximum of channel lower bound and bin lower bound:
		f_lower = max(bin_bounds(bin, 1), channel_bounds_Hz(chan, 1));
		% Upper bound is the minimum of channel upper bound and bin upper bound:
		f_upper = min(bin_bounds(bin, 2), channel_bounds_Hz(chan, 2));
		
		% Weight is the proportion of the bin that is spanned by the channel:
        f_width = f_upper - f_lower;
		if (f_width > 0)
			weights(chan, bin) = f_width / bin_width;
		end
	end
end
