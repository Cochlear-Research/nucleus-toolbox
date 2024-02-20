""" Python wrapper for Nucleus MATLAB Toolbox (NMT)
"""
################################################################################
# Authors: Brett Swanson
# Copyright (c) Cochlear Ltd
################################################################################

from dataclasses import dataclass, asdict
import matlab
import matlab.engine
import numpy as np

################################################################################

engine = matlab.engine.connect_matlab()

################################################################################
# Utility functions


def to_dB(gain: float) -> float:
    "Convert multiplicative gain to decibels."
    return 20.0 * np.log10(abs(gain))


def from_dB(gain_dB: float) -> float:
    "Convert gain in decibels to multiplicative gain."
    return 10.0 ** (gain_dB / 20.0)

################################################################################

@dataclass
class LGF:

    #: Dynamic range (in decibels).
    dynamic_range_dB: float = 40.0
    #: Percentage decrease of output when input is 10 dB below saturation level.
    Q: float = 20.0
    #: Saturation level, i.e. input level that produces an output of 1.0.
    sat_level: float = 1.0
    #: Output value used for inputs below lower end of dynamic range.
    sub_mag: float = -0.1

    def __post_init__(self):
        self.prepare()

    def prepare(self):
        # Create a new dict containing the clinical parameters:
        d = asdict(self)
        # Calculate the derived parameters in NMT:
        p = engine.LGF_proc(d)
        # Store it for subsequent use in "process":
        self.mat_struct = p
        self.base_level = p['base_level']  # test_LGF needs this.

    def process(self, x):
        x = matlab.double(vector=x)
        y = engine.LGF_proc(self.mat_struct, x)
        return np.array(y).flatten()
