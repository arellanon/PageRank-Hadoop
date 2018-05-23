#!/usr/bin/env python
# encoding: utf-8
import sys
import argparse
import operator

def main(rank):
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
        resultado = sorted(lista.items(), key=operator.itemgetter(1), reverse=True)
        resul = resultado[:rank]
        i=1
        for keys,values in resul :
            print i,'#', keys, values
            i+=1

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Ordena ranking.')
    parser.add_argument('--rank', type=int, default='10', help='N° ranking a mostrar')
    args = parser.parse_args()
    main(args.rank)
