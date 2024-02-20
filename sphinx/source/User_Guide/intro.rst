################################################################################
Introduction
################################################################################

|SWr| is a collection of MATLAB\ :sup:`®` functions
implementing algorithms that are used in Nucleus cochlear implant systems.
MATLAB is a mathematical programming environment released by The MathWorks, Inc.
The intended audience of this documentation are engineers who are familiar with MATLAB.


Prerequisites
================================================================================

To use |SW|, you must have:

* MATLAB
* Signal Processing Toolbox


Installation
================================================================================

|SW| is distributed as a MATLAB toolbox installation file, |installer|.
Open this file (e.g. by double-clicking) and MATLAB will install it
into its usual "Add-Ons" folder, and add it to the MATLAB path.


Goals
================================================================================

|SW| was developed to meet several goals:

Specification
---------------
|SW| functions can act as specifications for signal processing algorithms.
The traditional way of specifying an algorithm is to write a document
containing mathematics and pseudocode.
It is hard to make these documents unambiguous and complete.
In contrast, a MATLAB implementation is concise, because the language is high-level,
and can be executed and tested to demonstrate that it is complete and correct.

Visualisation
---------------
MATLAB provides powerful graphics, sound and user interface capabilities that
can be used to demonstrate or visualise the operation of signal processing algorithms.

Development
---------------
The MATLAB environment is ideal for developing new signal processing algorithms.
Its interpreted, high-level language allows algorithms to be rapidly developed and tested.

Experimentation
---------------
|SW| can be used together with the |NIC| (NIC) software package.
Pre-recorded audio signals (e.g. .wav files) or synthesised audio signals can be processed
by |SW| and the resulting pulse sequences can be delivered to a cochlear implant recipient
by NIC.


A Quick Tour
================================================================================

The best way to learn about |SW| is by example.
Details are described in later sections.
The |SW| sub-directory ``LiveScripts`` contains several live scripts.
A MATLAB live script (.mlx file) contains formatted text, MATLAB commands, and their results.
You can open them in MATLAB, edit them, and re-run them.
This User Guide incorporates several of these examples.



.. include:: /_generated/quick_tour.txt
