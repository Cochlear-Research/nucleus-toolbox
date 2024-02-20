function varargout = Compare_structs(s1, s2, verbose)

% Compare_structs: Compares two structs, returns 1 if equal.
% This function is useful because isequal(s1,s2) is 0
% if the fields were declared in different orders.
%
% [eq, msg] = Compare_structs(s1, s2, verbose)
%
% s1:      Struct
% s2:      Struct
% verbose: If true, displays message. Default is false.
%
% eq:      Boolean result (1 if equal).
% msg:     Cell array of strings describing the differences.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fnames = union(fieldnames(s1), fieldnames(s2));

msg = {};

for n = 1:length(fnames)
	name = fnames{n};
	if (isfield(s1, name) && isfield(s2, name))	
		v1 = getfield(s1, name);
		v2 = getfield(s2, name);
		if ~isequalwithequalnans(v1, v2)
            if isnumeric(v1) && isnumeric(v2) && (length(v1) == 1) && (length(v2) == 1)
                msg{end+1} = sprintf('%s %f %f', name, v1, v2);
            else
                msg{end+1} = ['Different ', name];
            end
		end
	elseif isfield(s1, name)
		msg{end+1} = ['Struct2 omits ', name];
	elseif isfield(s2, name)
		msg{end+1} = ['Struct1 omits ', name];
	else
		error('Logic error');
	end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 3
	verbose = 0;
end

if nargout == 0
	verbose = 1;
end

if nargout >= 1
	varargout{1} = isempty(msg);
end

if nargout >= 2
	varargout{2} = msg;
end

if verbose
	if isempty(msg)
		disp('Equal');
	else
		disp(char(msg));
	end
end