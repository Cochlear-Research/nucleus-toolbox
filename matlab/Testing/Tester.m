function r = Tester(a, b, tolerance)

% Tester: Unit test framework.
%
% r = Tester(a, b, tolerance)
% The type and number of arguments determines the action.
%
% A single string argument is used to set up a test suite.
% It returns the verbose level.
% verbose = Tester foo        : Denote start of test 'foo'.
%
% The following cases treat their arguments as conditions to be tested.
% They return a boolean result, and also accumulate this result into
% a persistent vector of results:
% Tester(a)         : Test that a is true (when "a" is not a string).
% Tester(a, b)      : Test that a equals b.
% Tester(a, b, tol) : Test that a equals b within the specified tolerance.
%
% With no arguments, it displays a pass/fail message and returns
% an overall result.
% The verbose setting affects what this function displays:
%
% Verbose  Behaviour
% 0        Display pass/fail
% 1        Also display test case result vector
% 2        Also display log
% 3        Also display variables that failed comparison
% 4        Also enable pause in GUIs.
%
% When testing GUIs, pauses are disabled if verbose is <= 3, 
% making the GUIs run faster.
%
% Example usage:
% verbose = Tester(mfilename);	% Remember the name of this test suite.
% Tester(Foo(10), 100);			% Test that Foo(10) == 100
% Tester(pi, 22/7, 0.1)			% Test that pi is approx 22/7
% Tester;						% Print Pass/Fail for this test suite.					

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright: Cochlear Ltd
%   Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

persistent name;
persistent result;
persistent delog;
if isempty(delog)
    delog = 1;      % Delete log file at end of each test.
end

verbose = Verbose;	% Save verbose function result into local variable.

switch nargin

case 0

	% Display Pass/Fail result:

	if ~isempty(name)
		if verbose
			% Display header and result vector
			fprintf('        ');
			n = 1:length(result);
			fprintf('%d', rem(n, 10));	% Prints entire vector.
			fprintf('\n');
			fprintf('Result: ');
			fprintf('%d', result);		% Prints entire vector.
			fprintf('\n');
		end
		r = all(result);	
		if (r)
			disp(['Pass:   ', name]);
		else
			disp(['FAIL:   ', name]);
		end
		name = [];
		result = [];

        log_file_name = Open_log;
        if delog && ~isempty(log_file_name)
            delete(log_file_name);	% Delete log file.
        end
		Open_log ~file;		% Turn off file logging.
		pause on;
		
	else
		disp('No test suite');
	end

case 1

	if ischar(a)
		% Assume argument is the name of the test.
		name = a;
		result = [];
		if verbose
			fprintf('\nBegin:  %s\n', name);
		end
		
		r = verbose;
		if verbose >= 2
			Open_log echo;
		else
			Open_log ~echo;
		end

		if verbose <= 3
			pause off;
		end
		
	else
		% Argument is a results matrix.
		r = all(a(:));
		result = [result; r];
	end

case 2

    if isequal(a, 'delog')
        delog = b;
        return
    end
	if isstruct(a)
        if isstruct(b)
            r = Compare_structs(a, b, verbose >= 3);
        else
            r = 0;
        end
    else	
		r = isequaln(a, b);		
        Show(r, a, b, verbose); 
	end
	result = [result; r];

case 3
    % Catch error if a and b are incompatible (e.g. different non-scalar sizes):
    try
        delta = a(:) - b(:);
        r = all(abs(delta) <= tolerance);
        Show(r, a, b, verbose);
    catch
        r = 0;
    end
	result = [result; r];

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Show variables if they differ and we are verbose. 
function Show(r, a, b, v)
if ~r && v >= 3 
    disp(a)
    fprintf('~=\n')
    disp(b)
    fprintf(';\n')
end
