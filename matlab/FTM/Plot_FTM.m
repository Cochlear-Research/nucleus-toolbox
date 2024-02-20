function Plot_FTM(p, m, title_str)

% Plot_FTM: Line plot of a Frequency Time Matrix (FTM).
%
% Plot_FTM(p, m, title_str)
%
% p:             Parameter struct with the following fields:
% p.sample_rate_Hz:   Time axis sampling frequency.
% p.best_freqs_Hz:    Labels for frequency axis.
% m:             FTM to be displayed. Can contain negative or complex values.
% title_str:     Window title string.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This function is also used as a callback,
% in which case the argument is a string that specifies the action.

if (nargin > 1) & isstruct(p)

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% GUI creation
	% This section is executed when the function is called with an input matrix.
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	u = p;				% Copy param struct.
	
	% Append FTM into struct:
	if isempty(m)
		error('Empty data');
	end
	
	u.data = m;
		
	u = Ensure_field(u, 'sample_rate_Hz', 1);
		
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Create the figure:
	
	u.figure = figure;
	set(u.figure, 'Color', 'white');	% Makes plot redraws look better.
	set(u.figure, 'PaperPositionMode', 'auto');	% Copy & print at screen size
		
	if ~exist('title_str')
		title_str = inputname(2);
	end
	Window_title(title_str);

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Plot magnitude at each frequency as a function of time:
	
	[u.num_bands, u.num_samples] = size(u.data);
	u.max_mag = max(max(u.data));
	u.min_mag = min(min(u.data));
	if ~isreal(u.max_mag)
		u.max_mag = abs(u.max_mag);
		u.min_mag = -u.max_mag;
	end
	u.min_mag = min(u.min_mag, 0);	% no larger than 0
	
	% sample rate in Hz gives time in seconds:
	u.time_coords = (0:(u.num_samples-1)) / u.sample_rate_Hz;
	time_label = 'Time (seconds)';
	
	if u.time_coords(end) < 1
		u.time_coords = u.time_coords * 1000 ;	% in milliseconds
		time_label = 'Time (milliseconds)';
	end
	
	H = 0.8 / u.num_bands;
	
	for n = 1:u.num_bands
	
		u.time_axes(n) = axes('Position', [0.1, 0.1 + (n-1) * H, 0.8, 0.9 * H]);

		if isreal(u.data)
			u.time_real(n) = line(u.time_coords, u.data(n, :), 'Color', 'black');		
		else
			u.time_real(n) = line(u.time_coords, real(u.data(n, :)), 'Color', 'red');
			u.time_env(n)  = line(u.time_coords, abs (u.data(n, :)), 'Color', 'black');
			u.time_imag(n) = line(u.time_coords, imag(u.data(n, :)), 'Color', 'green');
		end
	end
	
	set(u.time_axes,...
		'YLim',  [u.min_mag, u.max_mag],...
		'XLim',  [u.time_coords(1), u.time_coords(end)],...
		'YTick', []);
	set(u.time_axes(2:end), 'XTick', []);

	set(u.time_axes(1), 'TickDir', 'out');
	x_label = get(u.time_axes(1),'XLabel');
	set(x_label, 'String', time_label)
	y_label = get(u.time_axes(ceil(u.num_bands/2)),'YLabel');
	set(y_label, 'String', 'Amplitude');
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Set up callback functions:

	set(u.figure, 		'KeyPressFcn',   Callback_string('KeyPress'));

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Create menus:

	if ~isreal(u.data)	
		menu2 = uimenu('Label','&Display');
		uimenu(menu2,'Label','Toggle Envelope',  'Callback',Callback_string('Menu'), 'Accelerator', 'E');
		uimenu(menu2,'Label','Toggle Real',      'Callback',Callback_string('Menu'), 'Accelerator', 'R');
		uimenu(menu2,'Label','Toggle Imaginary', 'Callback',Callback_string('Menu'), 'Accelerator', 'I');
	end
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Save data into the figure's UserData field for easy retrieval:

	set(u.figure, 'UserData', u);
	
	return;		% Finished GUI creation
end

if ~ischar(p)
	error('First arg must be either parameter struct or command string');
end
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GUI callbacks
% This section is executed when the function is called with a string argument.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

u = get(gcbf, 'UserData');

switch (p)
				
	case 'KeyPress'			% Callback for keypress.

		% Perform different actions depending on which key was pressed:
		action = get(gcbf, 'CurrentCharacter');
		Do_action(u, action);
		
	case 'Menu'				% Callback for menu items.

		% Perform different actions depending on which menu item was selected:
		action = get(gcbo, 'Label');
		Do_action(u, action);

end
		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A convenience function to save awkward quoting when setting up the callbacks:

function s = Callback_string(action_string)
	s = [mfilename, '(''', action_string, ''')'];
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Do_action(u, action)

	if ~isreal(u.data)
	
		switch (action)

			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			% Data components to display on graphs:

			case {'Toggle Envelope',	'e'}
				Toggle_visibility(u.time_env);

			case {'Toggle Real',		'r'}
				Toggle_visibility(u.time_real);

			case {'Toggle Imaginary',	'i'}
				Toggle_visibility(u.time_imag);

		end
		
	end
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Toggle_visibility(h)
	switch (get(h(1), 'Visible'))
		case 'on'
			set(h, 'Visible', 'off');
		case 'off'
			set(h, 'Visible', 'on');
	end

