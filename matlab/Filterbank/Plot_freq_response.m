function Plot_freq_response(p, opt)

% Plot_freq_response: Plot frequency response of filterbank
%
% Plot_freq_response(p, opt)
%
% p:        Parameter struct
% p.response_freqs_Hz:  Vector of frequencies that response was sampled at.
% p.freq_response:      Response.
% opt:      String controlling frequency axis: 'linear' (default) or 'log'.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

warning off;
response_dB = To_dB(p.freq_response');
warning on;

figure

if ~exist('opt', 'var')
	opt = 'linear';
end
switch opt

case 'linear'

	plot(p.response_freqs_Hz, response_dB);
	axis([0 8000 -30 2]);
	Window_title('Response');

case 'log'

	semilogx(p.response_freqs_Hz, response_dB);
	axis([100 8000 -30 2]);
	set(gca, 'XTick', [50,100,200,400,800,1000,2000,4000,8000]);
	set(gca, 'XMinorTick', 'off');
	Window_title('Response');

end

xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
zoom on;
