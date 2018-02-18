#!/usr/bin/env python
# encoding: utf-8
import sys

def reducer():
    pre_node = node = peso = resultado = edge = None
    peso_default = 1
    for line in sys.stdin:
        data = line.strip().split()
        node = data[0]
        valor = data[1]
        if node == pre_node:
            if (valor.find("#") == 0 ) : #Si tiene '#' significa que es el peso del nodo
                peso = valor.replace('#', '')
            else :
                edge = '[' +valor + ',1]'
                if resultado == None: #Si es el primer edges se agrega sin separador ','
                    resultado = edge
                else:
                    resultado = resultado + ',' + edge
            pre_node = node
            pre_peso = peso
        else:
            if pre_node:
                pre_peso = pre_peso if pre_peso else peso_default
                if resultado:
                    print "[%s,%s,[%s]]" % (pre_node, pre_peso, resultado)
                else:
                    print "[%s,%s]" % (pre_node, pre_peso)
                resultado = None
            if (valor.find("#") == 0 ) : #Si tiene '#' significa que es el peso del nodo
                peso = valor.replace('#', '')
            else :
                edge = '[' +valor + ',1]'
                if resultado == None: #Si es el primer edges se agrega sin separador ','
                    resultado = edge
                else:
                    resultado = resultado + ',' + edge
            pre_node = node
            pre_peso = peso
    if pre_node:
        pre_peso = pre_peso if pre_peso else peso_default
        if resultado:
            print "[%s,%s,[%s]]" % (pre_node, pre_peso, resultado)
        else:
            print "[%s,%s]" % (pre_node, pre_peso)

reducer()
