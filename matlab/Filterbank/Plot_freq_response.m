function Plot_freq_response(freq_vec, response, opt)

% Plot_freq_response: Plot frequency response of filterbank
%
% Plot_freq_response(freq_vec, response, opt)
%
% freq_vec: Vector of frequencies that response was sampled at.
% response: Response (allowed to be complex).
% opt:      String controlling frequency axis: 'log' (default) or 'linear'.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

warning off;
response_dB = To_dB(response');
warning on;

figure

if nargin < 3
	opt = 'log';
end
switch opt

case 'linear'

	plot(freq_vec, response_dB);
	axis([0 8000 -40 0]);
	Window_title('Response (linear freq)');

case 'log'

	semilogx(freq_vec, response_dB);
	axis([50 8000 -40 0]);
	set(gca, 'XTick', [50,100,200,400,800,1000,2000,4000,8000]);
	set(gca, 'XMinorTick', 'off');
	Window_title('Response (log freq)');

end

xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
zoom on;
