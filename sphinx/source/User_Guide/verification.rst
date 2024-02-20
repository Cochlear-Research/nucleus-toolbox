################################################################################
Verification
################################################################################

|SW| is verified by a set of automated test scripts.
The majority of the test scripts are written in MATLAB.
Some test scripts are written in Python.

.. _testing:

Testing Framework
=======================================================

This section describes the functions in the :file:`Testing` directory,
which provide a framework for verifying the correct operation of functions in |SW|.

The function :func:`Run_tests` is the top-level test function.
With no arguments, it searches for all functions in |SW| whose name ends with `_test`,
and runs them.
If a directory name is supplied as an argument, it only runs the tests in that directory.

The general structure of each `_test` function is illustrated by the function :func:`Sum_test`,
which performs a rudimentary test of the built-in function :func:`sum`:

.. literalinclude:: ../../../matlab/Testing/Sum_test.m
   :linenos:

Firstly, the test is initialised by calling the function :func:`Tester`
with the function name as an argument.
The function :func:`Verbose` maintains an internal persistent variable `verbose`.
If `verbose` is zero (the default), :func:`Tester` does not display anything.
If `verbose` is greater than zero, then a `Begin` message will be displayed.
To set the `verbose` variable, run the following command before the test::

    Verbose(1)

    ans =
         1

The function :func:`Tester` returns the present value of `verbose`,
so that the test script can also display information as desired.
The :func:`Sum_test` function then generates suitable inputs for the function under test,
and calls the function under test, :func:`sum`.
If `verbose` is greater than zero, then the inputs and outputs should be displayed or plotted.
This is particularly useful during development of the function under test.
It also allows the test function to serve as a demonstration of the function under test.

The next step is to compare the outputs of the function under test to their expected values.
It is also useful to make assertions stating what we expect to be true about the output:
for example, in :func:`Sum_test` we expect the output to be scalar.
The function :func:`Tester` is again used to perform these comparisons:
when called with two inputs, it compares them for equality,
and appends the result internally to a persistent logical vector result.
The overall result of the test is obtained by calling :func:`Tester` with no arguments.
The overall result is a pass if every :func:`Tester` comparison was true.
The returned value is 1 for a pass or 0 for a fail.
A Pass/Fail message is also displayed.
For example, with `verbose = 1`::

    Sum_test;

    Begin: sum_test
    x =
         1     2     3
    s =
         6
    Result: 11
    Pass:  sum_test

The Result vector "11" shows that both comparisons passed, so the overall result is a Pass.
With the `verbose = 0`, we just see the one-line Pass/Fail message::

    Verbose(0);
    Sum_test;

    Pass:   Sum_test


Procedure
=======================================================

MATLAB Test scripts
----------------------

At the MATLAB command prompt, type::

    cd(Nucleus_dir)
    Run_tests;

The names of the test scripts and the results will be displayed,
followed by a summary of the test environment.
This information is also written to a file in the :file:`test_out` directory,
which can be used to generate a release report.

Python Test scripts
----------------------

At a command prompt, type::

    pytest



