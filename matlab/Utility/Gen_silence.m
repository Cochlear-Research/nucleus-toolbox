function silence = Gen_silence(duration_s, sample_rate_Hz)

% Gen_silence: Generates a column vector of zeroes of appropriate length given
%               the desired duration and sampling rate.
%
% silence = Gen_silence(duration, sample_rate_Hz)
% duration_s:     The duration of the silence, in seconds.
% sample_rate_Hz: The audio sample rate, in Hertz.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Jamon Windeyer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin ~= 2
    error('Must provide duration and sampling rate.')
end

length = round(duration_s * sample_rate_Hz);
silence = zeros(length,1);
