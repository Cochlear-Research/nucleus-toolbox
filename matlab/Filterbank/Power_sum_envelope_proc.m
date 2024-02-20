function v = Power_sum_envelope_proc(p, u)

% Power_sum_envelope_proc: Power-sum envelopes for FFT filterbank.
%
% function v = Power_sum_envelope_proc(p, u)
%
% Inputs:
% p:                Parameter struct containing the fields:
% p.block_length:     The FFT length.
% p.window:           The FFT window function.
% p.num_bins:         The number of FFT bins to retain.
% p.weights:          The weights used in summing the bins.
% p.num_bands:        The number of bands in the filterbank.
% u:                Complex filterbank output FTM
%
% Outputs:
% v:                Real envelope FTM.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch nargin

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 0	% Default parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	v = feval(mfilename, []);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 1	% Parameter calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Fundamental parameters:

	p = Ensure_field(p, 'equalise',  1);
	p = Ensure_field(p, 'num_bands', 22);
	p = Ensure_field(p, 'band_bins', FFT_band_bins(p.num_bands)');

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Derived parameters:

	% Weights matrix for combining FFT bins into bands:
	p.weights = zeros(p.num_bands, p.num_bins);
	bin = 3;	% We always ignore bins 0 (DC) & 1.
	for band = 1:p.num_bands;
		width = p.band_bins(band);
		p.weights(band, bin:(bin + width - 1)) = 1;
		bin = bin + width;
	end

	% Optionally incorporate frequency response equalisation:

	freq_response  = freqz(p.window/2, 1, p.block_length);
	power_response = freq_response .* conj(freq_response);

	P1 = power_response(1);
	P2 = 2 * power_response(2);
	P3 = power_response(1) + 2 * power_response(3);

	p.power_gains = zeros(p.num_bands, 1);
	for band = 1:p.num_bands;
		width = p.band_bins(band);
		if (width == 1)
			p.power_gains(band) = P1;
		elseif (width == 2)
			p.power_gains(band) = P2;
		else
			p.power_gains(band) = P3;
		end
	end

	if p.equalise
		for band = 1:p.num_bands;
			p.weights(band, :) = p.weights(band, :) / p.power_gains(band);
		end	
	end

	cum_num_bins = [1.5; 1.5 + cumsum(p.band_bins)];
	p.crossover_freqs_Hz = cum_num_bins * p.bin_freq_Hz;
	p.band_widths_Hz = diff(p.crossover_freqs_Hz);
	p.best_freqs_Hz = p.crossover_freqs_Hz(1:p.num_bands) + p.band_widths_Hz/2;
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	v = p;	% Return parameters.	
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 2	% Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	v = u .* conj(u);						% Power (magnitude squared) of each bin.
	u = p.weights * v;						% Weighted sum of bin powers.
	v = sqrt(u);							% Magnitude.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
