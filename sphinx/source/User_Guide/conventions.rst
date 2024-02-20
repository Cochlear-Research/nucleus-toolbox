Coding Conventions
################################################################################

Function Naming Conventions
=======================================================
The names of all built-in MATLAB functions are in lower case.
To distinguish the |SW| functions, their names begin with an initial upper-case letter.
Long, descriptive names are encouraged, and an underscore is used to separate the components of a name.
The names of functions are generally verbs.
Some function names begin with a prefix, or end with a suffix, as listed below.

=============	  =====================================================================================
Prefix/Suffix	  Description
=============	  =====================================================================================
``Read_*``		  A function that reads data from a file.
``Save_*``		  A function that saves data to a file.
``Gen_*``		    A function to generate signals or sequences.
``GUI_*``		    A function that creates a graphical user interface.
``*_proc``		  A function that follows the conventions of the :ref:`processing`.
``*_test``		  A test function. It takes no arguments, and prints a Pass/Fail result (see :ref:`testing`).
``*_demo``		  A demonstration script.
=============	  =====================================================================================

Variable Naming Conventions
=======================================================
The names of variables or struct fields in |SW| are nouns,
and usually in all lower case, with underscores to separate the components.
The names of struct fields often have a suffix to indicate the units, as shown below;
e.g. ``phase_width_us``, indicating units of microseconds.

=============   =====================================================================================
Suffix          Unit
=============   =====================================================================================
``s``           seconds
``us``          microseconds
``Hz``          Hertz
``dB``          decibel
``uA``          microamps
=============   =====================================================================================

The names of scalars that denote the number of items begin with the prefix ``num_``,
e.g. ``num_bands``, ``num_selected``.
The names of vectors that are strategy parameters are generally plural,
e.g. ``gains_dB``, ``weights``, ``best_freqs_Hz``.


Formatting Standards
=======================================================
|SW| ".m" files have the following standard format:

* The first line of the file is the function signature.
* The second line is a comment that contains a brief summary.
  This is called the H1 line.
  The ``lookfor`` function searches and displays this line.
* The following lines are more detailed comments,
  giving the full syntax of the call and a description of the input and output arguments.
* After that is one blank line,
  to stop the following lines from being displayed by the help command.
* The following comment lines contain the author and copyright statement.
