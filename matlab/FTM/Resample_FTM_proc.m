function v = Resample_FTM_proc(p, u)

% Resample_FTM_proc: resamples a Frequency-Time Matrix to the channel stimulation rate.
% It can use any of the resampling methods supported by "interp1".
%
% function v = Resample_FTM_proc(p, u)
%
% Inputs:
% p:                  Parameter struct with the following fields:
% p.analysis_rate_Hz:      Analysis rate of the filterbank.
% p.channel_stim_rate_Hz:  Channel stimulation rate.
% p.resample_method:    Resampling method (string):
%   'repeat':             Repeats the last available envelope sample.
%   'linear':             Linear interpolation between envelope samples.
% u:                  FTM sampled at the analysis rate.
%
% Outputs:
% v:                  FTM sampled at the channel stimulation rate.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch nargin

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 0	% Default parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	v = feval(mfilename, []);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 1	% Parameter calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	% Set default values for parameters that are absent:
	p = Ensure_field(p, 'analysis_rate_Hz',     1000);
	p = Ensure_field(p, 'channel_stim_rate_Hz', p.analysis_rate_Hz);
    p = Ensure_field(p, 'resample_method',   'repeat');
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	p.sample_rate_Hz = p.channel_stim_rate_Hz;	% for GUI_FTM

	v = p;	% Return parameters.	
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 2	% Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	output_fraction = p.analysis_rate_Hz / p.channel_stim_rate_Hz;

	if (output_fraction == 1)
		v = u;
		return;
	end

    num_samples_in  = size(u, 2);

    switch p.resample_method
    case 'repeat'
        % We implement this here because interp(x, q, 'previous')
        % behaves slightly differently:
	    num_samples_out = round(num_samples_in / output_fraction);
	    sample_points   = (0:num_samples_out-1) * output_fraction;
	    sample_indices  = 1 + floor(sample_points);
        v = u(:, sample_indices);
    otherwise
	    % interp1 operates on columns. Transpose to interpolate rows.
	    v = interp1(u', 1:output_fraction:num_samples_in, p.resample_method)';
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
