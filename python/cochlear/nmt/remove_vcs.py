""" Python script to remove VCS keyword lines from .m files
"""
################################################################################
# Authors: Brett Swanson
# Copyright (c) Cochlear Ltd
################################################################################

from replace_in_files import Replacement, main

################################################################################

r = Replacement(r"%(\s)*\$(Header|Change|Revision|DateTime): .*", "")
main([r], "**/*.m")
