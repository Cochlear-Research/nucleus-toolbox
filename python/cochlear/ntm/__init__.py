""" Python wrapper for Nucleus Toolbox for MATLAB (NTM)
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


class PrepPercentileEstimator(cochlear.sonic.adro.PrepPercentileEstimator):

    def prepare(self):
        super().prepare()
        p = engine.PrepPercentileEstimator(
            float(self.analysis_rate_Hz),
            float(self.rank),
            float(self.slew_rate),
            )
        # Get a dict holding all the properties of the MATLAB object:
        d = engine.struct(p)
        self.ratio = d['ratio']
        # Create matching sub-objects:
        rise = d['rise']
        fall = d['fall']
        self.rise = PrepSlew(rise['rate_Hz'], rise['slew_rate'])
        self.fall = PrepSlew(fall['rate_Hz'], fall['slew_rate'])
