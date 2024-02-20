function [v, sat, sub] = LGF_proc(p, u)

% LGF_proc: Loudness Growth Function
% function [v, sat, sub] = LGF_proc(p, u)
%
% Inputs:
% p:            Parameter struct, with the following "clinical" fields:
% p.dynamic_range_dB: Input dynamic range (in dB) 
% p.Q:            Percentage decrease of output when input is 10 dB below sat_level.
% p.sat_level:    Saturation level, input value which maps to 1.
% p.sub_mag:      Output value used for inputs below lower end of dynamic range.
% u:            Input magnitude vector or FTM.
%
% Outputs:
% v:            Magnitude in range 0:1 (proportion of output dynamic range).
% sat:          Logical FTM indicating the samples that were above sat_level.
% sub:          Logical FTM indicating the samples that were below base_level.

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

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Defaults:

	p = Ensure_field(p, 'sat_level',            1.0);
	p = Ensure_field(p, 'dynamic_range_dB',     40);
	p = Ensure_field(p, 'Q',                    20);
	p = Ensure_field(p, 'sub_mag',              -1e-10);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Derived parameters:

    p.base_level = p.sat_level / From_dB(p.dynamic_range_dB);
	p.lgf_alpha	= LGF_alpha(p.Q, p.base_level, p.sat_level);	
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	v = p;	% Return parameters.	
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 2	% Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	% Scale the input between base_level and sat_level:
	r = (u - p.base_level)/(p.sat_level - p.base_level);

	% Find all the inputs that are above sat_level (i.e. r > 1) 
	% and move them down to sat_level:
	sat = r > 1;		% This is a logical matrix, same size as r. 
	r(sat) = 1;

	% Find all the inputs that are below base_level (i.e. r < 0) 
	% and temporarily move them up to base_level:
	sub = r < 0;		% This is a logical matrix, same size as r.
	r(sub) = 0;

	% Logarithmic compression:
	v = log(1 + p.lgf_alpha * r) / log(1 + p.lgf_alpha);

	% Handle values that were below base_level:
	v(sub) = p.sub_mag;
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

