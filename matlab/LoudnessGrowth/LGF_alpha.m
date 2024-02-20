function alpha = LGF_alpha(Q, base_level, sat_level)
% LGF_alpha: Calculate Loudness Growth Function alpha factor.
% function alpha = LGF_alpha(Q, base_level, sat_level, fzero_options)
% This process is equivalent to an inverse, however the
% LGF function is transcendental and so this direct inverse is not possible.
% Warning: the while loop may not terminate for unusual input values.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Colin Irwin, Brett Swanson, Bonar Dickson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Find an interval that contains a zero crossing of LGF_Q_diff.
% fzero works much better if we give it this interval.
% We start with log_alpha chosen to give a positive value of LGF_Q_diff
% for sensible values of Q, base_level, sat_level, 
% and then increment it until we see a sign change.
% We use log_alpha instead of alpha to make the search easier:
% a plot of Q vs log(alpha) changes much more smoothly than Q vs alpha.

log_alpha = 0;
while 1
	log_alpha = log_alpha + 1;
	Q_diff	= LGF_Q_diff(log_alpha, Q, base_level, sat_level);
	if (Q_diff < 0)
		break;
	end
end
interval = [(log_alpha - 1)  log_alpha];

% Find the zero crossing of LGF_Q_diff:
opt.Display = 'off';
opt.TolX = [];    
log_alpha = fzero(@LGF_Q_diff, interval, opt, Q, base_level, sat_level);
alpha = exp(log_alpha);
