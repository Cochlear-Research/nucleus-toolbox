classdef Common_substruct_Test < matlab.unittest.TestCase

    methods (Test)

        function bad_args(testCase)
            p1 = struct(a = 1, b = 2);
            pp = {p1, p1};
            testCase.verifyError(@() Common_substruct(),          'MATLAB:minrhs');
            testCase.verifyError(@() Common_substruct(pp),        'MATLAB:minrhs');
            testCase.verifyError(@() Common_substruct(1, 2),      'MATLAB:validators:mustBeA');
            testCase.verifyError(@() Common_substruct({}, {'b'}), 'Nucleus:Common_substruct:empty_structs');
            testCase.verifyError(@() Common_substruct(pp, {}),    'Nucleus:Common_substruct:empty_fields');
        end
        
        function absent_field(testCase)
            p1 = struct(a = 1, b = 2);
            p2 = struct(a = 1);
            pp = {p1, p2};
            testCase.verifyError(@() Common_substruct(pp, {'b'}), 'Nucleus:Common_substruct:field_absent', 'struct(2) missing field b');
            testCase.verifyError(@() Common_substruct(pp, {'c'}), 'Nucleus:Common_substruct:field_absent', 'struct(1) missing field c');        
            % No error:
            p = Common_substruct(pp, {'a'});
            testCase.verifyEqual(p, p2);
        end

        function scalar_diff(testCase)
            p1 = struct(a = 1, b = 2);
            p2 = struct(a = 1, b = 3);
            pp = {p1, p2};
            testCase.verifyError(@() Common_substruct(pp, {'b'}),      'Nucleus:Common_substruct:field_mismatch', 'struct(2) mismatch field b');
            testCase.verifyError(@() Common_substruct(pp, {'a', 'b'}), 'Nucleus:Common_substruct:field_mismatch', 'struct(2) mismatch field b');        
            % No error:
            p = Common_substruct(pp, {'a'});
            testCase.verifyEqual(p, struct(a = 1));

            pp = {p1, p2, p1, p1};
            testCase.verifyError(@() Common_substruct(pp, {'b'}),      'Nucleus:Common_substruct:field_mismatch', 'struct(2) mismatch field b');
            testCase.verifyError(@() Common_substruct(pp, {'a', 'b'}), 'Nucleus:Common_substruct:field_mismatch', 'struct(2) mismatch field b');        
            % No error:
            p = Common_substruct(pp, {'a'});
            testCase.verifyEqual(p, struct(a = 1));
        end

        function char_diff(testCase)
            p1 = struct(a = 'foo', b = 'bar');
            p2 = struct(a = 'foo', b = 'xxx');
            pp = {p1, p2};
            testCase.verifyError(@() Common_substruct(pp, {'b'}),      'Nucleus:Common_substruct:field_mismatch', 'struct(2) mismatch field b');
            testCase.verifyError(@() Common_substruct(pp, {'a', 'b'}), 'Nucleus:Common_substruct:field_mismatch', 'struct(2) mismatch field b');        
            % No error:
            p = Common_substruct(pp, {'a'});
            testCase.verifyEqual(p, struct(a = 'foo'));
        end

    end

end
