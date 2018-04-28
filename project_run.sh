#!/usr/bin/env bash
if [ -z "$1" ]; then
echo "Ingrese nro de workers"
exit
fi
workers=$1
#Recorremos los archivos del directorio grafos/ del hdfs
for i in $(hadoop --loglevel FATAL fs -ls -C grafos/)
do
    echo $i - workers: $workers
    if [ "$i" == "grafos/web-wikipedia_link_it.txt" ]
    then
        iter=49
        nodes=2790239
    else
        iter=51
        nodes=4847571
    fi
    ./config.sh $nodes
#    ./hadoop-run.sh $workers $i
#    ./giraph-run.sh $workers $i
done
