################################################################################
Changes and Issues
################################################################################

|SW| was previously released as "Nucleus MATLAB Toolbox" (NMT)
to selected cochlear implant research centres.
The last release was 4.31.

|SW| |release| is the first public release of |SW|.
It now uses Semantic Versioning (https://semver.org).
|SW| |release| is a major release,
and scripts written for NMT 4.31 may need to be revised
to run with |SW| |release|.

Changes and issues were tracked in Cochlear's internal Jira system,
and are summarized below.


Improvements and New Features
======================================================

- SRES-101: Default ACE map should better match Nucleus sound processor.

  The default parameter struct produced by :func:`ACE_map`
  is now a better match to recent models of Nucleus sound processor.

- SRES-102: Declutter and simplify.

  Many obsolete files have been removed.
  The Psychophysics directory (for runnning psychophysics procedures)
  was little used, and has been separated out from |SW|.

- SRES-105: Convert documentation to Sphinx and update.

  This documentation was created using
  `Sphinx <https://www.sphinx-doc.org>`_.

- SRES-115: Update for latest MATLAB release.

  In the years since the release of NMT 4.31,
  MATLAB has undergone many changes,
  some of which were not backward compatible.
  |SW| |release| runs under MATLAB R2023b,
  which is the latest release at the time of this release report.

- SRES-217: Improve compatibility with NIC.

  A pulse sequence produced by :func:`ACE_map`
  can be more easily streamed by NIC.

- SRES-218: Use function handles in the Processing framework.

  Mathworks recommend using function handles
  instead of the previous function name strings.

- SRES-252: Create MATLAB installer.

  Nucleus Toolbox is now distributed as a .mltbx file.

- SRES-253: Improve implant parameters and current level calculations.

  Having implant parameters as a sub-struct was inconsistent
  with all the other parameters, and caused unnecessary complexity.

- SRES-255: Rename processing parameters.

  Some processing parameters have been renamed.
  Many now have a suffix to indicate the units;
  e.g. ``phase_width`` was renamed to ``phase_width_us``,
  indicating units of microseconds.

  The Python script ``/python/cochlear/nmt/rename_fields.py``
  is provided to assist with updating user scripts.


Bug Fixes
======================================================

- SRES-90: Unexpected behaviour if num_selected > num_bands.

  Previously :func:`ACE_map` gave unexpected behaviour if it was given
  a parameter struct ``p`` that mistakenly had ``p.num_selected > p.num_bands``.
  This error is now detected.

Known Issues
======================================================

There are no known issues.

