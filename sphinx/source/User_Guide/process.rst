.. _processing:

Processing Framework
################################################################################
This section describes the functions in the :file:`Processing` directory.
It contains the processing framework functions,
and some very simple processing functions that did not fit into the other categories.

The parameters of an algorithm in |SW| are stored as fields in a parameter struct.
A sound coding strategy like ACE requires a large number of parameters,
and storing them in a struct allows them to be passed around conveniently as a single variable.
An algorithm is often specified by a set of fundamental parameters,
and some additional internal parameters may then be derived.
The derived parameters can be calculated by a function and appended to the existing parameter struct.
This function can also be used to set up default parameters,
whilst allowing any of the defaults to be over-ridden.
The parameter calculations are usually closely related to the processing algorithm,
so it is convenient to use one function to do both.

The processing framework is a set of functions and conventions that allow
individual processing functions to be joined together into "process chains",
and then called as a unit.
Each processing function is named with a `_proc` suffix and has the following structure::

    function v = Example_proc(p, u)     % function definition
    switch nargin                       % switch on number of input arguments
    case 0:                             % Set default parameters
    case 1:                             % Calculate parameters
    case 2:                             % Perform processing
    end

The calling convention is that the first argument is the parameter struct,
and the second argument is the input signal.
The function uses ``nargin`` to determine how many arguments it was actually called with.
The next few paragraphs will describe how to write a function for this processing framework:
the function ``Gain_proc`` will be used as an example,
so you may want to open ``Gain_proc.m`` in a text editor to examine the source code,
or open the live script.

.. include:: /_generated/process.txt

The main benefit of the processing framework is that the parameter struct
specifies both the algorithm and the parameters of the algorithm.
This means that we can pass the parameter struct to another function,
and that function can call the correct processing functions,
without having particular processing functions "hard-wired" into it.