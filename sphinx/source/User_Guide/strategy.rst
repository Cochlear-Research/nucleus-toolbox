################################################################################
Strategy
################################################################################

The ``Strategy`` folder has functions for chaining together
processing functions to construct an entire sound coding signal path.

.. module:: Strategy
.. autofunction:: ACE_map
.. autofunction:: CIS_map

``ACE_map`` creates a "map" for the ACE sound coding strategy,
using the :ref:`processing`.
Similarly, ``CIS_map`` creates a map for the CIS sound coding strategy.
The map is a struct that contains all the parameters needed to process audio
according to the sound coding strategy.
It is created by a series of calls to :func:`Append_process`.
Each call sets up the parameters for a processing function,
and adds that function to the signal path.

.. include:: /_generated/ace_procs.txt

Each of these processing functions will be described briefly.

:func:`Audio_proc` reads an audio file (e.g. a wav file),
resamples if necessary, and applies calibration.

:func:`Freedom_microphone_proc` emulates the frequency response of the
Freedom directional microphone,
which is the same as the "Standard" directionality setting
on more recent Nucleus sound processors.

:func:`FE_AGC_proc` is a simple Front-end Automatic Gain Control.

:func:`FFT_VS_filterbank_proc` is a quadrature filterbank,
implemented with a FFT.
Each output sample is a complex value;
the real part represents samples of an in-phase filter,
and the imaginary part represents samples of a quadrature filter.
Hence the quadrature envelope can be obtained by taking
the absolute value of the complex samples (:func:`Abs_proc`).
Each filter in the filterbank has unity gain at its centre frequency.
:func:`Gain_proc` applies gain so that a 65 dB SPL speech signal
occasionally reaches full scale.

In the ACE strategy, only the largest samples from each
envelope vector are selected for stimulation.
The maxima selection process could be implemented in one function,
which would extract the largest samples from each envelope vector,
and store them into a Channel-Magnitude sequence.
However, it is beneficial to break it up into two processes:

-  :func:`Reject_smallest_proc` takes an FTM as input,
   and it returns an FTM the same size as the input,
   with the smallest samples in each column set to NaN,
   and the remaining (largest) samples left unchanged.

-  :func:`Collate_into_sequence_proc`
   takes an FTM of envelopes as input,
   and returns a Channel-Magnitude sequence.
   It knows that any NaN samples
   should be skipped when creating the sequence.

The main benefit of breaking maxima selection into two steps
is that the function :func:`Collate_into_sequence_proc`
can be re-used in the CIS strategy.
Furthermore, it allows the effect of maxima selection
to be shown directly on an FTM image.

:func:`LGF_proc` applies instantaneous non-linear compression,
also known as a Loudness Growth Function.

:func:`Channel_mapping_proc` uses recipient-specific channel
parameters to map a Channel-Magnitude sequence into a
Electrode-Current_level sequence.

