function [u,coefficients] = Get_coefficients_proc(p)

% Get_coefficients_proc: Return a matrix with the coeffcients
%                   for the provided filterbank configuration.
%
% u, coefficients = Get_coefficients_proc(p)
%
% p: Struct containing the filterbank parameters.
%
% u: Returned parameters
% coefficients: Complex matrix with one row per filter

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Jamon Windeyer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 1
    p = FFT_VS_filterbank_proc();
end
	
p.bin_coeffs = zeros(p.block_length/2 + 1, p.block_length);

% Calculate complex FIR coefficients (impulse response) for each band:
nn = (0:(p.block_length - 1))';
rr = -2i * pi * nn / p.block_length; % factor out common sub-expression from loop.
K = p.block_length/2;
for k = 0:K
    % Each bin impulse response is a modulated window function:
    p.bin_coeffs(k + 1, :) = p.window .* exp(rr * k); 
end
% Band impulse responses are weighted sums of bin impulse responses:
p.band_coeffs = p.weights * p.bin_coeffs;

% When considering as traditional FIR, the coefficients are reversed
p.band_coeffs = flip(p.band_coeffs, 2);

u = p;	% Return parameters.
coefficients = p.band_coeffs; % Return coefficients
