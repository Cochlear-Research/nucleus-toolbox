function GUI_audio_FTM(u)

% GUI_audio_FTM: GUI to display & play an array of audio signals & corresponding FTMs.
%
% GUI_audio_FTM(u)
%
% u: struct with the following fields:
% u.audio:             An array of audio signals.
% u.audio_sample_rate_Hz: The sample rate of the audio signals.
% u.mag:               A cell array of FTMs.
%
% User interface:
% The lower pane shows a plot of the selected signal.
% The upper pane shows the corresponding FTM (e.g. spectrogram).
% Zoom in on the time-axis by clicking in the plot.
% Keyboard:
%  space	resets the time-scale.
%  P		plays the selected signal.
%  ]		select the next signal
%  [		select the previous signal
%  >		select the next signal and play it
%  <		select the previous signal and play it
%  1-9		select signal number
%  S        save the data for later display.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin == 0

	% Open a mat file that was previously created by this GUI's save function.
	
	[file_name, path_name] = uigetfile('*.mat','Open');	
	if file_name	
		load([path_name, file_name], 'u');
		GUI_audio_FTM(u);		
	end
	return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isstruct(u)

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% GUI creation
	% This section is executed when the function is called 
	% with an audio matrix.
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	% Create a struct to hold all the data.
	% Later we'll store it into the figure's UserData field.

	len = size(u.audio, 2);
	u.max_audio = max(max(abs(u.audio)));
	u.t = (0:(len-1))/u.audio_sample_rate_Hz;	% time scale for horizontal axis

	% Create figure:
	u.figure = figure;
	set(u.figure, 'KeyPressFcn',	Callback_string('KeyPress')	...
				, 'ColorMap',		hot							...
				);

	u.selection = 1;

	% We use normalised units (0.0 - 1.0) to place objects on the figure.
	% This lets the controls scale nicely if the window is resized.
	
	% Create the plot:
	% This high-level command creates an axes object 
	% and a line object which we'll access later.
	h = plot(u.t, u.audio(u.selection,:));
	u.graph = findobj(h,'Type','line');

	L = 0.10;
	B = 0.05;
	W = 1 - (2*L);
	H = 1 - (2*B);
	
	u.time_axes = gca;
		%				         		[left,bottom,width,height]
	set(u.time_axes	, 'Position',		[L,   B,     W,    H/2]	...
					, 'Units', 			'normalized'			...
					, 'ButtonDownFcn',	Callback_string('Zoom')	...
					);

	Window_title('Audio');
	xlabel('Time (seconds)');
	ylabel('Voltage');
	%		  xmin xmax         ymin             ymax
	axis([0    u.t(end)  (-u.max_audio) u.max_audio]);
		
	% Create spectrograms of each band:
	u.image_axes = axes;
	u.image = image(u.t, [0 u.audio_sample_rate_Hz/2], u.mag{u.selection},'CDataMapping','scaled');
	set(u.image_axes, 'Position', [L, B+H/2, W, H/2],...
			'Units',	'normalized',...
			'YDir', 	'normal',...
			'XTick',	[]);
	ylabel('Frequency (Hz)');

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	Set_figure_data(u);
	return;		% Finished GUI creation
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isequal(u, 'KeyPress')	
	% Perform different actions depending on which key was pressed:
	Do_action(get(gcbf, 'CurrentCharacter'));
	return;
end

if ischar(u)	
	Do_action(u);
	return;
end

error('First arg must be either parameter struct or command string');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GUI callbacks
% This sub-function is executed when the function is called with a string argument.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Do_action(command_str)

	% Retrieve audio data and band index value:
	u = Get_figure_data;

	if length(command_str) == 1
		if (command_str >= '1') && (command_str <= '9')
			Select_band(u, command_str - '0');
			return;
		end
	end

	switch (command_str)

	case {'p','P','Play'}
	
		Play_selected(u);
							
	% Select next sound:
	
	case {'-', '_', '['}
		Select_band(u, u.selection - 1);

	case {'=', '+', ']'}
		Select_band(u, u.selection + 1);

	% Select next sound and play it:
	
	case {',', '<',}
		u = Select_band(u, u.selection - 1);
		Play_selected(u);

	case {'.', '>',}
		u = Select_band(u, u.selection + 1);
		Play_selected(u);

	case ' '
		% Reset time axis:
		set(u.time_axes,  'XLim', [0 u.t(end)]);
		set(u.image_axes, 'Xlim', [0 u.t(end)]);
		
	case 'Zoom'
	
		zoom_point = get(gcbo,'CurrentPoint');
		zoom_time = zoom_point(1,1);
		
		time_limit	= get(u.time_axes, 'XLim');
		time_delta	= (time_limit(2) - time_limit(1)) / 2;
		time_delta = time_delta / 2;
		time_limit = [(zoom_time - time_delta) (zoom_time + time_delta)];
		set(u.time_axes,  'XLim', time_limit);
		set(u.image_axes, 'XLim', time_limit);

	case {'s', 'S', 'Save'}
	
		Save(u);
	end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A convenience function to save awkward quoting when setting up the callbacks:

function s = Callback_string(action_string)
	s = [mfilename, '(''', action_string, ''')'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Play_selected(u)
	u.player = audioplayer(u.audio(u.selection, :), u.audio_sample_rate_Hz);
    u.player.play();
	Set_figure_data(u);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function u = Select_band(u, value)

	u.selection	= value;
	N = length(u.mag);
	
	% Wrap around:
	if (u.selection > N)
		u.selection = 1;
	elseif (u.selection < 1)
		u.selection = N;
	end
	
	Set_figure_data(u);
	
	% Setting the YData of the existing line object
	% has a similar effect to issuing a new plot command,
	% but has the advantage that the axes properties are maintained,
	% in particular, the position of the axes and the zoom state.

	set(u.graph, 'YData', u.audio(u.selection, :));
	set(u.image, 'CData', u.mag{u.selection});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Save(u)

	[file_name, path_name] = uiputfile('*.mat','Save As');
	
	if file_name
	
		% It is not useful to save GUI fields.
%		u = Remove_field(u, 'gui');
		save([path_name, file_name], 'u');
		
	end
	