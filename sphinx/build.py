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

from attr import define, field
import yaml

from summarize_tests import summarize_tests

################################################################################
# Paths:

this_path = Path(__file__).parent
build_path = this_path / 'build'
mat_path = this_path / '../matlab'
test_result_path = mat_path / 'test_out'
gen_dir = '_generated'
gen_path = this_path / 'source' / gen_dir

# Output files:
results_path = gen_path / 'test_results.txt'

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
        summarize_tests()

    if args.copy:
        copy_html()

################################################################################

if __name__ == "__main__":

    config_logging()
    main()