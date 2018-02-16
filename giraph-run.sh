#!/usr/bin/env bash
input=$1
nro_worker=$2
input_file=$(basename "$input")
hostname=cluster-arellanon-$nro_worker-m

hadoop fs -rm -r /user/nahuel/resultado-w$nro_worker

echo ............................................... >> log_$input_file
echo $input_file - worker: $nro_worker >> log_$input_file
echo ............................................... >> log_$input_file

#totTimeIncio=$(date +%s)
hadoop fs -rm -r tmp
timeIncio=$(date +%s)

echo inicio: $(date) >> log_$input_file

#hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-2.8.2.jar \
#hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar -D mapred.map.tasks=$nro_worker -D mapred.reduce.tasks=1 \
hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar -D mapred.reduce.tasks=1 \
    	-file src \
	-mapper "src/sortMapper.py" \
	-reducer "src/sortReducer.py" \
	-input tmp_values \
	-input $input \
	-output tmp

hadoop jar /usr/local/giraph/giraph-examples/target/giraph-examples-1.3.0-SNAPSHOT-for-hadoop-2.8.2-jar-with-dependencies.jar org.apache.giraph.GiraphRunner \
        -Dmapred.job.tracker=$hostname \
        -libjars /usr/local/giraph/giraph-examples/target/giraph-examples-1.3.0-SNAPSHOT-for-hadoop-2.8.2-jar-with-dependencies.jar org.apache.giraph.examples.SimplePageRankComputation \
        -vif org.apache.giraph.io.formats.JsonLongDoubleFloatDoubleVertexInputFormat \
        -vip tmp/part-00000 \
        -vof org.apache.giraph.io.formats.IdWithValueTextOutputFormat \
        -op /user/nahuel/resultado-w$nro_worker \
        -mc "org.apache.giraph.examples.SimplePageRankComputation\$SimplePageRankMasterCompute" \
        -ca giraph.SplitMasterWorker=true -w $nro_worker


timeFin=$(date +%s)
duracion=$((($timeFin-$timeIncio)))
min=$(($duracion/60))
seg=$(($duracion-(min*60)))

echo fin:    $(date)  >> log_$input_file
echo duracion: $min:$seg   >> log_$input_file

#totTimeFin=$(date +%s)
#totDuracion=$((($totTimeFin-$totTimeIncio)))
#totMin=$(($totDuracion/60))
#totSeg=$(($totDuracion-(totMin*60)))
#echo Con $nro_worker mapper - duracion total: $totMin:$totSeg   >> log_$input_file
#hadoop fs -mv tmp_values resultado-m$nro_worker-$input_file
