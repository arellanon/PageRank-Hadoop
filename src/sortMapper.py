#!/usr/bin/env python
# encoding: utf-8
import sys

def mapper():
    for line in sys.stdin:
	data = line.strip().split()
        print "%s\t%s" % (data[0],data[1])

mapper()
