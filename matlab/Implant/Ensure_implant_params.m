function p = Ensure_implant_params(p)

% Ensure_implant_params: Ensure implant parameters are valid.
%
% p_out = Ensure_implant_params(p_in)
%
% p_in:  A struct containing the clinical parameters.
%          Any fields omitted will be set to default values.
% p_out: A struct containing the clinical and derived parameters.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin == 0
    p = struct;
end

p = Ensure_field(p, 'chip', 'CIC4');
p = Ensure_field(p, 'RF_clock_Hz', 5e6);

switch p.chip

    case 'CIC3'
        p.MIN_CURRENT_uA = 10.0;
        p.CL0_uA = p.MIN_CURRENT_uA;

    case 'CIC4'
        p.MIN_CURRENT_uA = 17.5;
        p.CL0_uA = 0.0;

    otherwise
        error('Unknown implant chip');
end

p.MAX_CURRENT_LEVEL = 255;
p.MAX_CURRENT_uA    = 1750.0;
p.CURRENT_BASE = p.MAX_CURRENT_uA / p.MIN_CURRENT_uA;

% Pulse timing parameters:
p = Ensure_field(p, 'min_phase_width_us', 25.0);
p = Ensure_field(p, 'max_phase_width_us', 400.0);
p = Ensure_field(p, 'phase_width_us', 25.0);
p = Ensure_field(p, 'phase_gap_us',    7.0);
p.MIN_SHORT_GAP_us = 12.0;