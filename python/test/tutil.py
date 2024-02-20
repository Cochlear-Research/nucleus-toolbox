""" Top-level script and utility functions for use in testing.
"""
################################################################################
# Authors: Brett Swanson
# Copyright (c) Cochlear Ltd
################################################################################

import getpass
from importlib.metadata import metadata
import json
import os
from pathlib import Path
import platform
import sys
import time
import shutil
import pytest

################################################################################
#: The current date and time as a string suitable for a file name.
#: Defined as a module-level variable (i.e. the time of import)
#: so that all tests in a session share the same time-stamp.

time_stamp = time.strftime("%Y%m%d_%H%M%S")

################################################################################


def save_test_fig(fig, node):
    """Save a figure in the output directory
    with file name including the test name and timestamp.
    """
    if isinstance(node, str):
        test_name = node
    else:
        # Assume arg is a pytest node instance.
        # Remove characters that are not allowed in file names:
        test_name = node.name.replace("[", "_").replace("]", "")

    fig.suptitle(test_name)
    out_path = get_out_dir() / (test_name + time_stamp + ".png")
    fig.savefig(out_path)


################################################################################


def get_out_dir():
    """Return the path to the output directory, creating it if needed."""
    this_dir = Path(__file__).parent
    out_dir = this_dir / "test_out"
    out_dir.mkdir(exist_ok=True)
    return out_dir


################################################################################


def get_env_info():
    """Return information about the run-time environment."""
    return {
        "platform": platform.platform(),
        "computer": platform.node(),
        "user": getpass.getuser(),
        "executable": sys.executable,  # full path, so includes conda environment name
        "python_version": platform.python_version(),
    }


################################################################################


def run_tests(prefix: str):
    """Run pytest. Returns path to result file in JSON format."""
    out_dir = get_out_dir()
    date_time = time_stamp
    json_path = out_dir / f"{prefix}{date_time}.json"

    # Run the tests: no tracebacks, create JSON log, save plots to files without on-screen display:
    pytest.main(["--tb=no", f"--report-log={json_path}", "--plot=0"])
    return json_path


################################################################################


def prepend_info(info, orig_path, back_up=False):
    """Prepend additional info in JSON format to a file."""

    # Back up original file:
    orig_path = Path(orig_path)
    back_path = orig_path.with_suffix(".bak")
    orig_path.rename(back_path)

    # Write new file with same name as original:
    info_json = json.dumps(info)
    with open(orig_path, "wb") as f_out:  # binary for copyfileobj
        f_out.write(info_json.encode())  # encode string to bytes
        f_out.write("\n".encode())
        with open(back_path, "rb") as f_in:
            shutil.copyfileobj(f_in, f_out)

    if not back_up:
        os.remove(back_path)


################################################################################

if __name__ == "__main__":
    env_info = get_env_info()
    json_path = run_tests("result_")
    prepend_info(env_info, json_path)
