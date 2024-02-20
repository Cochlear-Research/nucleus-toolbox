function Window_title(varargin)
% Window_title: Sets the title of the window of the current figure.
% Handles additional arguments as per sprintf.
% function Window_title(title_str, args)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%  $Nokeywords: $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set(gcf, 'numbertitle', 'off');
set(gcf, 'name', sprintf(varargin{:}));

