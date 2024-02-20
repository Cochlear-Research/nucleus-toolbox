""" Top-level testing script.
"""
################################################################################
# Authors: Brett Swanson
# Copyright (c) Cochlear Ltd
################################################################################

import platform
from tutil import get_env_info, run_tests, prepend_info
from cochlear.nmt import engine

################################################################################

if __name__ == "__main__":
    env_info = get_env_info()

    engine.eval("m = matlabRelease;", nargout=0)
    release = engine.eval("m.Release")
    update = int(engine.eval("m.Update"))
    env_info["matlab_version"] = f"{release}.{update}"
    env_info["platform"] = engine.computer('arch')
    env_info["nucleus_version"] = engine.Nucleus_version()
    env_info["platform_full"] = platform.platform()

    json_path = run_tests("result_")
    prepend_info(env_info, json_path)
