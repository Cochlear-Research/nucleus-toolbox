function [xo, yo] = Time_align(x, y)

% Time_align: Align two column vector signals in time by zero-padding at opposite ends.
% The time lag for best alignment is found by cross-correlation.
%
% [xo, yo] = Time_align(x, y)
%
% x: input signal
% y: input signal
%
% xo: output signal
% yo: output signal

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright: Cochlear Ltd
%   Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[r, lags] = xcorr(x, y);    % Cross-correlate.
[~, k] = max(r);            % k is the location of the peak, as an index into r.
lag = lags(k);              % Convert index into a lag, positive or negative.

if lag > 0                  % Need to delay y.
    z = zeros(lag, 1);
    xo = [x; z];
    yo = [z; y];
elseif lag < 0              % Need to delay x.
    z = zeros(-lag, 1);
    xo = [z; x];
    yo = [y; z];
else                        % They were already time-aligned.
    xo = x;
    yo = y;
end
    


