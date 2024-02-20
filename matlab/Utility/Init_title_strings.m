function title_str = Init_title_strings(title_str, num_titles)

% Init_title_strings: Initialise a cell array of title strings.
% Used in Plot_sequence, Plot_waveforms.
%
% title_str = Init_title_strings(title_str, num_titles)
%
% title_str:   A string or cell array of strings, used as window title(s).
% num_titles:  The expected number of strings.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ischar(title_str)
    title_str = {title_str};
end

if num_titles > 1
    if length(title_str) == 1
        title_str = repmat(title_str, 1, num_titles);
    elseif length(title_str) < num_titles
        error('Insufficient number of title strings');
    end

    for n = 1:num_titles
        title_str{n} = [title_str{n}, ' (', num2str(n), ')'];
    end
end
