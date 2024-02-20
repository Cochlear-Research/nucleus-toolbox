function v = Get_cell_fields(c, name)

% Get_cell_fields: Get array of fields from cell array of structs.
%
% v = Get_cell_fields(c, name)
%
% c:    Cell array of structs.
% name: Name of field.
% v:    Array of field contents from each cell.
%       The return type depends on the cell field contents.
%       If each cell field is a scalar, v is a column vector.
%       If each cell field is a vector with the same size, v is a matrix,
%       with the "per cell" dimension running down the columns.
%       If the cell fields are not compatible types or sizes, v is a cell array.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N = length(c);

try
	for n = 1:N
		v(n,:) = getfield(c{n}, name);
	end
	return;
catch
end

try
	for n = 1:N
		v(n,:) = getfield(c{n}, name)';	% try transpose
	end
	return;
catch
end

v = cell(1,N);
for n = 1:N
	v{n} = getfield(c{n}, name);
end

