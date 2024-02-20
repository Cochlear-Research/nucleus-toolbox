################################################################################
Architecture
################################################################################

This section describes the software architecture of |SW|.

|SW| comprises many small functions which each perform one task.
Each function is contained in its own ".m" file, as MATLAB requires.
The object-oriented features of MATLAB are not used.
The functions are organised into folders,
each covering a different part of the signal path.

A :ref:`processing` is defined
that allows small processing functions to be cascaded into an entire signal path.

|SW| assumes that the entire audio signal fits in memory,
and each processing function processes the entire signal in one call.
Modern PCs have sufficient memory to handle audio signals
of many minutes duration.
|SW| was not designed for real-time processing,
where successive small blocks of samples are processed repeatedly in a loop.

..  toctree::

    conventions.rst
    data_rep.rst
    process.rst

