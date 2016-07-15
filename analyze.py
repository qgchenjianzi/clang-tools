# -*- coding: utf-8 -*-
__author__ = 'currychen'

import re
 



# Separating the clang-log in global log
def read_log_lines(file):
    result = list()
    f = open(file,'r')
    exp = '(?<=\\bMMRewriter\s).*'
    pattern = re.compile(exp) 
    for line in f.readlines():
        line = line.strip()
        if not len(line):
            continue
        match = re.search(pattern,line)
        if match:
            result.append(match.group())
    return result;

if "__main__" == __name__:
    import sys
    if len(sys.argv) == 2:
        print read_log_lines(sys.argv[1])
