#!/usr/bin/env python
# encoding: utf-8
import sys
import operator

def reducer():
    max_node = node = valor = max_valor = None
    lista={}
    for line in sys.stdin:
        data = line.strip().split()
        node = int(data[0])
        valor = data[1]
        if (valor.find("#") == 0 ) : #Si tiene '#' significa que es el peso del nodo
            valor = valor.replace('#', '')
#            valor = float(valor)
        lista[node]=float(valor)

    if lista != None :
        resultado = sorted(lista.items(), key=operator.itemgetter(1))
        resul = resultado[-10:] 
        for keys,values in resul :
            print keys, values

reducer()
