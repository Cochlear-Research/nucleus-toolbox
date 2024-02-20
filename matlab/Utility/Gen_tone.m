function [tone, t] = Gen_tone(frequency_Hz, duration_s, sample_rate_Hz, rise_fraction, rise_time_s)

% Gen_tone: Generate a sampled-audio pure tone with smooth rise & fall.
% function tone = Gen_tone(frequency, duration, sample_rate_Hz, rise_fraction)
% frequency_Hz:	    the tone frequency, in Hertz.
% duration_s:		the duration of the tone, in seconds.
% sample_rate_Hz:	the audio sample rate, in Hertz.
% rise_fraction:    the rise-time and fall-time, as a fraction of the duration;
%				    must be <= 0.5.
% rise_time_s:      the rise-time and fall-time, in seconds.
%
% Only one of rise_fraction or rise_time can be specified.
% If rise_time is supplied, then the 4th argument should be '' or [].
% If neither is specified, then rise_time = 0.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch nargin

case 5	% Use rise_time
	if ~isempty(rise_fraction)
		error('rise_fraction should be empty when rise_time is specified.')
	end
	
case 4	% Use rise_fraction
	rise_time_s = duration_s * rise_fraction;

case 3
	rise_time_s = 0;
	
otherwise
	error('Not enough arguments.')
end

Nleng = round(duration_s  * sample_rate_Hz);	% Number of time samples.
Nrise = round(rise_time_s * sample_rate_Hz);
Nflat = Nleng - 2 * Nrise;
if (Nflat < 0)
	error('rise time must be less than half of duration.');
end
env = Gen_smooth_rise_fall(Nrise, Nflat);

n = (0:Nleng-1)';
t =  n / sample_rate_Hz;		% Time index, column vector.
tone = env .* sin(2*pi*frequency_Hz * t);
