function GUI_sequence(seq, title, num_time_slots)

% GUI_sequence: Graphical display of stimulus sequence.
%
% GUI_sequence(seq, title, num_time_slots)
%
% seq:   Sequence struct to be displayed.
% title: Title of window (optional).
% num_time_slots: Number of time slots in the plot (optional).
%                 If you want an overview of a long sequence,
%                 set this to the number of pixels (across) you want to display.
%                 If it is omitted, then for constant-period sequences,
%                 it is set to the number of pulses,
%                 and for variable-period sequences,
%                 it is set to 8 times the number of pulses,
%                 which gives good resolution when zoomed in.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (nargin < 2)
	title = '';
end

if ischar(seq)	
	% seq is a filename:
	file_name = seq;
	seq = Read_sequence(file_name);
    if isempty(title) 
        title = file_name; 
    end
end

if isempty(title) 
    title = inputname(1); 
end
if isempty(title) 
    title = 'Sequence';   
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

num_pulses = Get_num_pulses(seq);

p = [];		% used by GUI_FTM

if isfield(seq,'channels')
	y = seq.channels;
	z = seq.magnitudes;
	max_y = max(y);
	size_y = max_y;
	p.best_freqs_Hz = 1:max_y;
	
elseif isfield(seq,'electrodes')
	y = seq.electrodes;
	idle = y == 0;
	y(idle) = 23;
	z = seq.current_levels;
	size_y = 25;
	max_y = 22;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Quantise each pulse time into a time-slot:
% Possible cases:
% No timing information
% Uniform periods_us
% Variable periods_us

if ~isfield(seq,'periods_us')
	% No timing supplied, assume uniform rate:
	seq.periods_us = 1000;
end

[pulse_times, duration] = Get_pulse_times(seq);	% microseconds

if nargin < 2
	if length(seq.periods_us) == 1
		% Uniform periods_us
		num_time_slots = num_pulses;
	else
		% Variable periods_us, need better resolution
		num_time_slots = 8 * num_pulses;
	end
end

slots_per_us = (num_time_slots - 1) / duration;
slots = 1 + round(pulse_times * slots_per_us);

g = zeros(size_y, num_time_slots);
for n = 1:num_pulses
	slot = slots(n);
	g(y(n), slot) = max(g(y(n), slot), z(n));
end

p.sample_rate_Hz = slots_per_us * 1e6;	% Hz
GUI_FTM(p, g(1:max_y,:), title);
