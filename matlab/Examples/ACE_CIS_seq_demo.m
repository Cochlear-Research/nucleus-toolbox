% ACE_CIS_seq_demo: Plot 20 channel ACE & CIS sequences.
%
% This demo shows how ACE can have a higher channel stim rate than CIS,
% for the same number of channels (filter bands).
% In this example, both ACE and CIS have 20 channels.
% By selecting 10 maxima (half the number of channels),
% ACE can double the channel stim rate.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Audio can be either wav file name or audio samples:
if ~exist('audio', 'var')
	audio = 'asa.wav';
end

p = struct;
p.electrodes = (20:-1:1)';
p.audio_sample_rate_Hz = 16000;

p_cis = p;
p_cis.analysis_rate_Hz = 500;
p_cis.sub_mag = 0;  % Zero envelope produces a pulse at lower level.
p_cis = CIS_map(p_cis);

p_ace = p;
p_ace.num_selected = 10;
p_ace.analysis_rate = 2 * p_cis.analysis_rate_Hz;
p_ace = ACE_map(p_ace);

% Process with each map:
q_ace = Process(p_ace, audio);
q_cis = Process(p_cis, audio);

Plot_sequence({q_cis, q_ace}, {'CIS 20', 'ACE 10/20'});
