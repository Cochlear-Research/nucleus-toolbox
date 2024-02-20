function u = FFT_VS_filterbank_proc(p, audio)

% FFT filterbank with vector-sum combine.
%
% Args:
%   p:      A struct containing the filterbank parameters.
%   audio:  A sampled audio signal.
%
% Returns:
%   u:      A complex FTM with ``p.num_bands`` rows.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch nargin

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 0	% Default parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	u = feval(mfilename, []);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 1	% Parameter calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Fundamental parameters:

    p = FFT_filterbank_proc(p);
	p = Ensure_field(p,'equalise',  1);
	p = Ensure_field(p,'num_freq_response_samples', 2048);

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Derived parameters:

	if isfield(p, 'crossover_freqs_Hz')
	
		% Frequency boundaries have been specified.
		% Use fractional bin weights.
		
		p.weights = FFT_filterbank_weights(p.crossover_freqs_Hz, p.block_length, p.audio_sample_rate_Hz);
		p.num_bands = size(p.weights, 1);
		
	else
		% Use integer bin weights:
		
		p = Ensure_field(p, 'num_bands', 22);
		p = Ensure_field(p, 'band_bins', FFT_band_bins(p.num_bands)');
		p.start_bin = 3;	% Ignore the first two bins (DC & 125 Hz).
		p.weights	= zeros(p.num_bands, p.num_bins);
		bin = p.start_bin;
		for band = 1:p.num_bands
			n = p.band_bins(band);	% the number of FFT bins in this band
			weight_indices = bin:(bin + n - 1);
			p.weights(band, weight_indices) = 1;
			bin = bin + n;
		end

		cum_num_bins = (p.start_bin - 1.5) + [0; cumsum(p.band_bins)];
		p.crossover_freqs_Hz = cum_num_bins * p.bin_freq_Hz;
	end
	
	p.band_widths_Hz = diff(p.crossover_freqs_Hz);
	p.best_freqs_Hz  = p.crossover_freqs_Hz(1:p.num_bands) + p.band_widths_Hz/2;
	
	% Weights need to have alternating signs:
	alt = (-1).^(0:p.num_bins-1);	% row vector with alternating signs
	p.weights = p.weights .* repmat(alt, p.num_bands, 1);

	% Calculate frequency responses of each FFT bin.
	% The DC bin's impulse response is p.window.
	impulse_response = [p.window/2; zeros(p.num_freq_response_samples - p.block_length, 1)];
	H0 = fft(impulse_response);
	p.response_freqs_Hz = (0:(p.num_freq_response_samples-1))' * p.audio_sample_rate_Hz/p.num_freq_response_samples;
	
	% Each bin response is a frequency-shifted copy of the DC bin's response.
	n_bin = p.num_freq_response_samples/p.block_length;
	H = zeros(p.num_freq_response_samples, p.num_bins);
	for b = 1:p.num_bins
		H(:,b) = circshift(H0, (b-1) * n_bin);
	end
	H = H.';	% transpose (without complex conjugation)

	% Each channel frequency response is a weighted sum of FFT bin responses:
	p.freq_response = p.weights * H;

	% Equalise the gains across channels:
	p.vector_sum_gains = max(abs(p.freq_response), [], 2);	% Max of each channel (row)
	if p.equalise
		for band = 1:p.num_bands
			p.weights(band, :) = p.weights(band, :) / p.vector_sum_gains(band);
		end	
		p.freq_response = p.weights * H;	% Recalculate with equalised weights.
	end

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	u = p;	% Return parameters.	
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 2	% Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    x = FFT_filterbank_proc(p, audio);
	u = p.weights * x;						% Weighted sum of bin vectors.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
