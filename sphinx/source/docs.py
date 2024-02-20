''' Sphinx document list
'''
################################################################################
# Author: Brett Swanson
# Copyright (c) Cochlear Ltd
################################################################################

from sphinx_util import Doc, SDoc

################################################################################
# Docs:

# Sphinx documents, built from this file:                                public?
#SDoc('Project Plan',    'Plan',            'NA',       '1', 'Fred Example', False),
#SDoc('Requirements',    'Requirements',    'NA',       '1', 'Fred Example', True),
SDoc('User Guide',      'User_Guide',      'NA',       '1', 'Brett Swanson', True),
SDoc('Release Report',  'Release_Report',  'NA',       '1', 'Brett Swanson', True),

################################################################################
# Other documents that are referred to from above documents:

# PIP docs:
Doc('Cochlear Quality Manual',                    'Cochlear_Quality_Manual',    '1141823')
