""" Python wrapper for Nucleus Toolbox for MATLAB Toolbox (NTM)
"""
################################################################################
# Authors: Brett Swanson
# Copyright (c) Cochlear Ltd
################################################################################

import matlab
import matlab.engine
import cochlear.sonic.adro

################################################################################

# Construct a single engine:
engine = matlab.engine.connect_matlab()

################################################################################

class PrepSlew(cochlear.sonic.adro.PrepSlew):

    def prepare(self):
        super().prepare()
        p = engine.PrepSlew(float(self.rate_Hz), float(self.slew_rate))
        self.step_dB = engine.Get_value(p, 'step_dB')
        self.scaler = engine.Get_value(p, 'scaler')
