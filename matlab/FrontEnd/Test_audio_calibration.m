classdef Test_audio_calibration < matlab.unittest.TestCase

% Test_audio_calibration: Class-based test of Calibrate_dB_SPL, Audio_calibration_proc.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright: Cochlear Ltd
%   Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	properties
        tone_ref;
		tol = 1e-6; 
    end

    methods (TestClassSetup)
		function set_up_tone(testCase)
			% Generate a full scale reference tone:
			testCase.tone_ref = Gen_tone(250, 0.1, 16000);
			testCase.verifyEqual(max(abs(testCase.tone_ref)), 1.0);
        end
    end

	methods (Test)

		function bad_param(testCase)
			p = struct;
			p.audio_dB_SPL = 60;
			p.calibration_gain_dB = 20;
            testCase.verifyError(@() Audio_calibration_proc(p), "Nucleus:Audio_calibration");        
		end

		function tone_audio_dB_SPL(testCase)
			% Specify p.audio_dB_SPL.
			
			p = struct;
			p = Audio_calibration_proc(p);
            testCase.verifyEqual(p.reference_dB_SPL, 95);
            testCase.verifyEqual(p.audio_dB_SPL, 65);

			% By definition, this is reference_dB_SPL: 
			tone_ref_dB = Calibrate_dB_SPL(p, testCase.tone_ref);
			testCase.verifyEqual(tone_ref_dB, p.reference_dB_SPL, AbsTol=testCase.tol);

			% Calibrate the tone to the specified level:
			[tone_65, gain_dB, audio_dB_SPL] = Audio_calibration_proc(p, testCase.tone_ref);
			% Output tone should be 30 dB down from full scale:
			testCase.verifyEqual(gain_dB, -30, AbsTol=testCase.tol);
			testCase.verifyEqual(audio_dB_SPL, 65, AbsTol=testCase.tol);
			testCase.verifyEqual(testCase.tone_ref * From_dB(gain_dB), tone_65, AbsTol=testCase.tol);
			tone_ref_dB = Calibrate_dB_SPL(p, tone_65);
			testCase.verifyEqual(tone_ref_dB, p.audio_dB_SPL, AbsTol=testCase.tol);

			% If the amplitude of the input tone is changed, the gain compensates,
			% so that the output is still at the desired level:
			[tone_65a, gain2_dB, audio_dB_SPL] = Audio_calibration_proc(p, testCase.tone_ref / 2);
			testCase.verifyEqual(tone_65a, tone_65, AbsTol=testCase.tol);
			testCase.verifyEqual(gain2_dB, gain_dB + To_dB(2), AbsTol=testCase.tol);
			testCase.verifyEqual(audio_dB_SPL, 65);

			% Change desired output level:
			p = struct;
			p.audio_dB_SPL = 85;
			p = Audio_calibration_proc(p);
			[tone_85, gain_dB, audio_dB_SPL] = Audio_calibration_proc(p, tone_65);
			testCase.verifyEqual(gain_dB, 20, testCase.tol);
			testCase.verifyEqual(audio_dB_SPL, 85, testCase.tol);
			tone_85_dB = Calibrate_dB_SPL(p, tone_85);
			testCase.verifyEqual(tone_85_dB, 85, AbsTol=testCase.tol);
			testCase.verifyEqual(tone_85, 10 * tone_65, AbsTol=testCase.tol);
			testCase.verifyEqual(max(abs(tone_85)), From_dB(-10), AbsTol=testCase.tol);
		end

		function tone_calibration_gain_dB(testCase)
			% Specify p.calibration_gain_dB.

			p = struct;
			p.calibration_gain_dB = -20;
			p = Audio_calibration_proc(p);
			[tone_out, gain_dB, audio_dB_SPL] = Audio_proc(p, testCase.tone_ref);
			testCase.verifyEqual(gain_dB, -20, AbsTol=testCase.tol);
			testCase.verifyEqual(audio_dB_SPL, 75, AbsTol=testCase.tol);
			testCase.verifyEqual(tone_out, testCase.tone_ref * From_dB(gain_dB), AbsTol=testCase.tol);
			tone_ref_dB = Calibrate_dB_SPL(p, tone_out);
			testCase.verifyEqual(tone_ref_dB, 75, AbsTol=testCase.tol);

			% If the amplitude of the input tone is reduced, the output is reduced:
			[tone_out2, gain2_dB, audio2_dB_SPL] = Audio_proc(p, testCase.tone_ref/2);
			testCase.verifyEqual(tone_out2, tone_out/2, AbsTol=testCase.tol);
			testCase.verifyEqual(gain2_dB, -20, AbsTol=testCase.tol);
			testCase.verifyEqual(audio2_dB_SPL, 75 - To_dB(2), AbsTol=testCase.tol);
			tone_ref_dB = Calibrate_dB_SPL(p, tone_out2);
			testCase.verifyEqual(tone_ref_dB, 75 - 6, AbsTol=0.1);
		end
	end
end