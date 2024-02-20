""" Test of the loudness growth function processing
"""
################################################################################
# Authors: Brett Swanson
# Copyright (c) Cochlear Ltd
################################################################################

import pytest
import numpy as np
from cochlear.nmt import from_dB

################################################################################

@pytest.mark.parametrize("dynamic_range_dB", [30.0, 40.0])
@pytest.mark.parametrize("q", [10.0, 20.0, 30.0])
def test_LGF(lgf_class, dynamic_range_dB, q):
    p = lgf_class(dynamic_range_dB=dynamic_range_dB, Q=q, sub_mag=-1.0)

    # input < base_level should give output = sub_mag:
    x = np.linspace(0.0, p.base_level, num=8, endpoint=False)
    y = p.process(x)
    assert np.all(y == p.sub_mag)

    # input == base_level should give output = 0.0:
    x = np.array([p.base_level])
    y = p.process(x)
    assert y == [0.0]

    # input >= sat_level should give output = 1.0:
    x = np.linspace(p.sat_level, p.sat_level * 2.0, num=8)
    y = p.process(x)
    assert np.all(y == 1.0)

    # Q is defined as the percentage decrease in the output
    # for an input 10 dB below the saturation level:
    x = np.array([p.sat_level * from_dB(-10.0)])
    y = p.process(x)
    assert np.allclose(y, 1.0 - p.Q / 100.0, 0.01)

    # base_level < input < sat_level should be monotonically increasing:
    x = np.linspace(p.base_level, p.sat_level, num=64)
    y = p.process(x)
    assert np.all(np.diff(y) > 0)
