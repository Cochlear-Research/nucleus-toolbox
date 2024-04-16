"""Build a MATLAB toolbox installer file for Nucleus Toolbox.
"""
################################################################################
# Author: Brett Swanson
# Copyright (c) Cochlear Ltd
################################################################################

import argparse
from datetime import date
import io
import logging
import logging.config
import os
from pathlib import Path
import re
import shutil
import stat
import subprocess

import yaml
from cochlear.sphinx.tester import MatlabTestRun, PythonTestRun, summarize_tests

################################################################################
# Paths:

this_path = Path(__file__).parent
build_path = this_path / 'build'
mat_path = this_path / '../matlab'
gen_path = this_path / 'source' / '_generated'

# Test results (input to summarize_tests):
py_test_result_path = Path("../python/test/test_out")
mat_test_result_path = Path("../matlab/test_out")

# Output files:
summary_path = gen_path / "test_summary.txt"
results_path = gen_path / "test_results.txt"

##########################################################################

logger = logging.getLogger("build")

##########################################################################


def config_logging(config_file_name="log_config.yaml"):
    """Configure logging from YAML file in current directory.
    If file is not found, assume logging is not required.
    """
    try:
        with open(config_file_name) as f_config:
            d = yaml.safe_load(f_config)
            logging.config.dictConfig(d)
            logger.info(config_file_name)
    except IOError:
        pass


################################################################################


def extract_version():

    version_str = ""
    f = open(mat_path / 'Nucleus_version.m', 'r')
    r = re.compile(r"= '(.*)';")
    for line in f:
        match = r.search(line)
        if match:
            return match.group(1)
    raise Exception("Could not find version number")


################################################################################


def copy_html():
    shutil.rmtree(mat_path / "html", ignore_errors=True)
    shutil.copytree(build_path / "html", mat_path / "html")
    shutil.copy("helptoc.xml", mat_path / "html")

################################################################################


def main():

    parser = argparse.ArgumentParser(description='Build NMT installer')
    parser.add_argument('-t', '--test', action='store_true', help='Summarize test results')
    parser.add_argument('-c', '--copy', action='store_true', help='Copy HTML & XML files')
    args = parser.parse_args()

    #nmt_ver = extract_version()

    if args.test:
        mat_result_list = list(MatlabTestRun.walk(mat_test_result_path))
        py_result_list = list(PythonTestRun.walk(py_test_result_path))
        result_list = mat_result_list + py_result_list
        Path(gen_path).mkdir(parents=True, exist_ok=True)
        summarize_tests(result_list, summary_path, results_path)

    if args.copy:
        copy_html()

################################################################################

if __name__ == "__main__":

    config_logging()
    main()