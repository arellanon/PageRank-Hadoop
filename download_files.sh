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
#wikipedia
:'
wget http://nrvis.com/download/data/web/web-wikipedia_link_it.zip 
unzip web-wikipedia_link_it.zip
rm readme.html
rm web-wikipedia_link_it.zip
#quitamos encabezado
cat web-wikipedia_link_it.edges | tail -n +2 >> web-wikipedia_link_it.txt
rm web-wikipedia_link_it.edges

#web-BerkStan.txt
wget http://snap.stanford.edu/data/web-BerkStan.txt.gz
gzip -d web-BerkStan.txt.gz
mv web-BerkStan.txt web-BerkStan-head.txt
cat web-BerkStan-head.txt | tail -n +5 >> web-BerkStan.txt
rm web-BerkStan-head.txt

#web-Google.txt.gz
wget http://snap.stanford.edu/data/web-Google.txt.gz
gzip -d web-Google.txt.gz
mv web-Google.txt web-Google-head.txt
cat web-Google-head.txt | tail -n +5 >> web-Google.txt
rm web-Google-head.txt
'
wget http://konect.uni-koblenz.de/downloads/tsv/zhishi-baidu-relatedpages.tar.bz2
tar -xjvf zhishi-baidu-relatedpages.tar.bz2
mv zhishi-hudong-relatedpages/out.zhishi-hudong-relatedpages .
rm -r zhishi-hudong-relatedpages/
rm zhishi-hudong-relatedpages.tar.bz2
head out.zhishi-hudong-relatedpages | tail -n +3 >> out.zhishi-hudong-relatedpages.txt
rm out.zhishi-hudong-relatedpages

#Subimos todos los archivos del folder ~/grafos/
hadoop fs -put ~/grafos/* grafos/
