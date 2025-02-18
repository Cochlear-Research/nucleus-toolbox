""" Test of NMT current law calculations
"""
################################################################################
# Authors: Brett Swanson
# Copyright (c) Cochlear Ltd
################################################################################

import numpy as np
import pytest
import matlab
from cochlear.nmt import engine
from cochlear.nmt import current

################################################################################

@pytest.mark.parametrize(
    'chip,      min_ua,      base', [
    ('CIC3',      10.0,     175.0),
    ('CIC4',      17.5,     100.0),
    ])
def test_current(chip, min_ua, base):

    p = {'chip': chip}
    p = engine.Current_level_to_microamps_proc(p)
    assert p['MIN_CURRENT_uA'] == min_ua
    assert p['CURRENT_BASE'] == base

    cl_mat = matlab.double(range(256))
    ua_mat = engine.Current_level_to_microamps_proc(p, cl_mat)

    cls = eval('current.' + chip)
    cl_py = np.array(cl_mat)
    ua_py = cls.calc_uA_from_CL(cl_py)
    assert np.allclose(ua_py, ua_mat)

    cl_mat2 = engine.Microamps_to_current_level_proc(p, ua_mat)
    assert cl_mat2 == cl_mat
