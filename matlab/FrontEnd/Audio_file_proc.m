function x = Audio_file_proc(p, x)

% Audio_proc: Read audio file and resample if necessary.
%
% x = Audio_file_proc(p, x)
%
% If the arg "x" is the name of a file, read it from disk,
% and resample if necessary.
% If not, just return it.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch nargin

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 0	% Default parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	x = feval(mfilename, []);
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 1	% Parameter calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    p = Ensure_field(p, 'audio_sample_rate_Hz',         16000); % Hz
	p = Ensure_field(p, 'audio_sample_rate_tolerance',  1.06);

	x = p;
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 2	% Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
	if ischar(x) || isstring(x)
		% Assume it is the name of an audio file.
		% The file can be anywhere on the MATLAB path.
        % Read entire file:
        [x, fs] = audioread(x);
        % If file has multiple channels, take first channel:
        if size(x, 2) > 1
            x = x(:, 1);
        end
        % Allow small sample rate differences:
        rate_ratio = fs / p.audio_sample_rate_Hz;
        if (rate_ratio   > p.audio_sample_rate_tolerance)...
        || (1/rate_ratio > p.audio_sample_rate_tolerance)
            x = resample(x, p.audio_sample_rate_Hz, fs);
        end
	% else will return input x as output x.
	end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
