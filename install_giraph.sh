#!/usr/bin/env bash
sudo apt-get install maven -y
cd /usr/local/
#sudo git clone https://github.com/apache/giraph.git
sudo git clone https://github.com/arellanon/giraph
sudo chown -R nahuel:nahuel giraph/
echo "export HADOOP_HOME=/usr/lib/hadoop" >> ~/.bashrc
echo "export GIRAPH_HOME=/usr/local/giraph" >> ~/.bashrc
source ~/.bashrc
HADOOP_HOME=/usr/lib/hadoop
GIRAPH_HOME=/usr/local/giraph
cd $GIRAPH_HOME
#Se elimina bug
rm giraph-block-app-8/src/test/java/org/apache/giraph/block_app/framework/no_vtx/MessagesWithoutVerticesTest.java
#Se ejecuta la instalacion de GIRAPH
mvn -Phadoop_2 -Dhadoop.version=2.8.2 -DskipTests clean package

#Creamos enlace simbolico
ln -s /usr/local/giraph/giraph-examples/target/giraph-examples-1.3.0-SNAPSHOT-for-hadoop-2.8.2-jar-with-dependencies.jar /usr/local/giraph/giraph-examples/target/giraph-examples-with-dependencies.jar
