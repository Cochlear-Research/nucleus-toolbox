function p = Ensure_electrodes(p)

% Ensure_electrodes: Ensure electrodes are valid.
%
% p_out = Ensure_electrodes(p_in)
%
% p_in:  A struct containing the clinical parameters.
%          Any fields omitted will be set to default values.
% p_out: A struct containing the clinical and derived parameters.
%
% The comparisons are written so that NaNs are detected,
% as any numerical comparison with a NaN gives false.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p = Ensure_field(p, 'electrodes', (22:-1:1)');
p.electrodes = p.electrodes(:);     % Ensure that it is a column vector.

% Check for out of range electrodes.
if ~all(p.electrodes <= 22)
    error('Nucleus:Ensure_electrodes', 'Electrode out of range');
end
if ~all(p.electrodes > 0)
    error('Nucleus:Ensure_electrodes', 'Electrode out of range');
end

if ~all(diff(p.electrodes) <= -1)
    warning('Nucleus:Ensure_electrodes', ...
    'Channels are ordered in increasing frequency, thus p.electrodes typically decreases (e.g. p.electrodes = 22:-1:1)');
end

if isfield(p, 'num_bands')
    if p.num_bands ~= length(p.electrodes)
        error('Nucleus:Ensure_electrodes', ...
        'Number of electrodes must equal number of bands. If number of bands < 22, specify electrodes.');
    end
else
    p.num_bands = length(p.electrodes);
end
