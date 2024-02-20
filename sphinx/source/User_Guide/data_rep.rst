Data Representation
################################################################################

Only two basic data types are used in |SW|:

matrix
    This is a (R × C) rectangular array,
    where R is the number of rows,
    and C is the number of columns.
    Special cases are a row vector (1 × C),
    a column vector (R × 1), and a scalar (1 × 1).

struct
    This is a container with named fields.
    Each field is either a matrix or another struct.
    Fields are accessed with a dot notation, as in the C language or Python:
    for example, ``p.num_bands``.
    In the C language, the fields of a struct are defined at compile time:
    each struct is a distinct type,
    and it is a compile-time error to pass the wrong type of struct to a function.
    In contrast, a MATLAB struct is more flexible, behaving more like a Python object:
    it can have new fields added to it,
    and a function that expects a struct will work as long as
    the struct that is passed to it has fields with the correct names;
    if an attempt is made to access a non-existent field then a run-time occurs.

The following table summarises the ways in which data is represented as MATLAB variables
and stored on disk in |SW|.

=========================== ====================== ================== ==============
Signal Type                 MATLAB variable type   File format        File extension
=========================== ====================== ================== ==============
audio                       column vector          Wave               .wav
frequency-time matrix (FTM) two-dimensional matrix MATLAB binary data .mat
sequence                    struct                 MATLAB binary data .mat
=========================== ====================== ================== ==============

Audio Signal
=======================================================
Audio signals are commonly stored on disk as Wave files (:file:`.wav` extension).
They can be read into MATLAB using the function :func:`audioread`.
This returns a `(num_time_samples × 1)` matrix (i.e. a column vector)
with values in the range –1 to 1.
The sampling rate (in Hertz) can be read from the file into a second output argument, e.g.::

    [audio, sampling_rate_Hz] = audioread('asa.wav');

The built-in function :func:`soundsc` can be used
to play the sound using the PC’s sound output device, e.g.::

    soundsc(audio, sampling_rate_Hz);

.. Tip:: To write a MATLAB function so that it can accept either a row vector
   or a column vector as an input argument, begin like this::

        function foo(signal)
        signal = signal(:);  % force it to be a column vector

Frequency-Time Matrix (FTM)
=======================================================
In |SW|, the output of a filterbank is represented as a two-dimensional
`(num_bands × num_blocks)` matrix,
where `num_bands` is the number of filter bands,
and `num_blocks` is the number of output samples for each filter.
Note that in block-based processing (such as FFT filterbanks),
the filter output sampling rate is often less than the audio sampling rate;
i.e. `num_blocks < num_time_samples`.
Filter number or frequency runs down the columns, and time runs across the rows.
This format is referred to as a Frequency-Time-indexed Matrix (FTM).
It is convenient for further processing such as maxima selection,
because MATLAB operations act on columns by default.
In FFT based processing, the first row (lowest frequency index) is the lowest frequency band.
The magnitudes in an FTM are usually in the range 0 to 1;
however it can be convenient to use larger ranges in some circumstances.

An FTM can be displayed with the built-in :func:`imagesc` function.
This gives the familiar spectrogram-style display,
with time on the horizontal axis,
and filter number or frequency on the vertical axis.
(Note that if time ran down the columns,
then an inconvenient transpose operation would be required to display it as a spectrogram).
The directory ``FTM`` contains functions that deal with FTMs.
The function :func:`GUI_FTM` allows an interactive display of an FTM.
The built-in :func:`save` command will save an FTM in a
standard MATLAB binary data file (:file:`.mat` extension)
with double-precision floating point format.
Alternatively, the function :func:`Save_FTM` creates smaller files
by saving an FTM as 16-bit integers.

Pulse Sequence
============================================================
Each stimulation pulse is specified by a set of attributes.
Two types of pulse sequences, having different attributes,
are defined:

- Channel Magnitude sequence
- Electrode Current-level sequence


Channel Magnitude Sequence
------------------------------------------------------------

The output of :func:`Collate_into_sequence_proc`
is referred to as a Channel Magnitude sequence.
A Channel Magnitude sequence is a struct with three fields:

- channels
- magnitudes
- periods_us

The channel is an index in the range 1 to ``num_bands``
that specifies which filter band was sampled.
In |SW|, channel 1 is the lowest frequency channel
(note that the Nucleus implant electrodes are numbered in the opposite direction).
The magnitude is the corresponding sample value from the FTM.
The period is the time (in microseconds)
from the start of the pulse to the start of the next pulse.

Electrode Current-Level Sequence
------------------------------------------------------------
In the subsequent :func:`Channel_mapping_proc`,
the channel number is mapped to an active electrode and a stimulation mode,
and the magnitude is mapped to the current level and phase width of a stimulation pulse.
This mapping process uses recipient-specific information.
The result is referred to as an Electrode Current-Level sequence.
An Electrode Current-Level sequence is a struct with six fields:

- electrodes
- modes
- current_levels
- phase_widths_us
- phase_gaps_us
- periods_us

Sequence struct
------------------------------------------------------------

Several options were considered to represent pulse sequences in MATLAB.
One option would be to store a Channel Magnitude sequence as a (num_pulses × 3) matrix,
and an Electrode Current-Level sequence as a (num_pulses × 6) matrix.
One problem with this format is that when a matrix is passed to a function,
it is hard to verify that each column has the meaning that is assumed.
This can lead to programming errors.
A second problem is that it wastes space when a sequence parameter is constant.
For example, to specify the phase gap, a whole column must be used,
even if the phase gap is the same for all pulses.
Instead, a sequence is represented by a struct,
with one field for each parameter of the sequence.
Each field will either be a column vector, i.e. a (num_pulses × 1) matrix,
or if the parameter is constant the field will be a scalar i.e. a  (1 × 1) matrix.
This is a very flexible and space-efficient representation.

The directory :doc:`sequence` contains functions that deal with sequences.
