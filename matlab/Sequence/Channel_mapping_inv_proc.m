function qc = Channel_mapping_inv_proc(p, qe)

% Channel_mapping_inv_proc: Convert a pulse sequence back to a channel-magnitude sequence. 
%
% qc = Channel_mapping_inv_proc(p, qe)
%
% p:        client map (parameter struct).
% qe:		pulse sequence.
% qc:       channel-magnitude sequence.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson, Herbert Mauch
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch nargin

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 0	% Default parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	qc = feval(mfilename, []);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 1	% Parameter calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	p = Channel_mapping_proc(p);
	    
	qc = p;	% return parameters
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 2	% Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	% Create the fields in the order we like to show them in Disp_sequence.
	
    % Append idle info:
	electrodes		= [p.electrodes;	0];
	lower_levels	= [p.lower_levels;	0];
	upper_levels    = [p.upper_levels;	1];
    
	% Channels:
	
	% Electrodes outside of the range (1, 22) are treated as idle pulses:
 	idle_pulses = ~((qe.electrodes >= 1) & (qe.electrodes <= 22));
	% Temporarily map idles to idle channel,
	% so that we can look up a temporary T & C:
	qe.electrodes(idle_pulses) = electrodes(end);
	
    % Electrode to channel allocation
    
    for n = 1:length(qe.electrodes)
       qc.channels(n,1) = find(electrodes == qe.electrodes(n));
    end
    
	% Magnitude:

	volume	 = p.volume/100;
	p_ranges = upper_levels - lower_levels;

	q_t = lower_levels(qc.channels);
	q_r = p_ranges(qc.channels);
	
	switch (p.volume_type)

		case 'standard'	
			qc.magnitudes = (qe.current_levels - q_t) ./ (q_r .* volume);

		case 'constant range'
			qc.magnitudes = ((qe.current_levels - q_t) ./ q_r) + (1 - volume);

		otherwise
			error('Bad volume_type');
	end

	qc.magnitudes = p.full_scale * qc.magnitudes;

	qc.channels  (idle_pulses) = 0;
	qc.magnitudes(idle_pulses) = 0;

	qc.periods_us = qe.periods_us;
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
