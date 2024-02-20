function result = FFT_filterbank_weights_test

% FFT_filterbank_weights_test: Test of FFT filterbank weights

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

verbose = Tester(mfilename);

sample_rate_Hz = 16000;
fft_length = 128;
chan_edges = [
 142
 297
 480
 660
 840
1018
1196
1375
1571
1805
2073
2382
2736
3175
3720
4358
5101
5982
7008
];

% Convert frequency boundaries into weights:
weights 	= FFT_filterbank_weights(chan_edges, fft_length, sample_rate_Hz);

% Alternative input format, should give identical result:
chan_bounds = [chan_edges(1:end-1), chan_edges(2:end)];
weights2 	= FFT_filterbank_weights(chan_bounds, fft_length, sample_rate_Hz);
Tester(weights, weights2);

% Convert weights back into frequency boundaries:
inv_edges	= FFT_filterbank_freq_bounds(weights, fft_length, sample_rate_Hz);
Tester(chan_edges, inv_edges);

result = Tester;	% Report result

