function p = Ensure_field(p, field_name, default_value)

% Ensure_field: Ensure that a struct field exists, else give it a default value.
% If the field existed in the input p, then the output p is identical.
% Else a new field is created, with the specified default value.
%
% p = Ensure_field(p, field_name, default_value)
% 
% Inputs:
% p:             Parameter struct.
% field_name:    Name of field (string).
% default_value: Value to set field to if field does not exist in p.
%
% Outputs:
% p:             Parameter struct.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isfield(p, field_name)
	p.(field_name) = default_value;
end
