function v = Reject_smallest_proc(p, v)

% Reject the smallest input magnitudes.
%
% Args:
%   p:          A parameter struct with fields:
%   p.num_bands:     The number of filter bands.
%   p.num_selected:  The number of magnitudes to keep in each column.
%   v:            Envelope FTM (magnitudes).
%
% Returns:
%   v:          An FTM (same size as input FTM),
%   with the smallest values in each column rejected,
%   by replacing them with NaN.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch nargin

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 0	% Default parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	v = feval(mfilename, []);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 1	% Parameter calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	% Set default values for parameters that are absent:
	p = Ensure_field(p, 'num_bands',  22);
	p = Ensure_field(p, 'num_selected', min(p.num_bands, 12));
	
    if (p.num_selected < 1) 
		error('Nucleus:Reject_smallest_proc',...
            'Must select at least one band');
    end
	if (p.num_selected > p.num_bands)
		error('Nucleus:Reject_smallest_proc',...
            'Number to be selected is greater than number of bands');
	end
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	v = p;	% Return parameters.	
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 2	% Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	[num_bands, num_time_slots] = size(v);
	num_rejected = num_bands - p.num_selected;

    if (num_bands ~= p.num_bands)
		error('Nucleus:Reject_smallest_proc',...
            'Unexpected number of bands');
    end

	% If we treat the input matrix v as one long column vector,
	% then the indexes of the start of each column are:
	x0 = num_bands * (0:(num_time_slots-1));

	for n = 1:num_rejected

		[~, k] = min(v);

		% k is a row vector containing the row number (channel number) 
        % of the minimum in each column.
		% If we treat the input matrix v as one long column vector,
		% then the indexes of the minima are:

		xk = x0 + k;

		v(xk) = NaN;	% Reject the smallest values.

	end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
