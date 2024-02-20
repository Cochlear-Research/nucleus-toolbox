""" Script to generate tables from test result outputs
"""
################################################################################
# Authors: Brett Swanson
# Copyright (c) Cochlear Ltd
################################################################################

from dataclasses import dataclass, field
from datetime import datetime
import functools
import json
import logging
from operator import attrgetter
import os
from pathlib import Path, PureWindowsPath, PurePosixPath
import re

import pandas as pd
import yaml

##########################################################################

logger = logging.getLogger(__name__)

################################################################################

# Directories:
gen_path = Path("source/_generated")
py_test_result_path = Path("../python/test/test_out")
mat_test_result_path = Path("../matlab/test_out")

# Output files:
summary_path = gen_path / "test_summary.txt"
results_path = gen_path / "test_results.txt"

################################################################################

block_header = """
.. _run{block_num}:

Run {block_num} ({test_type})
========================================

..  csv-table::
"""

result_table_header = """
..  csv-table::
    :header-rows: 1

"""

summary_table_header = """
..  csv-table:: Summary of Tests and Results
    :name: test_summary
    :header-rows: 1

    Run, Type, Environment, Platform, Number of Tests Passed / Run
"""

##########################################################################


class FileNameMatcher:
    file_name_regex = r".*"

    def __init__(self, path, match=None):
        logger.info(path)
        self.path = Path(path)
        if match is None:
            match = re.match(cls.file_name_regex, self.name)
            assert match
        self.match = match
        self.process()

    def __str__(self):
        return str(self.__dict__)

    @classmethod
    def walk(cls, path):
        """Search recursively through path, yielding an instance for each matching file name."""
        logger.debug(path)
        logger.debug(cls.file_name_regex)
        path = Path(path)
        if not path.is_dir():
            raise NotADirectoryError("Directory {} not found".format(path))
        for dir_path, dir_names, file_names in os.walk(path):
            for file_name in file_names:
                logger.debug(file_name)
                match = re.match(cls.file_name_regex, file_name)
                if match:
                    yield cls(Path(dir_path) / file_name, match)

    def process(self):
        pass


################################################################################


class TestRun(FileNameMatcher):
    test_type: str

    def process(self):
        logger = logging.getLogger(__name__ + "." + self.test_type)
        self.read()
        self.process_meta()
        logger.debug(self.meta)
        self.process_results()
        logger.debug(self.results)

    def summarize_results(self):
        r = self.results["Result"]
        self.num_test = len(r)
        self.num_pass = sum(r)

    def summary_row_str(self, block_num):
        return f'    :ref:`{block_num} <run{block_num}>`, {self.test_type}, {self.meta["environment"]}, {self.meta["platform"]}, {self.num_pass}/{self.num_test}'

    def print_block(self, block_num, f_out):
        self.print = functools.partial(print, file=f_out)
        s = block_header.format(block_num=block_num, test_type=self.test_type)
        self.print(s)
        self.print_meta()
        self.print_result()

    def print_meta(self):
        for name, value in sorted(self.meta.items()):
            name = name.replace("_", " ")
            if name[0].islower():
                name = name.capitalize()
            self.print(f"    {name}, {value}")

    def print_result(self):
        self.print(result_table_header, end="")
        self.print("    Test, Result")
        for row in self.results.itertuples():
            if row.Result:
                result_str = "Pass"
            else:
                # Create a hyperlink to a discussion of the test failure:
                result_str = f":ref:`Fail <fail_{row.Test}>`"
            self.print(f"    {row.Test}, {result_str}")
        self.print()


################################################################################


class MatlabTestRun(TestRun):
    file_name_regex = r"test-([\d-]*).log"
    test_type = "MATLAB"

    def read(self):
        self.results = []
        with open(self.path, "rt") as f:
            for line in f:
                if line.startswith("    "):
                    # Line is a directory name, ignore it.
                    continue
                if line == "---\n":
                    # Line is the YAML start-of-document marker.
                    break
                # Line is a test result and name:
                self.results.append(line)

            # Parse the remainder of the file as YAML:
            self.meta = yaml.safe_load(f)

    def process_meta(self):
        self.meta["environment"] = self.meta.pop("matlab_version")
        self.meta.pop("duration")

    def process_results(self):
        # Convert list of strings to a Pandas DataFrame:
        df = pd.Series(self.results).str.split(expand=True)
        df["Result"] = df.pop(0).map({"FAIL:": 0, "Pass:": 1})
        df = df.rename(columns={1: "Test"})
        self.results = df
        self.summarize_results()
        num_pass = self.meta.pop("num_pass")
        num_test = self.meta.pop("num_test")
        result = self.meta.pop("result")
        assert self.num_pass == num_pass
        assert self.num_test == num_test
        if num_pass == num_test:
            assert result == "Pass"
        else:
            assert result == "Fail"


################################################################################


class PythonTestRun(TestRun):
    file_name_regex = r"result_(\d*_\d*).json"
    test_type = "Python"

    def read(self):
        with open(self.path, mode="rt") as f_in:
            # The first line is meta data in JSON format:
            j = f_in.readline()
            self.meta = json.loads(j)

            # The second line is pytest version:
            j = f_in.readline()  # discard

            # Remainder is read into a DataFrame:
            self.results = pd.read_json(f_in, lines=True)

    def process_meta(self):
        date_time_str = self.match.group(1)
        self.meta["date_time"] = datetime.strptime(date_time_str, "%Y%m%d_%H%M%S")
        self.meta["environment"] = self.meta.pop("matlab_version")

        # Find conda environment name:
        exe = self.meta.pop("executable")
        if exe.endswith(".exe"):
            exe_path = PureWindowsPath(exe)
        else:
            exe_path = PurePosixPath(exe)
        parts = exe_path.parts
        env_index = parts.index("envs")
        self.meta["python_environment"] = parts[env_index + 1]

    def process_results(self):
        df = self.results
        df.drop(index=0, inplace=True)  # drop first line

        # Just look at TestReports:
        k = df["$report_type"] == "TestReport"
        df = df[k]

        # A test has (at most) 3 phases: setup, call, teardown.
        # Just extract the "call" phase (omits skipped tests)
        k = df["when"] == "call"
        df = df[k]

        # Remove unnecessary columns:
        del df["$report_type"]
        del df["result"]
        del df["location"]
        del df["keywords"]
        del df["exitstatus"]
        del df["when"]
        del df["longrepr"]
        del df["sections"]
        del df["duration"]
        del df["user_properties"]

        # Adjust columns:
        df["Test"] = df.pop("nodeid").str.replace("test/", "")
        df["Result"] = df.pop("outcome").map({"failed": 0, "passed": 1})

        self.results = df
        self.summarize_results()


################################################################################


def summarize_tests():
    # Inputs:
    mat_result_list = list(MatlabTestRun.walk(mat_test_result_path))
    py_result_list = list(PythonTestRun.walk(py_test_result_path))
    result_list = mat_result_list + py_result_list
    result_list.sort(key=lambda r: r.meta["date_time"])

    # Summary table:
    with open(summary_path, mode="wt") as f_out:
        print(summary_table_header, end="", file=f_out)
        for n, r in enumerate(result_list):
            print(r.summary_row_str(n + 1), file=f_out)

    # Table of results for each block of tests:
    with open(results_path, mode="wt") as f_out:
        for n, r in enumerate(result_list):
            r.print_block(n + 1, f_out)

    return result_list


################################################################################

if __name__ == "__main__":
    summarize_tests()
