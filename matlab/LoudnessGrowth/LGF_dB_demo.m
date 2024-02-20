function LGF_dB_demo(options)

% LGF_demo: Plot Loudness Growth Function, for various parameters.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin == 0
	options = '';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot typical values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p = [];
p.sat_level  = 1.0;
p.base_level = p.sat_level / From_dB(40);
p.lgf_Q = 20;
p = LGF_proc(p);

xx_dB = -50:10;  % 1 db steps
xx = From_dB(xx_dB);
yy = LGF_proc(p, xx);

figure;
plot(xx_dB, yy);
ylim = [-0.1, 1.1];
set(gca, 'Xlim', xx_dB([1,end]), 'YLim', ylim);
hold on
s = To_dB(p.sat_level);
line([s, s], ylim, 'LineStyle', ':');
y = 0.5;
text(s, y, 'saturation level', 'rotation', 90,...
    'VerticalAlignment', 'bottom',...
    'HorizontalAlignment', 'center');
s = To_dB(p.base_level);
line([s, s], ylim, 'LineStyle', ':');
text(s, y, 'base level', 'rotation', 90,...
    'VerticalAlignment', 'bottom',...
    'HorizontalAlignment', 'center');

if contains(options, 'scale')
    xlabel('Scaled envelope (dB)');
    ylabel('Magnitude');
else
    xlabel('Filter band amplitude (dB)');
    ylabel('Output magnitude');
end
if contains(options, 'clip')
	print -dmeta
end
