function p = Common_substruct(pp, ff)

% Check if the specified fields of a group of structs are equal.
%
% p = Common_substruct(pp, ff)
%
% Args:
%     pp: A cell array of structs.
%     ff: a cell array of field names.
%
% Returns:
%     p: a struct containing the specified common fields of pp.
%     Raises an error if those fields differ or are missing.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

arguments
    pp  {mustBeA(pp, 'cell')}
    ff  {mustBeA(ff, 'cell')}
end

num_p = length(pp);
if num_p == 0
    error('Nucleus:Common_substruct:empty_structs', 'Empty structs');
end
num_f = length(ff);
if num_f == 0
    error('Nucleus:Common_substruct:empty_fields', 'Empty fields');
end

p = struct;
for n = 1:num_f
    f = ff{n};
    for m = 1:num_p
        if ~isfield(pp{m}, f)
            error('Nucleus:Common_substruct:field_absent', 'struct(%d) missing field %s', m, f);
        end	    
    end
    v1 = pp{1}.(f);
    p.(f) = v1;
    for m = 2:num_p
        vm = pp{m}.(f);
        if ~isequal(v1, vm)
            error('Nucleus:Common_substruct:field_mismatch', 'struct(%d) mismatch field %s', m, f);
        end	    
    end
end
