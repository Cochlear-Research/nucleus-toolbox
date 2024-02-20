""" Export MATLAB live scripts to Restructured Text.
"""
################################################################################
# Author: Brett Swanson
# Copyright (c) Cochlear Ltd
################################################################################

import argparse
import logging
import logging.config
from pathlib import Path, PurePosixPath
import textwrap
import re

################################################################################

logger = logging.root

live_dir = Path("../matlab/LiveScripts")
gen_dir = Path("_generated")
export_dir = Path("source") / gen_dir

################################################################################

re_begin = re.compile(r"^\\begin\{(\w*)\}")
re_end = re.compile(r"^\\end\{(\w*)\}")
re_code = re.compile(r"\\texttt\{(.*?)\}")
re_ital = re.compile(r"\\textit\{(.*?)\}")
re_fig = re.compile(r"figure_[0-9]*.png")


def text_style_repl(m: re.Match):
    # remove any '\'
    s = m[1].replace("\\", "")
    return f"``{s}``"


##########################################################################


def config_logging(config_file_name="log_config.yaml"):
    """Configure logging from YAML file in current directory.
    If file is not found, assume logging is not required.
    """
    try:
        with open(config_file_name) as f_config:
            import yaml

            d = yaml.load(f_config, yaml.Loader)
            logging.config.dictConfig(d)
            logger.info(f"logging configured from {config_file_name}")
    except IOError:
        pass


################################################################################


def convert_tex_to_rst(dir_path, tex_path):

    rst_path = tex_path.with_suffix(".txt")
    # Sphinx uses Posix paths, even on Windows.
    # The following path is not accessed by this script,
    # but is written to the ReStructuredText file.
    # The path must be relative to the source dir.
    fig_folder = PurePosixPath("/") / PurePosixPath(gen_dir) / (tex_path.stem + "_media")

    with open(tex_path, "rt") as tex_f, open(rst_path, "wt") as rst_f:

        print(f".. rubric:: Live script: {tex_path.stem}.mlx\n", file=rst_f)

        state = []
        for line in tex_f:
            if m := re_begin.match(line):
                # Beginning of a tex environment:
                env = m.group(1)
                state.append(env)
                logger.debug(state)
                if env.startswith("matlab"):
                    print("::\n", file=rst_f)
                continue

            if m := re_end.match(line):
                # End of a tex environment:
                env = m.group(1)
                if env.startswith("matlab"):
                    print(file=rst_f)
                top = state.pop()
                logger.debug(state)
                assert top == env
                continue

            if state:
                top = state[-1]
                if top.startswith("matlab"):
                    # Indent each line:
                    print("    ", line, end="", file=rst_f)

                elif top == "center":
                    # Expect to contain only a single includegraphics line:
                    assert line.startswith('\\includegraphics')
                    m = re_fig.search(line)
                    logger.debug(m)
                    assert m, "Expected figure"
                    print(f".. figure:: {fig_folder}/{m[0]}", file=rst_f)

                else:
                    # Descriptive text; translate text styles:
                    line = re_code.sub(text_style_repl, line)
                    line = re_ital.sub(r'*\1*\\ ', line)
                    print(line, end="", file=rst_f)


################################################################################


def convert_all_tex_to_rst(dir_path):

    dir_path = Path(dir_path)
    for file_path in dir_path.glob("*.tex"):
        logger.info(file_path)
        convert_tex_to_rst(dir_path, file_path)


################################################################################


def export_all_mlx_to_tex(in_dir, out_dir):

    from cochlear.nmt import engine

    # Set MATLAB working directory the same as Python:
    engine.cd(str(Path.cwd()))

    in_dir = Path(in_dir)
    out_dir = Path(out_dir)
    for in_path in in_dir.glob("*.mlx"):
        stem = in_path.stem
        out_path = str((out_dir/stem).with_suffix(".tex"))
        in_path = str(in_path)
        logger.info((in_path, out_path))
        engine.export(in_path, out_path)

################################################################################

if __name__ == "__main__":

    config_logging()
    parser = argparse.ArgumentParser(description="Export MATLAB live scripts")
    parser.add_argument('-t', '--tex', action='store_true', help='Export .mlx to .tex in MATLAB')
    parser.add_argument('-r', '--rst', action='store_true', help='Convert .tex to .rst')
    args = parser.parse_args()

    if args.tex:
        export_all_mlx_to_tex(live_dir, export_dir)

    if args.rst:
        convert_all_tex_to_rst(export_dir)
