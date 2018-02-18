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
        #agregamos contribucion 0 para el nodo en caso que no tenga aristas entrantes
        print "%s %s" % (node, 0)
        try:
            count_node = len(data[2])
            for to_node in data[2]:
                print "%s %s" % (to_node[0], (float(value) / count_node) )
        except IndexError:
            continue
mapper()
