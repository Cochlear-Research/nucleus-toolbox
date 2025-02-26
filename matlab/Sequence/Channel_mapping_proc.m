function q = Channel_mapping_proc(p, cseq)

% Map a Channel-Magnitude sequence to an Electrode-Current_level sequence.
%
% Args:
%   p:        A parameter struct, with the following fields:
%   p.electrodes:       The electrode number of each channel (column vector).
%   p.modes:            The stimulation mode (scalar).
%   p.lower_levels:     The lower current level of each channel (column vector)
%                       (typically related to the threshold level).
%   p.upper_levels:     The upper current level of each channel (column vector)
%                       (typically related to the maximum comfortable level).
%   p.phase_width_us:   The phase width in microseconds (scalar).
%   p.phase_gap_us:		The phase gap in microseconds (scalar).
%   p.period_us:        The frame period in microseconds (scalar).
%   cseq:     Channel-Magnitude sequence (struct).
%
% Returns:
%   q:		  Electrode-Current_level sequence (struct).
%
% The vector parameters (electrodes, lower_levels, upper_levels)
% must be provided in order of increasing frequency.
%
% Idle pulses (power-up frames) can be indicated by
% magnitudes less than zero, and produce zero current level.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch nargin

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 0	% Default parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	q = feval(mfilename, struct);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 1	% Parameter calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	MODE = Implant_modes;

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Defaults:

    % Pulse timing parameters:
	p = Ensure_implant_params(p);
    p = Ensure_field(p, 'period_us',        70.0);
    p = Ensure_field(p, 'phase_width_us',   25.0);
    p = Ensure_field(p, 'phase_gap_us',      7.0);

    % Checks are written so that NaNs produce errors:
    if ~(p.phase_width_us >= p.min_phase_width_us)
	    error('Nucleus:Channel_mapping', 'Phase width too short.');
    end
    if ~(p.phase_gap_us >= p.min_phase_gap_us)
	    error('Nucleus:Channel_mapping', 'Phase gap too short.');
    end
    if ~(p.period_us >= (2 * p.phase_width_us + p.phase_gap_us + p.MIN_SHORT_GAP_us))
	    error('Nucleus:Channel_mapping', 'Frame period too short.');
    end

    % Electrodes and current levels:
    p = Ensure_electrodes(p);
	p = Ensure_field(p,'modes',				MODE.MP1_2);
    if length(p.modes) > 1
		error('Only constant mode is supported');
    end

	p = Ensure_field(p,'lower_levels',	ones(p.num_bands, 1));
	p = Ensure_field(p,'upper_levels',	repmat(100, p.num_bands, 1));

    p.lower_levels = p.lower_levels(:);  % Ensure that it is a column vector.
    p.upper_levels = p.upper_levels(:);  % Ensure that it is a column vector.

    if length(p.lower_levels) ~= p.num_bands
        error('Nucleus:Channel_mapping', 'lower_levels must have same length as electrodes.')
    end
    if length(p.upper_levels) ~= p.num_bands
        error('Nucleus:Channel_mapping', 'upper_levels must have same length as electrodes.')
    end
    % Check for out of range levels.
    if ~all(p.upper_levels <= 255)
        error('Nucleus:Channel_mapping', 'upper_levels too high.');
    end
    if ~all(p.lower_levels >= 0)
        error('Nucleus:Channel_mapping', 'lower_levels negative.');
    end 
    if ~all(p.upper_levels >= p.lower_levels)
		error('Nucleus:Channel_mapping', 'Lower level exceeds upper level');
    end

	p = Ensure_field(p, 'full_scale',  		    1.0);
	p = Ensure_field(p, 'volume',			    100);
	p = Ensure_field(p, 'volume_type',		'standard');
    
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	q = p;	% Return parameters.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 2	% Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	if ~all(cseq.channels > 0) || ~all(cseq.channels <= p.num_bands)
		error('Nucleus:Channel_mapping', 'Channel number out of range');
	end

	% Create the fields in the order we like to show them in Disp_sequence:

	q.electrodes	= p.electrodes(cseq.channels);
	q.modes			= p.modes;					% Constant mode.

	% Current level:

	volume			= p.volume/100;
	ranges			= p.upper_levels - p.lower_levels;

	q_magnitudes	= cseq.magnitudes / p.full_scale;
	q_magnitudes	= min(q_magnitudes, 1.0);

	q_t = p.lower_levels(cseq.channels);
	q_r = ranges(cseq.channels);

	switch (p.volume_type)

		case 'standard'
			q.current_levels = round(q_t + q_r .* volume .* q_magnitudes);

		case 'constant range'
			q.current_levels = round(q_t + q_r .* (q_magnitudes + volume - 1));

		otherwise
			error('Nucleus:Channel_mapping', 'Bad volume_type');
	end

	% Idle pulses can be marked by magnitudes less than zero:
	is_idle_mag = (q_magnitudes < 0);		    % logical vector
	% The current levels calculated above do not apply for idle pulses,
	% set idle pulses current level to zero:
	q.current_levels(is_idle_mag)	= 0;

	q.phase_widths_us	= p.phase_width_us;		% Constant phase width.
	q.phase_gaps_us		= p.phase_gap_us;		% Constant phase gap.
	q.periods_us		= cseq.periods_us;		% Copy periods_us.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
