function seq = Subsequence(seq, i1, i2)
% Subsequence: returns a sequence containing a subset of the pulses.
%
% With three input arguments:
% qo = Subsequence(qi, i1, i2)
% qi:   input sequence
% i1:   index of first pulse
% i2:   index of last pulse (defaults to end)
% qo:   output subsequence
%
% If i2 is not given, and i1 is negative, 
% then return the last N elements (where N = -i1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

field_names  = fieldnames(seq);
num_fields   = length(field_names);

assert(length(i1) == 1);

for f = 1:num_fields
	name = field_names{f};
	vec  = seq.(name);
	if (length(vec) > 1)
        if nargin == 2
            if  i1 > 0
                seq.(name) = vec(i1: end);
            else
                seq.(name) = vec(end + i1 + 1: end);
            end  
        elseif nargin == 3
            seq.(name) = vec(i1:i2);
        else
            error('Nucleus:Sequence', 'Too many arguments');
        end
	end
end
