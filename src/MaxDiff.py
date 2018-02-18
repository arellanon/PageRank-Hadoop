#!/usr/bin/env python
# encoding: utf-8
import sys

def reducer():
    pre_node = node = diff = max_diff = None
    peso_default = 1
    for line in sys.stdin:
        data = line.strip().split()
        node = data[0]
        valor = data[1]
        if (valor.find("#") == 0 ) : #Si tiene '#' significa que es el peso del nodo
            valor = valor.replace('#', '')
        valor = float(valor)

        if node == pre_node:
            diff = abs(pre_valor - valor)
        else:
            if pre_node:
                max_diff = diff if diff > max_diff else max_diff
#                print "%s %s" % (pre_node, diff)
                pre_node = node
                pre_valor = valor
                diff=None
            else :
                pre_node = node
                pre_valor = valor
                diff=None
    if pre_node:
        max_diff = diff if diff > max_diff else max_diff
    if max_diff != None :
        print "%s" % (max_diff)
    else :
        print "%s" % (100.00) #por la primer iteracion    
reducer()
