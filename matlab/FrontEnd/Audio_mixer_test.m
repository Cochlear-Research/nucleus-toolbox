function result = Audio_mixer_test

% Audio_mixer_test: Test of Audio_mixer_proc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

verbose = Tester(mfilename);
tol = 1e-5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read & mix audio signals:

test_cases = {
    {65,   0};
    {65,  10};
    {65, -10};
    {75,  20};
    };

N = length(test_cases);
for n = 1:N
    audio_dB_SPL = test_cases{n}{1};
    snr_dB = test_cases{n}{2};

    % Common parameters:
    p = struct;
    p.audio_sample_rate_Hz = 16000;
    p.audio_dB_SPL = audio_dB_SPL;
    
    pm = p;
    pm.noise_dB_SPL = audio_dB_SPL - snr_dB;
    pm = Audio_mixer_proc(pm);
    
    Tester(pm.audio_sample_rate_Hz, 16000);
    Tester(pm.audio_dB_SPL,     audio_dB_SPL); 
    Tester(pm.reference_dB_SPL, 95);  % from Audio_proc.
    
    speech_wav = 'L001s04r.wav';
    noise_wav = 'ILTASS.wav';
    audio = Audio_mixer_proc(pm, {speech_wav, noise_wav});
    
    % Compare to reading separately:
    pa = Audio_proc(p);
    speech = Audio_proc(pa, speech_wav);
    noise  = Audio_proc(pa, noise_wav);
    
    audio2 = speech + From_dB(-snr_dB) * noise(1:length(speech));
    Tester(audio, audio2, tol);
    
    if verbose > 2
        figure; hold on;
        plot(audio, 'r');
        plot(audio2, 'b');
        Window_title(sprintf('S %d dB, SNR %d dB', audio_dB_SPL, snr_dB))
    end

    % Test sources being signals (not wav files):

    audio3 = Audio_mixer_proc(pm, {speech, noise_wav});
    Tester(audio, audio3, tol);

    audio4 = Audio_mixer_proc(pm, {speech_wav, noise});
    Tester(audio, audio4, tol);

    audio5 = Audio_mixer_proc(pm, {speech, noise});
    Tester(audio, audio5, tol);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

result = Tester;	% Report result

