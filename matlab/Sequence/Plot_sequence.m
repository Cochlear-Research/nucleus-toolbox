function u = Plot_sequence(seq, title_str, channels)

% Plot_sequence: Plot a cell array of sequences.
% Plots a sequence as one vertical line segment per pulse, 
% with height proportional to magnitude.
% If a cell array of sequences is given, they are displayed one at a time.
%
% User interface:
% - Zoom is controlled by mouse click and drag.
% - Display menu:
%   - Backward Control-",":  display previous sequence
%   - Forward  Control-".": display next sequence
%
% u = Plot_sequence(seq, title_str, channels)
%
% seq:       A sequence or cell array of sequences
% title_str: A string or cell array of strings, used as the window title(s).
% channels:  A vector containing the lowest & highest channel numbers to be displayed.
%              Defaults to the min and max channel numbers present in the sequence(s).
% u:         Figure data struct.
%
% A script can select the sequence to display as follows:
% u = Plot_sequence({q1, q2, q3});
% u.Set_cell_index(u, 3); % Select 3rd sequence

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
    
	if nargin < 2
		title_str = 'Sequence';
	end
	u.title_str = Init_title_strings(title_str, u.num_seqs);
	
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
	
	if (u.max_time > 5000)
		time_scale = 1000;
		time_label = 'Time (ms)';
	else
		time_scale = 1;
		time_label = 'Time (us)';
	end

	u.h_figure = figure('Visible', 'off');
	u.h_axes   = axes;
	
	yticks = u.min_channel:u.max_channel;
	set(gca, 'YTick', yticks);
	set(gca, 'TickDir', 'out');
	ylabel('Channel');
	if ~is_channels
		set(gca,'YTickLabel', 23 - yticks);
		ylabel('Electrode');
	end
	u.y_scale = 0.75;
	for n = 1:u.num_seqs
		u.h_lines(n) = Plot_sequence_as_lines(u.seqs{n}, u.max_mag/u.y_scale, time_scale);
		set(u.h_lines(n), 'Visible', 'off');
	end
	
	set(gca, 'YLim', [u.min_channel - 1 + u.y_scale, u.max_channel + 1])
	set(gca, 'XLim', [-max_period1, u.max_time]/time_scale);
    
    zoom xon;
    % zoom is incompatible with KeyPressFcn in Matlab 7.0 and later,
    % so instead create menu items with accelerator keys:
    menu1 = uimenu('Label','&Display');
	uimenu(menu1,...
		'Label',		'Backward',...
		'Callback',		{@Switch_display_callback, -1},...
		'Accelerator',	'[');
	uimenu(menu1,...
		'Label',		'Forward',...
		'Callback',		{@Switch_display_callback, +1},...
		'Accelerator',	']');
    
	u.cell_index = 1;
	Set_cell_index(u, 1);
	
	xlabel(time_label);
	set(u.h_figure, 'Visible', 'on');
	set(gca, 'Box', 'on');

    % Allow scripts to change which sequence is displayed:
    u.Set_cell_index = @Set_cell_index;
    Set_figure_data(u);
    
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
	z = NaN(size(t));
	
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Switch_display_callback(~, ~, direction)

	u = Get_figure_data;
	Set_cell_index(u, u.cell_index + direction);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Set_cell_index(u, cell_index)

	set(u.h_lines(u.cell_index), 'Visible', 'off');

	if (cell_index < 1)
		u.cell_index = u.num_seqs;
	elseif (cell_index > u.num_seqs)
		u.cell_index = 1;
	else
		u.cell_index = cell_index;
	end
	
	set(u.h_lines(u.cell_index), 'Visible', 'on');
	Window_title(u.title_str{u.cell_index});

	Set_figure_data(u);
