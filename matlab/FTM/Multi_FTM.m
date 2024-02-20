function u = Multi_FTM(p, m, title_str)

% Multi_FTM: Plot multiple FTM images in a single figure.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright: Cochlear Ltd
%   Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 3
	title_str = '';
end
u = Examine_FTM(p, m, title_str);

Get_axes(u.num_FTMs, 1);

n = 0: u.num_time_samples(1) - 1;
t = n / u.sample_rate_Hz;

u = Ensure_field(u, 'flip', 0);
u = Ensure_field(u, 'FontSize', 12);
nn = 1:u.num_FTMs;
if u.flip
	nn = u.num_FTMs:-1:1;
end
for n = nn
    a = Get_axes;
	image( max(0, real(u.data{n})),...
              'XData', t,...
              'YData', u.freq_labels,...
		      'CDataMapping','scaled');
          
    if u.num_FTMs > 1	      
        pos = get(gca, 'Position');
        set(gca, 'Position', pos .* [1,1,1,0.95]);
    end
    set(gca, 'FontSize', u.FontSize);
    
	ym = size(u.data{n}, 1);
	if nargin >= 3
    	text(u.duration/10, ym * 0.1, u.title_str{n}, 'Color', 'white');
	end
	
	if a.row == 1
		xlabel(u.time_label_string);
	else
		set(gca, 'XTickLabel', []);	
	end
	if a.row == ceil(u.num_FTMs/2)
		ylabel(u.freq_label_string);
	end
end

a = Get_axes('get');
set(a.axes_vec, 'YDir', u.y_dir,...
                'CLim', [0, u.overall_max_mag],...
                'TickDir', 'out');
u.a = a;
