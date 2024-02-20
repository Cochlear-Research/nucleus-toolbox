function Check_sequence(p, q)

% Check_sequence: Checks the validity of a pulse sequence.
% An error occurs if the sequence is invalid.
% The comparisons are written so that NaNs are detected,
% as any numerical comparison with a NaN gives false.
%
% Check_sequence(p, q)
%
% p:        Parameter struct (contains implant parameters)
% q:        pulse sequence.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check for out of range electrodes.
if ~all(q.electrodes <= 22)
    error('Electrode out of range');
end
if ~all(q.electrodes >= 0)
    error('Electrode out of range');
end

% Check for out of range current levels.
if ~all(q.current_levels <= 255)
    error('Current level too large');
end
if ~all(q.current_levels >= 0)
    error('Current level negative');
end 

% Check for out of range phase widths.
if ~all(q.phase_widths_us <= p.max_phase_width_us)
    error('Phase width too large');
end
if ~all(q.phase_widths_us >= p.min_phase_width_us)
    error('Phase width too small');
end