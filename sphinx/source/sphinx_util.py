""" Utilities for sphinx documentation.
"""
################################################################################
# Author: Brett Swanson
# Copyright (c) Cochlear Ltd
################################################################################

from attrs import define

################################################################################

class Sub:
    rst = ''

    @staticmethod
    def sub(name, expansion):
        Sub.rst += f'.. |{name}| replace:: {expansion}\n'

################################################################################

@define
class Doc:
    ''' Class for non-Sphinx documents, just creates text substitutions.
    '''
    title:      str         # Full title.
    ref:        str         # Reference used to refer to this document from other documents.
    windchill:  str = 'WC?' # Windchill reference number.
    wc_ver:     str = '?'   # Windchill version.


    def __attrs_post_init__(self):
        Sub.sub(self.ref, self.title)
        Sub.sub(self.ref + '_wc', self.windchill)
        Sub.sub(self.ref + '_with_wc', f'{self.title} [{self.windchill}]')

################################################################################

@define
class SDoc(Doc):
    ''' Class for Sphinx documents.
    '''
                            # ref must be the path to the sub-directory.
    author: str = ''        # Author(s).
    public: bool = False

    sdocs = []              # class variable


    def __attrs_post_init__(self):
        # Each sub can also be a hyperlink (for html builder)
        Sub.sub(self.ref,              f':doc:`{self.title}                    </{self.ref}/index>`')
        Sub.sub(self.ref + '_wc',      f':doc:`{self.windchill}                </{self.ref}/index>`')
        Sub.sub(self.ref + '_with_wc', f':doc:`{self.title} [{self.windchill}] </{self.ref}/index>`')
        SDoc.sdocs.append(self)


    def latex_tuple(self):
        return (
                self.ref + '/index',    # source start file
                self.ref + '.tex',      # target file name
                '',                     # get title from source start file
                self.author,            # author
                'howto',                # document class
                )
