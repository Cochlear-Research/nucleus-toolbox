function w = Cos_window(N, a)

% Cos_window: Generate window functions based on sum of cosine terms.
% Note DFT-even symmetry.
%
% Reference:
% F. J. Harris, "On the use of windows for harmonic analysis with the 
% Discrete Fourier Transorm" Proc IEEE, Jan 1978, pp 51 - 83.
%
% w = Cos_window(N, a)
%
% N:   Window length.
% a:   String specifying window type:
%       Hann
%       Hamming
%       Blackman
%       BlackmanHarris3 (minimum 3 term)
%       BlackmanHarris4 (minimum 4 term)
% w:   Window samples.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ischar(a)
	switch (a)
	
	case 'Hann'
		a = [	0.5,
				0.5,
				0.0,
				0.0
			];
	
	case 'Hamming'
		a = [	0.54,
				0.46,
				0.0,
				0.0
			];
	   
	case 'Blackman'
		a = [	0.42,
				0.50,
				0.08,
				0.0
			];

	case 'BlackmanHarris3'
		a = [	0.42323,
				0.49755,
				0.07922,
				0.0
			];
			
	case 'BlackmanHarris4'
		a = [	0.35875,
				0.48829,
				0.14128,
				0.01168
			];

	otherwise
		error('Unknown window type');
	end
end

n = (0:N-1)';		% Time index vector.
r = 2*pi*n/N;		% Angle vector (in radians).

w = a(1) - a(2)*cos(r) + a(3)*cos(2*r) - a(4)*cos(3*r);
