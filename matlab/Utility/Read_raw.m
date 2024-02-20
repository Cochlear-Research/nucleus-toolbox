function a = Read_raw(file_name)

% Read_raw: Read a .raw audio file (from Bolia CRM speech corpus).
% The sample rate is 40 kHz.
%
% a = Read_raw(file_name)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright: Cochlear Ltd
%   Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f = fopen(file_name);
a = fread(f, inf, 'int16');
fclose(f);