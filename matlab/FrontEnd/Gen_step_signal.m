function u = Gen_step_signal(audio_sample_rate_Hz, amplitudes, durations)
% Gen_step_signal: generate a test signal for a front-end AGC.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

K = length(amplitudes);
assert(K == length(durations));

uu = cell(K, 1);
for k = 1:K
    uu{k} = repmat(amplitudes(k), round(audio_sample_rate_Hz * durations(k)), 1);
end
u = vertcat(uu{:});