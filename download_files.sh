#!/usr/bin/env bash
#Generamos folder grafos/ en hdfs
hadoop fs -rm -r grafos/
hadoop fs -mkdir grafos/
cd ~
#Generamos folder grafos en HOME del usuario
rm -r grafos
mkdir grafos
cd ~/grafos

#Descargamos archivos
:'
#wikipedia
wget http://nrvis.com/download/data/web/web-wikipedia_link_it.zip 
unzip web-wikipedia_link_it.zip
rm readme.html
rm web-wikipedia_link_it.zip
#quitamos encabezado
cat web-wikipedia_link_it.edges | tail -n +2 >> web-wikipedia_link_it.txt
rm web-wikipedia_link_it.edges
hadoop fs -put web-wikipedia_link_it.txt grafos/
'
#web-BerkStan.txt
wget http://snap.stanford.edu/data/web-BerkStan.txt.gz
gzip -d web-BerkStan.txt.gz
mv web-BerkStan.txt web-BerkStan-head.txt
cat web-BerkStan-head.txt | tail -n +5 >> web-BerkStan.txt
rm web-BerkStan-head.txt

#Subimos todos los archivos del folder ~/grafos/
hadoop fs -put ~/grafos/* grafos/

