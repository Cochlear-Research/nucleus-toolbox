function result = LGF_alpha_test

% LGF_alpha_test: Test of LGF_alpha
% Exercise LGF_alpha for all standard Base-level and Q values.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Colin Irwin, Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

verbose = Tester(mfilename);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Qs = 10:50;
Bs =  1:15;
sat_level = 150;

NB = length(Bs);
NQ = length(Qs);
alpha = zeros(NB, NQ);
Qdiff = zeros(NB, NQ);

for b = 1:NB
	B = Bs(b);
	for q = 1:NQ
		Q = Qs(q);
		alpha(b, q) = LGF_alpha(Q, B, sat_level);
		Qdiff(b, q) = Q - LGF_Q(alpha(b,q), B, sat_level);
	end
end

max_Qdiff = max(max(abs(Qdiff)));

if verbose > 1
	fprintf('Worst error = %g\n', max_Qdiff);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Results:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Tester(max_Qdiff < 1e-6);
result = Tester;	% Report result
