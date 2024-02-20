""" pytest configuration script.
"""
################################################################################
# Authors: Brett Swanson
# Copyright (c) Cochlear Ltd
################################################################################

import pytest
from cochlear.nmt import LGF, from_dB

################################################################################

@pytest.fixture
def lgf_class():
    return LGF

