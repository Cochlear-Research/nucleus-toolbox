function Set_figure_data(u)

% Set_figure_data: Set data of current callback figure or else current figure.
% An error occurs if there is no figure.
% A GUI that uses this function can have its callbacks
% called from the command line or another function, allowing 
% automated testing.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fig_handle = Get_figure;
set(fig_handle, 'UserData', u);
