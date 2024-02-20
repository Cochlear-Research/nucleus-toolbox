function Plot_waveforms(varargin)

% Plot_waveforms: Line plot of a waveform matrix.
%
% Plot_waveforms(c, p, title_str, time_grid)
%
% c:         Waveform matrix, or cell array of waveform matrices. Each column is one signal.
% p:         Parameter struct for each waveform matrix, with fields:
% p.tick_duration: Sampling time or resolution (in microseconds).
% p.y_label
% title_str: A string or cell array of strings, used as the window title(s).
% time_grid: Optional time grid (in microseconds), drawn as vertical lines.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ischar(varargin{1})
	feval(varargin{:});		% Callbacks
	return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

u = [];

c = varargin{1};
if iscell(c)		
	u.data = c;
else
	u.data = {c};
end
u.num_data = length(u.data);

if nargin < 2
	p = struct;
else
	p = varargin{2};
end
if isstruct(p)		
	p = repmat({p}, u.num_data, 1);
end

if nargin < 3
	title_str = 'Waveform';
else
	title_str = varargin{3};
end
u.title_str = Init_title_strings(title_str, u.num_data);

u.h_figure = figure;
hold on;

for k = 1:u.num_data

	[num_samples(k), num_channels(k)] = size(u.data{k});
	
	if isfield(p{k}, 'signal_names')
		u.data{k} = fliplr(u.data{k});
	end
	p{k} = Ensure_field(p{k}, 'scale', 2);
	p{k} = Ensure_field(p{k}, 'y_label', '');
	p{k} = Ensure_field(p{k}, 'plot_type', 'stair');

	max_c = max(max(abs(u.data{k})));
	u.data{k} = u.data{k} / (p{k}.scale * max_c);
	min_plot_data(k) = min(u.data{k}(:));
	offset_vec = 1:num_channels(k);
	offset_mat = repmat(offset_vec, num_samples(k), 1);
	plot_data  = u.data{k} + offset_mat;

	n = 0:(num_samples(k)-1);
	p{k} = Ensure_field(p{k}, 'tick_duration', 1);
	t = n * p{k}.tick_duration;
	u.duration(k) = num_samples(k) * p{k}.tick_duration;

	switch p{k}.plot_type
	case 'stair'
		u.h_lines{k} = stairs(t, plot_data, 'b');
	case 'line'
		u.h_lines{k} = plot  (t, plot_data, 'b');
	end	
	set(u.h_lines{k}, 'Visible', 'off');
end

max_duration = max(u.duration);
set(gca, 'XLim', [0, max_duration]);
max_num_channels = max(num_channels);
global_min_plot_data = min(min_plot_data);
if ~isfield(p{1}, 'ymin')
	if global_min_plot_data < 0
		p{1}.ymin = 0;
	else
		p{1}.ymin = 1;
	end
end
set(gca, 'YLim', [p{1}.ymin, max_num_channels + 1]);
set(gca, 'YTick', 1:max_num_channels);
set(gca, 'TickDir', 'out');

if isfield(p{1}, 'signal_names')
	set(gca, 'YTickLabel', fliplr(p{1}.signal_names));
elseif isequal(p{1}.y_label, 'electrode')
	set(gca, 'YTickLabel', max_num_channels:-1:1);
end

if nargin >= 4
	
	% Show time grid as vertical lines.
	% All the vertical lines are plotted as one "line" handle.
	% This is much faster than a separate handle for each line.
	% NaNs are used to separate the line segments.
	
	time_grid = varargin{4};
	e = 0:time_grid:max_duration;			% row vector
	z = repmat(NaN, size(e));				% row vector, same size as e.
	x = [e; e; z];							% 3 rows
	x = x(:);								% column vector
	
	y = [0; max_num_channels+1; NaN];		% column vector
	y = repmat(y, 1, length(e));			% 3 rows
	y = y(:);								% column vector
	
	u.h_grid = line(x, y,'Color', 'c');
	set(u.h_grid, 'visible', 'off');
	
	% Change the order of the children, so that the grid is sent to the back:
	children = get(gca, 'Children');
	set(gca, 'Children', flipud(children));
	
%	menu1 = uimenu('Label','Time Grid', 'Callback', Callback_string('g'));
end

zoom xon;
% zoom is incompatible with KeyPressFcn in Matlab 7.0 and later,
% so instead create menu items with accelerator keys:
menu1 = uimenu('Label','&Display');
uimenu(menu1,...
    'Label',		'Backward',...
    'Callback',		{@Switch_display_callback, -1},...
    'Accelerator',	','); % <
uimenu(menu1,...
    'Label',		'Forward',...
    'Callback',		{@Switch_display_callback, +1},...
    'Accelerator',	'.'); % >

u.cell_index = 1;
Set_cell_index(u, 1);

Set_figure_data(u);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Switch_display_callback(hObject, eventdata, direction)

	u = Get_figure_data;
	Set_cell_index(u, u.cell_index + direction);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Set_cell_index(u, cell_index)

	set(u.h_lines{u.cell_index}, 'Visible', 'off');

	if (cell_index < 1)
		u.cell_index = u.num_data;
	elseif (cell_index > u.num_data)
		u.cell_index = 1;
	else
		u.cell_index = cell_index;
	end
	
	set(u.h_lines{u.cell_index}, 'Visible', 'on');
	Window_title(u.title_str{u.cell_index});

	set(u.h_figure, 'UserData', u);
