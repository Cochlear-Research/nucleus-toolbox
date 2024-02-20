function [output, response, max_output] = Tone_response(p, freq_vec, num_in_samples, amplitude)

% Tone_response: Calculate frequency response of filterbank using tones (& plot if verbose)
%
% [output, response, max_gain] = Tone_response(p, freq_vec, num_in_samples)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n = (0:(num_in_samples - 1))';

if nargin < 4
	amplitude = 1;
end

if length(freq_vec) == 1
	freq_vec = 0:freq_vec:(p.audio_sample_rate_Hz/2);
end

num_tones = length(freq_vec);
output = cell(1,num_tones);
response = zeros(p.num_bands,num_tones);

for k = 1:num_tones
	tone = amplitude * sin(2*pi*n* freq_vec(k)/p.audio_sample_rate_Hz);
	output{k} = Process(p, tone);
	steady_output = output{k};
	response(:,k) = max(abs(steady_output), [], 2);
end

max_output = max(response, [], 2);

if Verbose >= 1	
	disp('Max output of each band =');
	disp(max_output);
end
if Verbose >= 2
	Plot_freq_response(freq_vec, response, 'log');
end
if Verbose >= 3
	Plot_freq_response(freq_vec, response, 'linear');
	GUI_FTM(p, response, 'Response (FTM)');	
	GUI_FTM(p, output,   'Output');
end
