function uA = Current_level_to_microamps_proc(p, cl)

% Current_level_to_microamps_proc: Convert current level to microamps.
% NaN values represent absent pulses, i.e. current = 0 uA.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch nargin

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 0  % Default parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    uA = feval(mfilename, []);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 1  % Parameter calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	p = Ensure_implant_params(p);
    p = Ensure_field(p, 'keep_nans', 0);

    uA = p;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 2  % Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Check that current levels are within bounds.
    % Note that NaNs do not cause an error.

    if any(cl > p.MAX_CURRENT_LEVEL)
        error('Current level too high.');
    elseif any(cl < 0)
        error('Current level negative.');
    end

    uA = p.MIN_CURRENT_uA * (p.CURRENT_BASE .^ (cl/p.MAX_CURRENT_LEVEL));
    uA(cl == 0) = p.CL0_uA;

    if ~p.keep_nans
        % Special case for absent pulses:
        empty = isnan(cl);
        uA(empty) = 0;
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
