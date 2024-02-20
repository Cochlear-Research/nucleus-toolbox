function pa = Get_axes(varargin)

% Get_axes: Get axes for multiple or single axes per figure.
% pa = Get_axes(nr, nc, fig_height, fig_width, extra_margin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright: Cochlear Ltd
%   Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

persistent p	% parameter struct

if isempty(p)
	p = Init(1, 1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch nargin

case 0

	if (p.row == 1) && (p.col == 1)
		figure

		Set_figure_size(p.fig_height, p.fig_width);
		
		ax = axes;	% default position, adjust later
		position = get(ax, 'Position');
		
        p = Ensure_field(p, 'left',   position(1));
		p = Ensure_field(p, 'bottom', position(2));
		p.width  = position(3) / p.num_cols;
		p.height = position(4) / p.num_rows;

		set(ax, 'Position', [p.left, p.bottom, p.width, p.height]);
	else			
		left   = p.left   + (p.col - 1) * p.width;
		bottom = p.bottom + (p.row - 1) * p.height;

		ax = axes('Position', [left, bottom, p.width, p.height]);
	end
	
	p.axes_mat(p.row, p.col) = ax;
	p.axes_vec(end+1) = ax;

	pa = p;
	
	p.col = p.col + 1;
	if p.col > p.num_cols
		p.col = 1;
		p.row = p.row + 1;
		if p.row > p.num_rows
			p.row = 1;	% Will start a new figure next call.
		end
	end	

case 1
    s = varargin{1};
	if isequal(s, 'get')
		pa = p;
    elseif isstruct(s)
        p = Init_struct(s);
        pa = p;
    else
		error('Unexpected argument')
	end
	
otherwise
	
	p = Init(varargin{:});
	pa = p;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function p = Init_struct(p)

p = Init_common(p);
p = Ensure_field(p, 'num_rows',   1);
p = Ensure_field(p, 'num_cols',   1);
p = Ensure_field(p, 'fig_height', 0);
p = Ensure_field(p, 'fig_width',  0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function p = Init(nr, nc, fig_height, fig_width)

p = struct;
p.num_rows = nr;
p.num_cols = nc;
if (nargin < 3)
    fig_height = 0;
end
if (nargin < 4)
    fig_width = 0;
end
p.fig_height = fig_height;
p.fig_width  = fig_width;
p = Init_common(p);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function p = Init_common(p)
p.row = 1;
p.col = 1;
p.axes_mat = zeros(p.num_rows, p.num_cols);
p.axes_vec = [];
