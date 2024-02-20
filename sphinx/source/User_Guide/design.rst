################################################################################
Design
################################################################################

This section describes the software design of |SW|.

|SW| provides a minimal implementation of the ACE\ :sup:`TM` and CIS
sound coding strategies that are used in Nucleus sound processors.
|SW| does not implement the following advanced sound processing features:

- SCAN (audio scene classifier)
- Zoom (directional microphone)
- Beam (adaptive beamformer)
- ForwardFocus
- Whisper
- Autosensitivity
- ADRO
- Wind Noise Reduction
- SNR-NR (SNR-based noise reduction)


The following sections describe the |SW| signal path:

..  toctree::

    strategy
    filterbank
    ftm
    sequence
