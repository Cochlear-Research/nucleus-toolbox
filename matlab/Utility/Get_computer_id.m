function s = Get_computer_id()

% Get_computer_id: Get an identifier for this computer. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright: Cochlear Ltd
%   Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ismac()
    [~, s] = system('ioreg -l | grep IOPlatformSerialNumber');
    % output should look like:
    %     |   "IOPlatformSerialNumber" = "C02ZKGR0MD6Y"
    m = regexp(s,'\w*', 'match');   % match words
    s = m{2};
else
    [~, s] = system('hostname');
    s = strtrim(s); % removing trailing new line
end
