function env = Gen_smooth_rise_fall(Nrise, Nflat)
% Gen_smooth_rise_fall: Generate an envelope with smooth rise & fall times.
% function env = Gen_smooth_rise_fall(Nrise, Nflat)
% Nrise: The number of samples taken to rise and to fall.
% Nflat: The number of samples in the middle with full amplitude.
% env:   The envelope; rises from 0, then constant at 1, then falls to 0.
%        The rise and fall are symmetrical, with a hanning shape (raised cosine).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

w = hanning(2*Nrise, 'symmetric');
env = [w(1:Nrise); ones(Nflat,1); w(Nrise+1:end)];