function q = Collate_into_sequence_proc(p, magnitude_ftm)

% Construct a universal sequence from a magnitude FTM.
%
% Args:
%   p:              A parameter struct, with the following fields:
%   p.num_bands:            Number of bands (channels).
%   p.num_selected:         Number of pulses per epoch.
%   p.epoch_us:				Epoch duration, in microseconds.
%   p.period_us:            Frame period, in microseconds.
%   p.channel_order_type:   String specifying frequency (channel) order:
%
%                           - 'base_to_apex': High to low frequencies
%                             (default)
%                           - 'apex_to_base': Low to high frequencies
%   magnitude_ftm:	Envelope FTM.
%                   NaN magnitudes represent skipped pulses,
%                   for example as produced by Reject_largest_proc.
%					Negative magnitudes are passed through unchanged,
%					and will be converted to idle pulses by
%					Channel_mapping_proc.
%
% Returns:
%   q:              Universal sequence struct.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch nargin

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 0	% Default parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	q = feval(mfilename, []);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 1	% Parameter calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Defaults:

	p = Ensure_field(p, 'num_bands', 22);
	p = Ensure_field(p, 'num_selected', p.num_bands);
	p = Ensure_field(p, 'period_us', 100);
	p = Ensure_field(p, 'epoch_us', p.period_us * p.num_selected);
	p = Ensure_field(p, 'channel_order_type', 'base_to_apex');

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Derived parameters:

	switch p.channel_order_type
		case 'base_to_apex'		% High to low frequencies
			p.channel_order	= (p.num_bands:-1:1)';
		case 'apex_to_base'		% Low to high frequencies
			p.channel_order	= (1:p.num_bands)';
		otherwise
			error('Only base_to_apex or apex_to_base implemented');
	end

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	q = p;	% Return parameters.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 2	% Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	[num_bands, num_epochs] = size(magnitude_ftm);
    assert(num_bands == p.num_bands)

	q.channels = repmat(p.channel_order, num_epochs, 1);

	reord_magnitude_ftm = magnitude_ftm(p.channel_order, :); % Re-order the channels (rows).
	is_pulse = isfinite(reord_magnitude_ftm);		% Determine locations of pulses.
	num_selected = sum(is_pulse);	% Number of selected pulses in each epoch.
	if ~all(num_selected == p.num_selected)
		error('Nucleus:Collate_into_sequence:num_selected', 'Unexpected number of pulses in epoch.')
	end
		
	q.magnitudes = reord_magnitude_ftm(:);					% Concatenate columns.
	skip = ~isfinite(q.magnitudes);
	q.channels  (skip) = [];
	q.magnitudes(skip) = [];

	% Construct period vector (same for all epochs):
	periods_us_vec = repmat(p.period_us, p.num_selected, 1);
	epoch_us = sum(periods_us_vec);
	excess_us = p.epoch_us - epoch_us;
	if excess_us == 0
		q.periods_us = p.period_us;		% Scalar indicates constant period for all pulses.
	elseif excess_us > 0
		% Adjust last period in each epoch:
		periods_us_vec(end) = periods_us_vec(end) + excess_us;
		q.periods_us = repmat(periods_us_vec, num_epochs, 1);
	else
		error('Nucleus:Collate_into_sequence:epoch', 'Pulses do not fit into epoch.')
	end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
