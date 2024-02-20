""" Python script to perform regular expression replacements on text files.
"""
################################################################################
# Authors: Brett Swanson
# Copyright (c) Cochlear Ltd
################################################################################

import argparse
from pathlib import Path
import re
import shutil

################################################################################


class Replacement:

    def __init__(self, old: str, new: str):
        "Compile the regular expression, matching whole words."
        self.rex = re.compile(old)
        self.new = new
        self.count = 0  # The number of replacements that have been made.

    def reset(self):
        "Reset the count to zero, and return its old value."
        count = self.count  # copy, so that it can be returned.
        self.count = 0
        return count

    def replace(self, string):
        """Replace regular expression, and return the new string.
        Also accumulate the number of replacements.
        """
        new_string, count = self.rex.subn(self.new, string)
        self.count += count
        return new_string


################################################################################


def main(replacements, glob_pattern):

    description = """\
    Perform text replacements on all matching files in the specified directory tree.
    Prints the number of replacements performed in each modified file.
    If non-zero, the original file is copied with a ".bak" extension.
    """

    parser = argparse.ArgumentParser(description=description)
    parser.add_argument("directory", help="directory to search")
    parser.add_argument("--verbose", "-v", action="store_true", help="also print names of unmodified files")
    parser.add_argument("--dry_run", "-d", action="store_true", help="print file names but perform edit on temp copy of files")
    args = parser.parse_args()

    paths = sorted(Path(args.directory).glob(glob_pattern))
    for in_path in paths:
        tmp_path = in_path.with_suffix(".temp")
        with open(in_path, "rt") as in_file:
            with open(tmp_path, "wt") as out_file:
                for line in in_file:
                    if line == "\n":
                        # No need to inspect blank lines; just copy it.
                        print(line, end="", file=out_file)
                    else:
                        for r in replacements:
                            line = r.replace(line)
                        # If the final line after replacement is blank, do not copy it.
                        if line != "\n":
                            print(line, end="", file=out_file)

        counts = [r.reset() for r in replacements]
        count = sum(counts)
        if args.verbose or count > 0:
            print(count, in_path)

        if count == 0:
            # Remove temp file:
            tmp_path.unlink()
        else:
            if not args.dry_run:
                # Back up original file:
                in_path.rename(in_path.with_suffix(".bak"))
                # Replace original file with temp file:
                tmp_path.rename(in_path)


