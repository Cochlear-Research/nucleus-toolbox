function result = Constrain_parameter_test

% Constrain_parameter_test: Test of Constrain_parameter_proc.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Tester(mfilename);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x = 3;

p = struct;
p.gain_dB = 20;
p = Append_process(p, @Gain_proc);

p.parameter_name = 'gain_dB';
p.parameter_min  =  0;
p.parameter_max  = 60;
p = Constrain_parameter_proc(p);

Tester(p.processes, {@Constrain_parameter_proc; @Gain_proc});

y = Process(p, x);
Tester(y, 30);			% Within range.

p.gain_dB = 80;		    % Above max.
p = Process(p);			% Explicit constrain.
Tester(p.gain_dB, 60);	% Constrained to max.

p.gain_dB = 80;		    % Above max.
y = Process(p, x);		% Constrained before processing.
Tester(y, 3000);		% Constrained to max.

p.gain_dB = -20;		% Below min.
p = Process(p);			% Explicit constrain.
Tester(p.gain_dB, 0);	% Constrained to min.

p.gain_dB = -40;		% Below min.
y = Process(p, x);		% Constrained before processing.
Tester(y, 3);			% Constrained to min.

Tester(p.processes, {@Constrain_parameter_proc; @Gain_proc});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

result = Tester;	% Report result.
