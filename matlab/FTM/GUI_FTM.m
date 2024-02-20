function u = GUI_FTM(p, m, title_str)

% GUI_FTM: GUI to display a Frequency Time Matrix (FTM).
%
% u = GUI_FTM(p, m, title_str)
%
% p:             Parameter struct with the following fields:
% p.sample_rate_Hz:   Time axis sampling frequency.
% p.best_freqs_Hz:    Labels for frequency axis.
% p.display_freq_slice: Display a frequency-slice at the selected time.
% p.display_time_slice: Display a time-slice at the selected frequency.
% m:             FTM to be displayed. Can contain negative or complex values.
%                Can also be a cell array of FTMs.
% title_str:     Window title string.
%
% u:             struct containing fields from struct p, graphics handles, 
%                  and function handles for scripting.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is also used as a callback,
% in which case the argument is a string that specifies the action.

if ischar(p)

	if isequal(p, 'KeyPress')	
        % Perform different actions depending on which key was pressed:
        Do_action(get(gcbf, 'CurrentCharacter'));
    else
        Do_action(p);
    end
    
    % The figure data does not need to be returned
    % when this function is used for callback
    return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GUI initialisation:

% If title_str, not specified, use input variable name.
if ~exist('title_str', 'var')
	title_str = inputname(2);
end

u = Examine_FTM(p, m, title_str);

u = Ensure_field(u, 'display_freq_slice',  0);
u = Ensure_field(u, 'display_time_slice',  0);
u = Ensure_field(u, 'num_movie_frames',   50);

% Initialise cell array for audio reconstruction:
u.audio = cell(u.num_FTMs, 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create the figure:

u.figure = figure;
set(u.figure, 'Color', 'white');	% Makes plot redraws look better.
set(u.figure, 'PaperPositionMode', 'auto');	% Copy & print at screen size

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create the image:

u.cell_index = 1;

u.image = image(max(0,real(u.data{u.cell_index})),'CDataMapping','scaled');
set(u.image, 'Tag', 'env');
u.image_axes = gca;
set(u.image_axes, 'TickDir', 'out', ...
				  'YDir',     u.y_dir,...
				  'CLim', [0, u.overall_max_mag]); % Same scale for all FTMs.

	% Draw "cross-hairs" on image:
u.time_hair = line('Color', 'white');
u.freq_hair = line('Color', 'white');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot magnitude at one frequency as a function of time:

u.time_axes = axes( ...
	'Layer', 	'top', ...
	'YLim', 	[0, u.overall_max_mag], ...
	'YLimMode',	'manual');

u.time_imag  = line('Color', 'green');
u.time_real  = line('Color', 'red');
u.time_env   = line('Color', 'black');
u.time_lines = [u.time_imag, u.time_real, u.time_env];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot magnitude at one time as a function of frequency:
% (Plot is turned on its side)

u.freq_axes = axes( ...
	'XLim', 	[0, u.overall_max_mag], ...
	'XLimMode',	'manual', ...
	'YLim', 	[1, u.max_freq_index], ...
	'YLimMode',	'manual', ...
	'YDir',    	u.y_dir);

u.freq_real  = line('Color', 'red');
u.freq_imag  = line('Color', 'green');
u.freq_env   = line('Color', 'black');
u.freq_lines = [u.freq_imag, u.freq_real, u.freq_env];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Handles and properties used in managing "visibility":

u.time_freq_lines = [u.time_lines, u.freq_lines];

u.visible_real = 'on';
u.visible_imag = 'off';
u.visible_env  = 'off';
u.visible_hair = 'off';

u.image_xlabel = get(u.image_axes, 'XLabel');
u.image_ylabel = get(u.image_axes, 'YLabel');
u.time_xlabel  = get(u.time_axes,  'XLabel');
u.freq_ylabel  = get(u.freq_axes,  'YLabel');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set up callback functions:

set(u.figure, 		'KeyPressFcn',   Callback_string('KeyPress'));
set(u.figure, 		'ResizeFcn',     Callback_string('Resize'));

set(u.image, 		'ButtonDownFcn', Callback_string('ImageClick'));
set(u.time_hair,	'ButtonDownFcn', Callback_string('ImageClick'));
set(u.freq_hair, 	'ButtonDownFcn', Callback_string('ImageClick'));

set(u.time_axes,	'ButtonDownFcn', Callback_string('TimeClick'));
set(u.time_real,	'ButtonDownFcn', Callback_string('TimeClick'));
set(u.time_imag,	'ButtonDownFcn', Callback_string('TimeClick'));
set(u.time_env,		'ButtonDownFcn', Callback_string('TimeClick'));

set(u.freq_axes,	'ButtonDownFcn', Callback_string('FreqClick'));
set(u.freq_real,	'ButtonDownFcn', Callback_string('FreqClick'));
set(u.freq_imag,	'ButtonDownFcn', Callback_string('FreqClick'));
set(u.freq_env, 	'ButtonDownFcn', Callback_string('FreqClick'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create a menu:
menu1 = uimenu('Label','&Axes');
Create_menu_item(menu1,'Pan Left',        '1');
Create_menu_item(menu1,'Pan Right',       '2');
Create_menu_item(menu1,'Pan Up',          '3');
Create_menu_item(menu1,'Pan Down',        '4');
Create_menu_item(menu1,'Zoom In',         '5');
Create_menu_item(menu1,'Zoom Out',        '6');
Create_menu_item(menu1,'Zoom Reset',      '7');

menu2 = uimenu('Label','&Display');
Create_menu_item(menu2,'Backward',         '[');
Create_menu_item(menu2,'Forward',          ']');
Create_menu_item(menu2,'Toggle Image',     'G');
Create_menu_item(menu2,'Toggle Crosshairs','C');
Create_menu_item(menu2,'Toggle Negative',  'N');
Create_menu_item(menu2,'Toggle Envelope',  'E');
Create_menu_item(menu2,'Toggle Real',      'R');
Create_menu_item(menu2,'Toggle Imaginary', 'I');
Create_menu_item(menu2,'Toggle Freq Slice','F');
Create_menu_item(menu2,'Toggle Time Slice','T');
Create_menu_item(menu2,'Toggle Markers',   'K');

menu3 = uimenu('Label','&Audio');
Create_menu_item(menu3,'Play Reconstructed Audio', 'A');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Save function handles for scriptability:

u.Set_cell_index = @Set_cell_index;

u.Set_time       = @Set_time;
u.Set_time_index = @Set_time_index;
u.Set_time_axis  = @Set_time_axis;

u.Set_freq_index = @Set_freq_index;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Save data into the figure's UserData field for easy retrieval:

u.time_index = 1;
u.freq_index = 1;
Set_figure_data(u);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialise display:

Resize;
Do_action('Zoom Reset');
Set_time(u.duration/2);
Set_cell_index(1);
u = Get_figure_data;
return;		% Finished GUI creation

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A convenience function to save awkward quoting when setting up the callbacks:

function s = Callback_string(action_string)
	s = [mfilename, '(''', action_string, ''')'];
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sets callback string to be same as the label.

function Create_menu_item(menu, label, key)

	uimenu(menu,...
		'Label',		label,...
		'Callback',		Callback_string(label),...
		'Accelerator',	key);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GUI callbacks
% This sub-function is executed when the function is called with a string argument.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Do_action(command_str)

	u = Get_figure_data;

	switch (command_str)

		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

		case 'ImageClick'		% Callback for clicking on image

			point = get(u.image_axes, 'CurrentPoint');	
			Set_time      (point(1,1));
			Set_freq_index(point(1,2));

		case 'TimeClick'		% Callback for clicking on time domain plot

			point = get(u.time_axes, 'CurrentPoint');
			Set_time(point(1,1));

		case 'FreqClick'		% Callback for clicking on freq domain plot

			point = get(u.freq_axes, 'CurrentPoint');
			Set_freq_index(point(1,2));

		case 'Resize'			% Callback for figure resize.

			Resize;

		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		% Axes modifications:

		case {'Pan Left',	'1'} 
			Set_time_index(u.time_index - 1);

		case {'Pan Right',	'2'}
			Set_time_index(u.time_index + 1);

		case {'Pan Up',		'3'}
			Set_freq_index(u.freq_index - 1);

		case {'Pan Down',	'4'} 
			Set_freq_index(u.freq_index + 1);

		case {'Zoom In',	'5'}
			old_time_diff = diff(get(u.time_axes, 'XLim'));
			new_time_diff = old_time_diff/2;			
			time = Get_time;
			Set_time_axis([time - new_time_diff/2, time + new_time_diff/2]);

		case {'Zoom Out',	'6'}
			old_time_diff = diff(get(u.time_axes, 'XLim'));
			new_time_diff = old_time_diff * 2;			
			time = Get_time;
			Set_time_axis([time - new_time_diff/2, time + new_time_diff/2]);

		case {'Zoom Reset',	'7', ' '} 
			Set_time_axis([0, u.duration]);

		case {'Toggle Freq Slice', 'f'}
			u.display_freq_slice = ~u.display_freq_slice;
			Set_figure_data(u);
			Resize;

		case {'Toggle Time Slice', 't'}
			u.display_time_slice = ~u.display_time_slice;
			Set_figure_data(u);
			Resize;

		case {'Toggle Markers', 'k'}
			marker = get(u.time_real, 'Marker');
			if isequal(marker, '.')
				marker = 'none';
				style  = '-';
			else
				marker = '.';
				style  = 'none';
			end
			set(u.time_freq_lines, 'Marker',    marker,	...
								   'LineStyle', style);

		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		% Which cell to display:

		case {'Backward', '['}
			Set_cell_index(u.cell_index - 1);

		case {'Forward',  ']'}
			Set_cell_index(u.cell_index + 1);

		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		% Data components to display on image:

		case {'Toggle Image', 'g'}
			switch (get(u.image, 'Tag'))
				case 'real'
					set(u.image, 'Tag', 'env');
				case 'env'
					set(u.image, 'Tag', 'real');
			end
			Refresh_image;

		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		% Data components to display on graphs:

		case {'Toggle Negative', 'n'}			% Toggle graphs between showing +/- and only +. 
			mag_lim = get(u.time_axes,  'YLim');
			if (mag_lim(1) == 0)
				mag_lim(1) = -mag_lim(2);
			else
				mag_lim(1) = 0;
			end
			set(u.time_axes,  'YLim', mag_lim);
			set(u.freq_axes,  'XLim', mag_lim);

		case {'Toggle Envelope', 'e'}
			u.visible_env = Toggle_on_off(u.visible_env);
			Set_figure_data(u);
			Update_visibility;

		case {'Toggle Real', 'r'}
			u.visible_real = Toggle_on_off(u.visible_real);
			Set_figure_data(u);
			Update_visibility;

		case {'Toggle Imaginary', 'i'}
			u.visible_imag = Toggle_on_off(u.visible_imag);
			Set_figure_data(u);
			Update_visibility;

		case {'Toggle Crosshairs', 'c'}
			u.visible_hair = Toggle_on_off(u.visible_hair);
			Set_figure_data(u);
			Update_visibility;

		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		% Audio:

		case {'Play Reconstructed Audio', 'a'}
			Play_sound(u);
	end
		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Resize
	
	u = Get_figure_data;
	
	set(u.figure,     'Units', 	'pixels');
	set(u.image_axes, 'Units', 	'pixels');
	set(u.time_axes,  'Units', 	'pixels');
	set(u.freq_axes,  'Units', 	'pixels');

	position = get(u.figure, 'position');
	fig_W = position(3);
	fig_H = position(4);

	tick_W  = 50;			% Wide enough for 4 characters e.g."8000"
	tick_H  = 30;			% High enough for 1 line of characters.
	label_W = 20;			% Wide enough for 1 line of characters.
	label_H = 20;			% High enough for 1 line of characters.
	gap_TR  = 20;			% Border at top and right (no characters).

	freq_W	= round(0.30 * fig_W);
	time_H	= round(0.30 * fig_H);
	
	freq_L  = tick_W + label_W;
	time_B  = tick_H + label_H;

	if (u.display_freq_slice)
		image_L = freq_L + freq_W + tick_W;		
	else
		image_L = freq_L;
	end

	if (u.display_time_slice)
		image_B = time_B + time_H + tick_H;
	else	
		image_B = time_B;
	end

	image_W = fig_W - image_L - gap_TR;	
	image_H = fig_H - image_B - gap_TR;

		%				          [left     bottom   width    height]
		
	set(u.time_axes,  'Position', [image_L  time_B   image_W  time_H  ]);
	set(u.freq_axes,  'Position', [freq_L   image_B  freq_W   image_H ]);
	set(u.image_axes, 'Position', [image_L  image_B  image_W  image_H ]);

	% As the image resizes, Matlab automatically adjusts the ticks.
	% Copy these ticks to the freq graph
	
	freq_index_ticks = get(u.image_axes,'YTick');
    if length(freq_index_ticks) > u.num_bands
        % Can occur when there are not many bands:
        freq_index_ticks = 1:u.num_bands;
        set(u.image_axes, 'YTick', 1:u.num_bands);
    end
	set(u.freq_axes,'YTick', freq_index_ticks);
	
	freq_tick_labels = round(u.freq_labels(freq_index_ticks));
	
	set(u.freq_axes, 'YTickLabel', freq_tick_labels);
	set(u.image_axes,'YTickLabel', freq_tick_labels);

	Update_visibility;
		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Update_visibility

	u = Get_figure_data;
	if (u.display_time_slice)
		set(u.time_axes, 'Visible', 'on');
		set(u.time_real, 'Visible', u.visible_real);
		set(u.time_imag, 'Visible', u.visible_imag);
		set(u.time_env,  'Visible', u.visible_env );
		set(u.time_hair, 'Visible', u.visible_hair );

		set(u.image_xlabel, 'String', '');
		set(u.time_xlabel,  'String', u.time_label_string);
	else
		set([u.time_axes, u.time_real, u.time_imag, u.time_env, u.time_hair], 'Visible', 'off');

		set(u.image_xlabel, 'String', u.time_label_string);
		set(u.time_xlabel,  'String', '');
	end
	if (u.display_freq_slice)
		set(u.freq_axes, 'Visible', 'on');
		set(u.freq_real, 'Visible', u.visible_real);
		set(u.freq_imag, 'Visible', u.visible_imag);
		set(u.freq_env,  'Visible', u.visible_env );
		set(u.freq_hair, 'Visible', u.visible_hair);

		set(u.image_ylabel, 'String', '');
		set(u.freq_ylabel,  'String', u.freq_label_string);
	else
		set([u.freq_axes, u.freq_real, u.freq_imag, u.freq_env, u.freq_hair], 'Visible', 'off');	% Hide all of them

		set(u.image_ylabel, 'String', u.freq_label_string);
		set(u.freq_ylabel,  'String', '');
	end
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Set_cell_index(cell_index)

	u = Get_figure_data;

	time = Get_time;
	
	n = length(u.data);
	u.cell_index = cell_index;
	if (u.cell_index < 1)
		u.cell_index = n;
	elseif (u.cell_index > n)
		u.cell_index = 1;
	end
	Window_title(u.title_str{u.cell_index});
	
	Set_figure_data(u);
	Set_time(time);		% calls Refresh_freq_plots
	Refresh_image;
	Refresh_time_plots;
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the time to corresponding to u.time_index:

function time = Get_time

	u = Get_figure_data;
	time = (u.time_index - 0.5) * u.sample_time(u.cell_index);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set u.time_index as close as possible to a specified time:

function Set_time(time)

	u = Get_figure_data;
	Set_time_index(0.5 + time/u.sample_time(u.cell_index));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Set_time_index(time_index)

	u = Get_figure_data;
	u.time_index = round(time_index);
	max_time_index = size(u.data{u.cell_index}, 2);
	if u.time_index < 1
		u.time_index = max_time_index;
	elseif u.time_index > max_time_index
		u.time_index = 1;
	end
	Set_figure_data(u);
	Refresh_freq_plots;
		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Set_freq_index(freq_index)

	u = Get_figure_data;
	u.freq_index = round(freq_index);
	max_freq_index = size(u.data{u.cell_index}, 1);
	if u.freq_index < 1
		u.freq_index = max_freq_index;
	elseif u.freq_index > max_freq_index
		u.freq_index = 1;
	end	
	Set_figure_data(u);
	Refresh_time_plots;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Refresh
	
	Refresh_image;
	Refresh_time_plots;
	Refresh_freq_plots;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Refresh_image

	u = Get_figure_data;
	switch (get(u.image, 'Tag'))
	case 'env'
		set(u.image, 'CData', abs(u.data{u.cell_index}));
	case 'real'
		set(u.image, 'CData', max(0,real(u.data{u.cell_index})));
	end

	% Time scale:
	Ts = u.sample_time(u.cell_index);
	T2 = Ts/2;
	set(u.image, 'XData', [T2, u.duration - T2]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Refresh_time_plots
	
	u = Get_figure_data;

	set(u.time_real, 'YData', real(u.data{u.cell_index}(u.freq_index, :)));
	set(u.time_imag, 'YData', imag(u.data{u.cell_index}(u.freq_index, :)));
	set(u.time_env , 'YData', abs (u.data{u.cell_index}(u.freq_index, :)));

	Ts = u.sample_time(u.cell_index);
	N  = u.num_time_samples(u.cell_index);

	set(u.time_lines, 'XData', (0.5:(N-0.5)) * Ts);

	set(u.time_hair,  'XData', [0, u.duration]);
	set(u.time_hair,  'YData', [u.freq_index, u.freq_index]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Refresh_freq_plots

	u = Get_figure_data;

	set(u.freq_real,  'XData', real(u.data{u.cell_index}(:, u.time_index)));
	set(u.freq_imag,  'XData', imag(u.data{u.cell_index}(:, u.time_index)));
	set(u.freq_env ,  'XData', abs (u.data{u.cell_index}(:, u.time_index)));

	Ts = u.sample_time(u.cell_index);
	max_freq_index = size(u.data{u.cell_index}, 1);

	set(u.freq_lines, 'YData', 1:max_freq_index);

	set(u.freq_hair,  'YData', [0.5, max_freq_index+0.5]);
	set(u.freq_hair,  'XData', ([u.time_index, u.time_index] - 0.5) * Ts);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Set_time_axis(time_axis_limits)

	u = Get_figure_data;
	set(u.image_axes, 'XLim', time_axis_limits);
	set(u.time_axes,  'XLim', time_axis_limits);
	
function Set_time_axis_old

	time_limits	= time_index_limits * u.Ts;	% Convert index to milliseconds.
	time_range	= diff(time_limits);	
	time_delta	= 10 .^ floor(log10(time_range));	% Find appropriate power of 10.
	num_ticks	= time_range/time_delta;			% Ensure at least 3 ticks.
	if (num_ticks < 3)
		time_delta = time_delta / 2;
	end
	
	max_time	= u.max_time_index * u.Ts;
	time_ticks	= 0:time_delta:max_time;
	time_index_ticks = 1 + (time_ticks / u.Ts);
	
	set(u.time_axes, 'XTick',      time_index_ticks);
	set(u.image_axes,'XTick',      time_index_ticks);

	set(u.time_axes, 'XTickLabel', time_ticks);
	set(u.image_axes,'XTickLabel', time_ticks);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Play_sound(u)

	if isempty(u.audio{u.cell_index})
		u.audio{u.cell_index} = Sound_simulate(u, u.data{u.cell_index});
	end
	soundsc(u.audio{u.cell_index}, u.audio_sample_rate_Hz);
    Set_figure_data(u);
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function s = Toggle_on_off(s)
	switch (s)
		case 'on'
			s = 'off';
		case 'off'
			s = 'on';
	end
