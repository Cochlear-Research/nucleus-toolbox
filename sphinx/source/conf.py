# Configuration file for the Sphinx documentation builder.
#
# This file only contains a selection of the most common options. For a full
# list see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Path setup --------------------------------------------------------------

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.

import os
import sys
from pathlib import Path

sys.path.insert(0, os.path.abspath('.'))
from sphinx_util import Sub
import docs
sys.path.insert(0, os.path.abspath('..'))
import build

################################################################################
# Project information

project = 'Nucleus Toolbox'
copyright = '2024, Cochlear Ltd'
author = 'Brett Swanson'

# The full version, including alpha/beta/rc tags
release = build.extract_version()
today = ' '

################################################################################
# Common substitutions.

Sub.sub('project',          f'{project}')
Sub.sub('SW',               'Nucleus Toolbox')
Sub.sub('SWr',              'Nucleus\ :sup:`®` Toolbox')
Sub.sub('installer',        f':code:`nucleus{release}.mltbx`')
Sub.sub('NIC',              'Nucleus Implant Communicator')

rst_epilog = Sub.rst

################################################################################
# General configuration

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = [
    'sphinx.ext.autodoc',
    'sphinx.ext.graphviz',
    'sphinx.ext.napoleon',
    'sphinxcontrib.matlab',
]

# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']

# Automatically number figures and tables that have captions:
numfig = True
numfig_secnum_depth = 1

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path.
exclude_patterns = []

################################################################################
# Options for Matlab:

#highlight_language = 'python3'
primary_domain = "mat"
matlab_src_dir = "../../matlab"
matlab_short_links = True
matlab_auto_link = "basic"

################################################################################
# Options for autodoc

autodoc_member_order = 'bysource'
autodoc_mock_imports = ["pytest"]

# Napoleon settings
napoleon_google_docstring = True
napoleon_custom_sections = ['Pass criteria']
napoleon_use_rtype = False

################################################################################
# Options for HTML output

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
html_theme = 'classic'
html_show_sourcelink = False
html_theme_options = {
    'stickysidebar': True
}

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
# html_static_path = ['_static']
