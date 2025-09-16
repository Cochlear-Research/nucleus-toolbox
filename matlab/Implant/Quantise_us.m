function [time_us, num_ticks] = Quantise_us(p, time_us)

% Quantise_us: Quantise time in microseconds to an integer number of ticks. 
% 
% [time_us, num_ticks] = Quantise_us(p, time_us)
%
% Args:
%   p:          Parameter struct with a field:
%	p.tick_us:	Duration of a clock tick, in microseconds.
%	time_us:	Time, in microseconds.
%
% Returns:
%	time_us:	Time quantised to nearest tick, in microseconds.
%   num_ticks:	The corresponding number of clock ticks.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

num_ticks = round(time_us / p.tick_us);
time_us = num_ticks * p.tick_us;
