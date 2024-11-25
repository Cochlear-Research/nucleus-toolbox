% Vocoder_demo: Demonstrate resynthesis of audio from filterbank envelopes.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

audio = 'L001s04r.wav';

%%
pv = Vocoder_map;
a1 = Process(pv, audio);

%%
pa = ACE_map;
pr = Resynth_audio_proc(pa);

c = Process_chain(pa, audio);
n = Find_process(pa, @Gain_proc);
v = c{n};  % Scaled envelope.
a2 = Resynth_audio_proc(pr, v);

%%
h = audioplayer(a1, pv.audio_sample_rate_Hz);
h.playblocking()
h = audioplayer(a2, pa.audio_sample_rate_Hz);
h.playblocking()

