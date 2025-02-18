function cl = Microamps_to_current_level_proc(p, uA)

% Microamps_to_current_level_proc: Convert microamps to current level.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch nargin

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 0  % Default parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    cl = feval(mfilename, struct);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 1  % Parameter calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	p = Ensure_implant_params(p);
    p = Ensure_field(p, 'keep_nans', 0);

    cl = p;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 2  % Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Check that current levels are within bounds.
    % Note that NaNs do not cause an error.

    if any(uA > p.MAX_CURRENT_uA)
        error('Nucleus:Microamps_to_current_level_proc', 'Current too high.');
    end

    ratio = uA / p.MIN_CURRENT_uA;
    cl = p.MAX_CURRENT_LEVEL * log(ratio) / log(p.CURRENT_BASE);
    cl = round(cl);

    if isequal(p.chip, 'CIC4')
        cl(uA == 0) = 0;
    end

    if any(cl < 0)
        error('Nucleus:Microamps_to_current_level_proc', 'Current too low.');
    end

    if ~p.keep_nans
        % Special case for absent pulses:
        empty = isnan(uA);
        cl(empty) = 0;
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
