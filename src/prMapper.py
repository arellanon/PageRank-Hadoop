#!/usr/bin/env python
# encoding: utf-8
import sys
import json

def mapper():
    from_node = from_node_value = None
    for line in sys.stdin:
        data = json.loads(line)

        node = data[0]
        value = data[1]
        try:
            count_node = len(data[2])
            # Do something with item
            for to_node in data[2]:
                print "%s %s" % (to_node[0], value / count_node)
        except IndexError:
            continue
            # Do something without the item
mapper()
