classdef AudioStimuli < handle
	
% AudioStimuli: A collection of audio stimuli.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	properties
		audio_sample_rate_Hz = 16000;
		audio_sample_rate_tolerance = 1.06;
		reference_dB_SPL = 95;
		gap_duration_s = 0.5;
		path_names = strings(0);
		audio_dB_SPL = [];
		stimuli = {};
		noise_path_name = "";
		noise = [];
		noise_dB_SPL = 0;
	end

	methods

		function self = AudioStimuli(p)
			if nargin > 0
				self.audio_sample_rate_Hz = p.audio_sample_rate_Hz;
				self.reference_dB_SPL = p.reference_dB_SPL;
			end
		end

		function read_signal(self, path_name)
			[path_name, audio, dB_SPL] = self.read_audio(path_name);
			self.path_names(end+1) = path_name;
			self.stimuli{end+1} = audio;
			self.audio_dB_SPL(end+1) = dB_SPL;
		end

		function read_noise(self, path_name)
			[path_name, audio, dB_SPL] = self.read_audio(path_name);
			self.noise_path_name = path_name;
			self.noise = audio;
			self.noise_dB_SPL = dB_SPL;
		end

		function audio = mix(self, signal_level, noise_level)
			% Mix speech and noise.
			% signal_level: an array of signal levels in dB SPL.
			% noise_level: an array of noise levels in dB SPL.
			%
			% The length of the level arrays specifies the number of signals.
			% The first signal is repeated.
			% A noise-alone gap is inserted after each signal.

			if isempty(self.stimuli)
				error("Nucleus:AudioStimuli:stimuli", "Signal file must be specified.");
			end
			if isempty(self.noise)
				error("Nucleus:AudioStimuli:noise", "Noise file must be specified.");
			end
			num_signal = length(signal_level);
			num_noise  = length(noise_level);
			if num_signal == 1
				signal_level = repmat(signal_level, 1, num_noise);
				num_signal = num_noise;
			end
			if num_noise == 1
				noise_level = repmat(noise_level, 1, num_signal);
				num_noise = num_signal;
			end
			assert (num_signal == num_noise);
			audio = cell(num_signal, 1);
			gap_n = self.gap_duration_s * self.audio_sample_rate_Hz;
			gap = zeros(gap_n, 1);
			for n = 1:num_signal
				signal = AudioStimuli.calibrate(self.stimuli{1}, self.audio_dB_SPL(1), signal_level(n));
				signal_segment = [signal; gap];
				noise_segment = self.noise(1:length(signal_segment));
				noise_segment = AudioStimuli.calibrate(noise_segment, self.noise_dB_SPL, noise_level(n));
				audio{n} = signal_segment + noise_segment;
			end
			audio = vertcat(audio{:});
		end
	end

	methods(Access = protected)

		function [path_name, audio, audio_dB_SPL] = read_audio(self, path_name)
			path_name = string(path_name);
			% Read wav file and resample if needed:
			audio = Audio_file_proc(self, path_name);
			% Calculate the sound pressure level represented by the wav file before scaling:
			audio_dB_SPL = Calibrate_dB_SPL(self, audio);
		end

	end

	methods(Static)
		function audio_out = calibrate(audio_in, level_in, level_out)
			calibration_gain_dB = level_out - level_in;
			calibration_gain = From_dB(calibration_gain_dB);
			audio_out = calibration_gain * audio_in;
		end
	end
	
end