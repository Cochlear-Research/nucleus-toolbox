function Plot_sequences(seq, channels, show_time_slots)

% Plot_sequence: Plot a cell array of sequences.
% Plots a sequence as one vertical line segment per pulse, 
% with height proportional to magnitude.
% If a cell array of sequences is given, they are displayed on separate axes.
%
% u = Plot_sequences(seq, title_str, channels)
%
% seq:       A sequence or cell array of sequences
% title_str: A string or cell array of strings, used as the window title(s).
% channels:  A vector containing the lowest & highest channel numbers to be displayed.
%              Defaults to the min and max channel numbers present in the sequence(s).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright: Cochlear Ltd
%   Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if iscell(seq)		
	u.seqs = seq;
else
	u.seqs = {seq};
end
u.num_seqs = length(u.seqs);

is_channels = 1;
for n = 1:u.num_seqs	
	if ~isfield(u.seqs{n}, 'channels')
		u.seqs{n}.channels = 23 - u.seqs{n}.electrodes;
		is_channels = 0;
	end
	if ~isfield(u.seqs{n}, 'magnitudes')
		u.seqs{n}.magnitudes = u.seqs{n}.current_levels;
	else
		idles = (u.seqs{n}.magnitudes < 0);
		if any(idles)
			if length(u.seqs{n}.channels) == 1	% replicate constant channel
				u.seqs{n}.channels = repmat(u.seqs{n}.channels, length(u.seqs{n}.magnitudes), 1);
			end
			u.seqs{n}.channels(idles)   = 0;
			u.seqs{n}.magnitudes(idles) = 0;
		end
	end
	min_channels(n) = min(u.seqs{n}.channels);
	max_channels(n) = max(u.seqs{n}.channels);
	max_mags(n)     = max(u.seqs{n}.magnitudes);
	max_times(n)	= Get_sequence_duration(u.seqs{n});
	periods1(n)		= u.seqs{n}.periods_us(1);
end

if exist('channels', 'var')
	u.min_channel = min(channels);
	u.max_channel = max(channels);	
else
	u.min_channel = min(min_channels);
	u.max_channel = max(max_channels);
end
u.max_mag   = max(max_mags);
u.max_time  = max(max_times);
max_period1 = max(periods1);

if ~exist('show_time_slots', 'var')
	show_time_slots = 0;
end

if show_time_slots
	time_scale = max_period1;
	time_label = 'Time slots';
elseif (u.max_time > 5000)
	time_scale = 1000;
	time_label = 'Time (ms)';
else
	time_scale = 1;
	time_label = 'Time (us)';
end

Get_axes(u.num_seqs, 1);

yticks = u.min_channel:u.max_channel;
u.y_scale = 0.75;
for n = u.num_seqs:-1:1
	pa = Get_axes;
	Plot_sequence_as_lines(u.seqs{n}, u.max_mag/u.y_scale, time_scale);

	set(gca, 'YTick', yticks);
	set(gca, 'TickDir', 'out');
	ylabel('Channel');
	if ~is_channels
		set(gca,'YTickLabel', 23 - yticks);
		ylabel('Electrode');
	end
	set(gca, 'YLim', [u.min_channel - 1 + u.y_scale, u.max_channel + 1])
	set(gca, 'XLim', [-max_period1, u.max_time]/time_scale);
	if show_time_slots
		set(gca, 'XTick', 0:(u.max_time/time_scale))
	end

	set(gca, 'Box', 'on');
end

set(pa.axes_vec(2:end), 'XTickLabel', []);
axes(pa.axes_vec(1));
xlabel(time_label);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot sequence as one vertical line segment per pulse, 
% with height proportional to magnitude.
% The scaling factor max_mag is passed in so that multiple sequences
% can all be drawn with the same scale.
% The entire sequence is plotted as one "line" handle.
% This is much faster than a separate handle for each pulse.
% NaNs are used to separate the line segments for each pulse.

function hdl = Plot_sequence_as_lines(seq, max_mag, time_scale)

	t = Get_pulse_times(seq);				% column_vector
	t = t' / time_scale;					% row vector
	z = repmat(NaN, size(t));
	
	x = [t; t; z];
	x = x(:);								% column vector

	c = seq.channels';						% Bottom of line aligns with channel Y axis tick.
	if length(c) == 1
		c = repmat(c, size(t));
	end
	m = seq.magnitudes';
	h = c + m / max_mag;					% Line height is proportional to magnitude.
	y = [c; h; z];
	y = y(:);								% column vector

	hdl = line(x, y, 'Color', 'black');
