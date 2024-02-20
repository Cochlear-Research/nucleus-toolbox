function hdl = Stem_plot(t, m, varargin)

% Stem_plot: Simple stem plot

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t = t(:);								% column_vector
t = t';									% row vector
m = m(:);								% column_vector
m = m';									% row vector

z = repmat(NaN, size(t));
x = [t; t; z];
x = x(:);								% column vector

c = zeros(size(t));
y = [c; m; z];
y = y(:);								% column vector

hdl = line(x, y, varargin{:});
