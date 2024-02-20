function q = Collate_into_sequence_proc(p, env)

% Create a Channel-Magnitude sequence from an FTM.
%
% Args:
%   p:              A parameter struct, with the following fields:
%   p.num_bands:            Number of bands (channels).
%   p.period_us:            Frame period, in microseconds.
%   p.channel_order_type:   String specifying frequency (channel) order:
%
%                           - 'base_to_apex': High to low frequencies
%                             (default)
%                           - 'apex_to_base': Low to high frequencies
%   env:            Envelope FTM.
%
% Returns:
%   q:              Channel-Magnitude sequence struct.

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
	p = Ensure_field(p, 'period_us', 100);
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

	[num_bands, num_time_slots] = size(env);
    assert(num_bands == p.num_bands)

	q.channels = repmat(p.channel_order, num_time_slots, 1);

	reord_env = env(p.channel_order, :);			% Re-order the channels (rows).
	q.magnitudes = reord_env(:);					% Concatenate columns.

	skip = ~isfinite(q.magnitudes);
	q.channels  (skip) = [];
	q.magnitudes(skip) = [];

	q.periods_us = p.period_us;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
