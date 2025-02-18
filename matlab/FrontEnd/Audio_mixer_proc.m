function audio = Audio_mixer_proc(p, source_specs)

% Audio_mixer_proc: Mix audio sources.
%
% audio = Audio_mixer_proc(p, source_specs)
%
% p:                parameter struct
% source_specs:     cell array of source specifications.
%
% A source specification can have one of two formats:
% 1. {wav_file_name, level_dB_SPL}: uses Audio_proc to read wav file.
% 2. audio_signal: uses signal as is (assumes already calibrated).
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch nargin

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 0  % Default parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    audio = feval(mfilename, struct);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 1  % Parameter calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Set default values for parameters that are absent:
    p = Audio_proc(p);

    audio = p;  % Return parameters.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 2  % Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for n = 1:length(source_specs)

        source_spec = source_specs{n};

        if iscell(source_spec)
            assert(length(source_spec) == 2)
            % Read from wav file using Audio_proc.
            % Make a copy of the parameter struct, to set the source level:
            pn = p;
            pn.audio_dB_SPL = source_spec{2};
            source = Audio_proc(pn, source_spec{1});
        else
            source = source_spec;
        end

        if n == 1
            audio = source;
            num_samples = length(source);
        else
            % Truncate all sources to the length of the shortest source:
            num_samples = min(length(source), num_samples);
            source = source(1:num_samples);
            audio = audio(1:num_samples);
        
            % Mix:
            audio = audio + source;
        end
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
