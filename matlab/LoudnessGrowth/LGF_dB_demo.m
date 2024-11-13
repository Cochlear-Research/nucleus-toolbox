function LGF_dB_demo(qq)

% LGF_demo: Plot Loudness Growth Function, for various parameters.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

arguments
    qq = [20];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xx_dB = -50:10;  % 1 dB steps
xx = From_dB(xx_dB);
figure;
hold on;

N = length(qq);
tt = cell(N, 1);
for n = 1:N
    p = struct;
    p.Q = qq(n);
    p = LGF_proc(p);
    yy = LGF_proc(p, xx);
    plot(xx_dB, yy);
    tt{n} = sprintf('%d', p.Q);
end

ylim = [-0.1, 1.1];
set(gca, 'Xlim', xx_dB([1,end]), 'YLim', ylim);
hold on
s = To_dB(p.sat_level);
xline(s, 'LineStyle', ':');
y = 0.5;
text(s, y, 'saturation level', 'rotation', 90,...
    'VerticalAlignment', 'bottom',...
    'HorizontalAlignment', 'center');
b = To_dB(p.base_level);
xline(b, 'LineStyle', ':');
text(b, y, 'base level', 'rotation', 90,...
    'VerticalAlignment', 'bottom',...
    'HorizontalAlignment', 'center');

xlabel('Envelope amplitude (dB)');
ylabel('Output magnitude');
