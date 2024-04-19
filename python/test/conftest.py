""" pytest configuration script.
"""
################################################################################
# Authors: Brett Swanson
# Copyright (c) Cochlear Ltd
################################################################################

import pytest
from cochlear.sphinx.tester import PythonMatlabTestRun as TestRun
from cochlear.nmt import engine, LGF

################################################################################


def pytest_sessionfinish(session):
    meta = TestRun.get_meta(engine)
    TestRun.save_report(session, meta)


################################################################################


@pytest.fixture
def lgf_class():
    return LGF
