#!/usr/bin/env bash
workers=$1
#Recorremos los archivos del directorio grafos/ del hdfs
for i in $(hadoop --loglevel FATAL fs -ls -C grafos/)
do
     echo $i - workers: $workers
    ./hadoop-run.sh $workers $i 2
    ./giraph-run.sh $workers $i
done
