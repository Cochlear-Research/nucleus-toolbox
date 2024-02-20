function value = Extract_bit_field(word, start_pos, width)

% Extract_bit_field: Extract a bit field from an integer word.
% value = Extract_bit_field(word, start_pos, width)
% word:      integer (usually unsigned)
% start_pos: index of least significant bit of field
% width:     number of bits in field

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mask  = bitshift(1, width) - 1;
shift = bitshift(word, -start_pos);
value = bitand(shift, mask);
