classdef Test_AudioStimuli < matlab.unittest.TestCase

% Test_AudioStimuli: Class-based test of AudioStimuli.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright: Cochlear Ltd
%   Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	methods (Test)

		function construct_from_struct(testCase)
			p = struct;
			p.reference_dB_SPL = 100;
			p.audio_sample_rate_Hz = 15625;
			a = AudioStimuli(p);
            testCase.verifyEqual(a.reference_dB_SPL, 100);
            testCase.verifyEqual(a.audio_sample_rate_Hz, 15625);
		end

		function mix(testCase)

			a = AudioStimuli();
            testCase.verifyEqual(a.reference_dB_SPL, 95);
            testCase.verifyEqual(a.audio_sample_rate_Hz, 16000);
			testCase.verifyEqual(a.gap_duration_s, 0.5);

            testCase.verifyTrue(isempty(a.path_names));
            testCase.verifyTrue(isempty(a.stimuli));

			a.read_signal("L001s04r.wav");
            testCase.verifyEqual(a.path_names, "L001s04r.wav");
            testCase.verifyEqual(length(a.stimuli), 1);
			[x, fs] = audioread("L001s04r.wav");
			assert(fs == 16000); % Did not need to resample.
            testCase.verifyEqual(a.stimuli{1}, x);
            testCase.verifyEqual(a.audio_dB_SPL, 72.9, AbsTol=0.1);
			num_speech_samples = length(x);

            testCase.verifyError(@() a.mix(65, 25), "Nucleus:AudioStimuli:noise");        

			a.read_noise("ILTASS.wav");
            testCase.verifyEqual(a.noise_path_name, "ILTASS.wav");
            testCase.verifyFalse(isempty(a.noise));

			% Mix speech at its existing level and negligible noise:
			audio = a.mix(a.audio_dB_SPL, -200);
			speech_with_gap = [x; zeros(8000, 1)];
			num_audio_samples = num_speech_samples + 8000;
			testCase.verifyEqual(length(audio), num_audio_samples);
			testCase.verifyEqual(audio, speech_with_gap, AbsTol=1e-6);

			% Mix noise at its existing level and negligible speech:
			audio = a.mix(-200, a.noise_dB_SPL);
			testCase.verifyEqual(length(audio), num_audio_samples);
			testCase.verifyEqual(audio, a.noise(1:num_audio_samples), AbsTol=1e-6);

			% Mix speech at its existing level and noise at its existing level:
			audio = a.mix(a.audio_dB_SPL, a.noise_dB_SPL);
			testCase.verifyEqual(length(audio), num_audio_samples);
			testCase.verifyEqual(audio, speech_with_gap + a.noise(1:num_audio_samples), AbsTol=1e-6);
		end
	end

end