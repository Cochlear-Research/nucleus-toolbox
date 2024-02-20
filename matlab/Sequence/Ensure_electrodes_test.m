function result = Ensure_electrodes_test

% Ensure_electrodes_test: Test Ensure_electrodes. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Tester(mfilename);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p = struct;
p.electrodes = (6:-1:1)';
p = Ensure_electrodes(p);
Tester(p.num_bands, 6);

p = struct;
p.electrodes = [20; 16; 12; 8; 4; 1];
p.num_bands = 6; % Not needed, but acceptable.
p = Ensure_electrodes(p);
Tester(p.num_bands, 6);

p = struct;
p.num_bands = 6;
try
    Ensure_electrodes(p);
	Tester(0);		% FAIL if we reach here.
catch x
	Tester(x.identifier, 'Nucleus:Ensure_electrodes');
	Tester(contains(x.message, 'electrodes'));
end

p = struct;
p.num_bands = 6;
p.electrodes = (12:-1:1)';
try
    Ensure_electrodes(p);
	Tester(0);		% FAIL if we reach here.
catch x
	Tester(x.identifier, 'Nucleus:Ensure_electrodes');
	Tester(contains(x.message, 'electrodes'));
end

p = struct;
p.electrodes = [23; 22; 20; 18; 5];
try
    Ensure_electrodes(p);
	Tester(0);		% FAIL if we reach here.
catch x
	Tester(x.identifier, 'Nucleus:Ensure_electrodes');
	Tester(contains(x.message, 'out of range'));
end

p = struct;
p.electrodes = [22; 20; 18; 0];
try
    Ensure_electrodes(p);
	Tester(0);		% FAIL if we reach here.
catch x
	Tester(x.identifier, 'Nucleus:Ensure_electrodes');
	Tester(contains(x.message, 'out of range'));
end

p = struct;
p.num_bands = 6;
p.electrodes = (12:-1:1)';
try
    Ensure_electrodes(p);
	Tester(0);		% FAIL if we reach here.
catch x
	Tester(x.identifier, 'Nucleus:Ensure_electrodes');
	Tester(contains(x.message, 'electrodes'));
end

p = struct;
p.electrodes = (1:12)';
orig_state = warning;
warning('off','Nucleus:Ensure_electrodes')
p = Ensure_electrodes(p);
msg = lastwarn;
Tester(contains(msg, 'decreases'));
warning(orig_state);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

result = Tester;
