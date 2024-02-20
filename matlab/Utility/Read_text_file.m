function c = Read_text_file(filename)

% Read_text_file: Reads a text file into a cell array of strings.
% function c = Read_text_file(filename)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fid = fopen(filename);
n = 1;
while 1
    text_line = fgetl(fid);
    if ~ischar(text_line), break, end
    c{n,1} = text_line;
    n = n + 1;
end
fclose(fid);
