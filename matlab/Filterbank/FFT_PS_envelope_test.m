function result = FFT_PS_envelope_test

% FFT_PS_envelope_test: Test of FFT_filterbank_proc & Power_sum_envelope.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

verbose = Tester(mfilename);

tol = 1e-10;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Analysis rate equal to audio sample rate:

p1.audio_sample_rate_Hz	= 16000;	% Hz
p1.analysis_rate_Hz		= p1.audio_sample_rate_Hz;
p1.num_bands			= 22;
p1 = Append_process(p1, @FFT_filterbank_proc); 
p1 = Append_process(p1, @Power_sum_envelope_proc); 

N = 2 * p1.block_length;
n = (0:N-1)';

cos1000  = cos(2*pi*n* 1000/p1.audio_sample_rate_Hz);
sin1000  = sin(2*pi*n* 1000/p1.audio_sample_rate_Hz);			

p1_cos1000__ = Process(p1, cos1000);
p1_sin1000__ = Process(p1, sin1000);

if verbose > 2
	GUI_FTM(p1, p1_cos1000__, 'p1_cos1000');
	GUI_FTM(p1, p1_sin1000__, 'p1_sin1000');
end

% Extract stable output (after the input signal fills the window):
p1_cos1000_ = p1_cos1000__(:,p1.block_length+1:end);
p1_sin1000_ = p1_sin1000__(:,p1.block_length+1:end);

Tester(size(p1_cos1000__), [p1.num_bands N]);
Tester(size(p1_sin1000__), [p1.num_bands N]);
	
% Output should be stable:
Tester(diff(p1_cos1000_,1,2), 0, tol);
Tester(diff(p1_sin1000_,1,2), 0, tol);
Tester(p1_cos1000_, p1_sin1000_, tol);	 % identical for sin & cos.

% Look at steady-state response, in the last column:
% (used in next section on steady-state response)
p1_sin1000 = p1_sin1000__(:,end);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To measure steady-state gains to pure tones,
% the length of the signal can be the same as the FFT length,
% and the analysis rate can be chosen to have no overlap between blocks,
% so the output will be a single column.

p2 = p1;
p2.analysis_rate_Hz = p1.audio_sample_rate_Hz/p1.block_length;
p2 = Process(p2);	% Recalc parameters

N = p2.block_length;
n = (0:N-1)';
sin2000  = sin(2*pi*n* 2000/p2.audio_sample_rate_Hz);			
sin5000  = sin(2*pi*n* 5000/p2.audio_sample_rate_Hz);			
sin5125  = sin(2*pi*n* 5125/p2.audio_sample_rate_Hz);			

p2_sin2000 = Process(p2, sin2000);
p2_sin5000 = Process(p2, sin5000);
p2_sin5125 = Process(p2, sin5125);

if verbose > 1
	disp('Frequency table');
	lower_freqs = round(p2.crossover_freqs_Hz(1:end-1));
	upper_freqs = round(p2.crossover_freqs_Hz(2:end));
	disp([(1:p2.num_bands)', p2.band_bins, p2.band_widths_Hz, lower_freqs, upper_freqs, round(p2.best_freqs_Hz)]);
end
if verbose > 2
    figure, hold on;
	Window_title('Tone response');
	plot(p1_sin1000, '-o');
	plot(p2_sin2000, '-o');
	plot(p2_sin5000, '-o');
end

% Find spectral peaks:
[~, p1_sin1000_max_band] = max(p1_sin1000);
[~, p2_sin2000_max_band] = max(p2_sin2000);
[~, p2_sin5000_max_band] = max(p2_sin5000);

% For pure tones at an FFT bin freq, the output of the FFT filterbank
% (before combining into bands) has a maximum response in the "centred" bin,
% and the two adjacent bins have half the response.
% When combining into bands, there are 3 cases:
% * 3 bins go into 3 different bands (e.g. 1000 Hz)
%		=> weights are calculated to give gain for centre band = 1.
% * 3 bins go into one band (e.g. 5000 Hz).
%		=> weights are calculated to give gain = 1.
% * 2 bins go into one band, 1 bin goes into another (e.g. 2000 Hz).
%		=> The gain is a little less than 1.
%			(The maximum gain of 1 occurs when the audio frequency
%			is midway between two bins.)
%			The calculation is:

bin = 1 + 2000/p2.bin_freq_Hz;		% The bin number that 2000 Hz is centred in.
band = 12;						% The band that we're interested in.
weight = p2.weights(band,bin);	% The weight that bin has in the band.
mag_weight = sqrt(weight);		% Weights apply to powers.
gain = 32 * mag_weight;			% Compensate for FFT length and window.
X = gain * sqrt(1^2 + 0.5^2);
Y = gain * 0.5;

					%   1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22
p1_sin1000_expected = [ 0; 0; 0; 0; 0;.5; 1;.5; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0;];
p2_sin2000_expected = [ 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; X; Y; 0; 0; 0; 0; 0; 0; 0; 0; 0;];
p2_sin5000_expected = [ 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 1; 0; 0; 0;];

Tester(size(p1_sin1000), [p1.num_bands 1]);
Tester(size(p2_sin2000), [p2.num_bands 1]);
Tester(size(p2_sin5000), [p2.num_bands 1]);

% 1000 Hz:
			
Tester(p1_sin1000, p1_sin1000_expected, tol);
Tester(p1.best_freqs_Hz(p1_sin1000_max_band), 1000);
Tester(p1_sin1000_max_band, 7);

% 2000 Hz:
Tester(p2_sin2000_max_band, 12);		
Tester(p2_sin2000, p2_sin2000_expected, tol);

% 5000 Hz:
Tester(p2_sin5000_max_band, 19);		
Tester(p2_sin5000, p2_sin5000_expected, tol);

% 5125 Hz gives same response as 5000 Hz:
Tester(p2_sin5125, p2_sin5000_expected, tol);
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

result = Tester;	% Report result
