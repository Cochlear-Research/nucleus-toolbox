################################################################################
Filterbank
################################################################################

This section describes the key functions in the :file:`Filterbank` directory.

.. module:: Filterbank
.. autofunction:: FFT_filterbank_proc
.. autofunction:: FFT_VS_filterbank_proc

The output of :func:`FFT_filterbank_proc` is a complex FTM of size
(``p.num_bins`` × ``num_blocks``).
Each row is the output of a quadrature pair of filters:
the real part represents samples of an in-phase filter,
and the imaginary part represents samples of a quadrature filter.
The filters' centre frequencies (``p.best_freqs_Hz``)
are equal to the FFT bin frequencies (``p.bin_freqs_Hz``);
thus the filters all have equal bandwidth and are linearly spaced in frequency.

For a cochlear implant, we need to combine the FFT bin filters
into a smaller number of filters corresponding to
the number of electrode channels in use (``p.num_bands``).
The processing in :func:`FFT_VS_filterbank_proc` comprises :func:`FFT_filterbank_proc`,
followed by multiplication by a (real) ``p.weights`` matrix.
Most of the code in :func:`FFT_VS_filterbank_proc`
is the calculation of the ``p.weights`` matrix.
The ``p.weights`` are scaled so that each band has unity gain at its centre frequency.
The output of :func:`FFT_VS_filterbank_proc` is a complex FTM of size
(``p.num_bands`` × ``num_blocks``).
Once again, each row is the output of a quadrature pair of filters.
The filters' centre frequencies (``p.best_freqs_Hz``)
are no longer evenly spaced.
