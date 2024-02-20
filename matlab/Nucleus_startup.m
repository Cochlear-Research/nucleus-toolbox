% Nucleus_startup: suggested defaults for Nucleus Toolbox.
% Call this file from startup.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

format compact;

% Default Figure settings:
set(0, 'DefaultFigureColorMap', hot);

% Allow Python to communicate with this MATLAB session:
matlab.engine.shareEngine