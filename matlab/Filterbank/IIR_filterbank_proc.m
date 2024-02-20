function y = IIR_filterbank_proc(p, x)

% IIR_filterbank_proc: IIR filterbank.
% y = IIR_filterbank_proc(p, x)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch nargin

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 0	% Default parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	y = feval(mfilename, []);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 1	% Parameter calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	% Set default values for parameters that are absent:
	p = Ensure_field(p, 'audio_sample_rate_Hz', 16000);
	
	p.analysis_rate_Hz = p.audio_sample_rate_Hz;
	p.sample_rate_Hz   = p.audio_sample_rate_Hz;
	
	p = Ensure_field(p, 'filter_order', 4);
	
	if ~isfield(p, 'crossover_freqs_Hz')
		p = Ensure_field(p, 'table_num', 9);
		p.crossover_freqs_Hz = ESPrit_crossover_frequencies(p.table_num, p.audio_sample_rate_Hz/2);
	end
	p.best_freqs_Hz = 0.5 * (p.crossover_freqs_Hz(1:end-1) + p.crossover_freqs_Hz(2:end));

	% Calculate derived parameters:
	
	p.num_bands = length(p.crossover_freqs_Hz) - 1;
	for n = 1:p.num_bands
		[p.numer{n}, p.denom{n}] = butter(p.filter_order ...
			,[p.crossover_freqs_Hz(n), p.crossover_freqs_Hz(n+1)]/(p.audio_sample_rate_Hz/2) ...
			,'bandpass'...
			);
	end
	y = p;	% Return parameters.	
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 2	% Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	for n = 1:p.num_bands
		y(n,:) = filter(p.numer{n}, p.denom{n}, x)';
	end
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
