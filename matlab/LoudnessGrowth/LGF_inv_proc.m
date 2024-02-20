function u = LGF_inv_proc(p, v)

% LGF_inv_proc: Invert Loudness Growth Function processing
%
% u = LGF_inv_proc(p, v)
%
% p:            Parameter struct, with the following fields:
% p.Q:            Percentage decrease of output when input is 10 dB below sat_level.
% p.lgf_alpha:    Curve shape factor.
% p.base_level:   Amplitude value for magnitude = 0.
% p.sat_level:    Amplitude value for magnitude = 1.
% v:            Compressed magnitude in range 0:1 (proportion of dynamic range).
% u:            Amplitude in range base_level:sat_level.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch nargin

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 0  % Default parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    u = feval(mfilename, []);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 1  % Parameter calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    u = LGF_proc(p);  % Same parameters as forward processing.    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 2  % Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    r = ((1 + p.lgf_alpha) .^ v - 1) / p.lgf_alpha;
    u = r * (p.sat_level - p.base_level) + p.base_level;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

