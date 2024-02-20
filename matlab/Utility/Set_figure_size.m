function Set_figure_size(fig_height, fig_width)

% Set_figure_size: Set figure size for pasting figures into Word doc:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright: Cochlear Ltd
%   Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (nargin < 1) || (fig_height == 0)
    fig_height = 24;
end
if (nargin < 2) || (fig_width == 0)
    fig_width = 16;
end

set(gcf, 'PaperType', 'A4');
paper_size = get(gcf, 'PaperSize');		
left   = (paper_size(1) - fig_width)/2;
bottom = (paper_size(2) - fig_height)/2;

set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'centimeters');		
set(gcf, 'PaperPosition', [left, bottom, fig_width, fig_height]);
