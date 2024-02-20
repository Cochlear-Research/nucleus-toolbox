"""Extract authors from MATLAB comments.
"""
################################################################################

import argparse
from pathlib import Path
import pyparsing as ps

################################################################################
# Define parser elements for Nucleus Toolbox for Matlab intro text:

percent = ps.Suppress("%")
name = ps.OneOrMore(ps.Word(ps.alphas))
names = ps.delimited_list(name)
authors = percent + ps.Suppress("Authors: ") + names

@name.set_parse_action
def join_name(s: str, loc: int, tokens: ps.ParseResults):
    return " ".join(tokens.as_list())

################################################################################

def main():

    parser = argparse.ArgumentParser(description="Extract help")
    parser.add_argument("directory", help="directory to search")
    args = parser.parse_args()

    author_info = {}
    paths = sorted(Path(args.directory).glob("**/*.m"))
    for in_path in paths:
        with open(in_path, "rt") as in_file:
            for line in in_file:
                try:
                    parsed = authors.parse_string(line)
                except ps.exceptions.ParseException:
                    pass
                else:
                    for author in parsed:
                        works = author_info.get(author, [])
                        works.append(in_path)
                        author_info[author] = works
                    break
            else:
                print(in_path, 'No authors')

    for author in sorted(author_info.keys()):
        print('-', author)

    for author, works in author_info.items():
        print(author)
        for f in works:
            print(f)

################################################################################

if __name__ == '__main__':
    main()
