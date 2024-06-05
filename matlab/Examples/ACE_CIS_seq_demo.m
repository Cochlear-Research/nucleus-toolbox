% ACE_CIS_seq_demo: Plot 20 channel ACE & CIS sequences.
%
% This demo shows how ACE can have a higher channel stim rate than CIS,
% for the same number of channels (filter bands).
% In this example, both ACE and CIS have 20 channels.
% By selecting 10 maxima (half the number of channels),
% ACE can double the channel stim rate.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      $Change: 46997 $
%    $Revision: #1 $
%    $DateTime: 2006/03/27 16:10:22 $
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Audio can be either wav file name or audio samples:
if ~exist('audio', 'var')
	audio = 'asa';
end

pa = [];
pa.num_bands            = 20;
pa.audio_sample_rate    = 16000;
pa.base_level			= 0;

cis = pa;
cis.analysis_rate = pa.audio_sample_rate/24;
cis = CIS_map(cis);

ace = pa;
ace.num_selected  = 10;
ace.analysis_rate = 2 * cis.analysis_rate;
ace = ACE_map(ace);

% Process with each map:

q_ace = Process(ace, audio);
q_cis = Process(cis, audio);

Plot_sequence({q_cis, q_ace}, {'CIS 20', 'ACE 10/20'});
