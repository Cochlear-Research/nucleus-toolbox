function Replot_waveforms(w, p)

% Replot_waveforms: Replot waveform.
% Replaces the current waveform plot (if any).
% Intended to be used as a Psychophysics present_stimuli function. 
%
% Replot_waveforms(w, p)
%
% w: Waveform matrix.
% p: paramter struct.	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

top_fig = get(0,'CurrentFigure');

[was_seq_fig, old_seq_fig] = figflag('Waveform', 1);

Plot_waveforms(w, p);

if was_seq_fig
    old_seq_fig = old_seq_fig(end);
    pos = get(old_seq_fig, 'Position');
    close(old_seq_fig);
    set(gcf, 'Position', pos);
end

if ~isempty(top_fig)
	figure(top_fig);
end
