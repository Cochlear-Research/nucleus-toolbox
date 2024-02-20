function u = Examine_FTM(p, m, title_str)

% Examine_FTM: Determine time, freq, magnitude scales & titles of FTMs.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright: Cochlear Ltd
%   Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

u = p;				% Copy param struct: sample_rate_Hz, best_freqs_Hz

u = Ensure_field(u, 'sample_rate_Hz',      1000);
u = Ensure_field(u, 'normalise',    	   0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Examine FTMs:

if iscell(m)
	u.data = m;
else
	u.data = {m};
end
u.num_FTMs = length(u.data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Magnitude scale:

for n = 1:u.num_FTMs
	u.max_mag(n) = max(max(abs(u.data{n})));
	if u.normalise
		u.data{n} = u.data{n} / u.max_mag(n);
	end
end

if u.normalise
	u.overall_max_mag = 1;
else
	u.overall_max_mag = max(u.max_mag);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time scale:
% The sample rate applies to the first FTM.
% Assume that all FTMs have the same time duration.

for n = 1:u.num_FTMs
	u.num_time_samples(n) = size(u.data{n}, 2);
end

u.duration = u.num_time_samples(1) / u.sample_rate_Hz;

for n = 1:u.num_FTMs
	u.sample_time(n) = u.duration / u.num_time_samples(n);
end

u.time_label_string	= 'Time (s)';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Freq scale:

u.max_freq_index = size(u.data{1}, 1);

u.y_dir = 'reverse';		% Default.
if isfield(u, 'best_freqs_Hz')
	u.freq_label_string = 'Frequency (Hz)';
	u.freq_labels = u.best_freqs_Hz;
	if (u.best_freqs_Hz(1) < u.best_freqs_Hz(end))
		u.y_dir = 'normal';
	end
else
	u.freq_label_string = 'Channel';
	u.freq_labels = 1:u.max_freq_index;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Window title.
% The specified title_str should be a cell array of strings,
% one to name each of the data FTMs in the cell array m.
% If there is only one string, it is used for each cell.

if ~iscell(title_str)
	for n = 1:u.num_FTMs
		u.title_str{n} = sprintf('%s (%d)', title_str, n);
	end
else
	u.title_str = title_str;
	if length(title_str) < u.num_FTMs
		error('Insufficient number of title strings');
	end
end
