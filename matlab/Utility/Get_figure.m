function fig_hdl = Get_figure

% Get_figure: Get handle of current figure.
% It returns empty if there is no figure.
% A GUI that uses this function instead of gcbf can have its callbacks
% called from the command line or another function, allowing 
% automated testing.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fig_hdl = get(0,'CurrentFigure');
