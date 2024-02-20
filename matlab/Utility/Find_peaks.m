function index = Find_peaks(u)

% Find_peaks: Find peaks in a array of numbers

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Herbert Mauch
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

index = zeros(1,length(u)/2);
j = 1;
rising = true;
for i=1:length(u)-1
    switch rising
        case true
            if (u(i+1)<u(i))
                index(j) = i;
                j = j+1;
                rising = false;
            end
        case false
            if (u(i+1)>u(i))
                rising = true;
            end
    end
end