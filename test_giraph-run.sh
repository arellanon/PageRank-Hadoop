#!/usr/bin/env bash
workers=$1
input=$2
input_file=$(basename "$input")
hostname=cluster-arellanon-$workers-m
output=/user/nahuel/out-giraph-w-$workers-$input_file
log=~/log-giraph-w-$workers-$input_file

hadoop fs -rm -r $output

echo ............................................... >> $log
echo giraph - $input_file - worker  $workers         >> $log
echo ............................................... >> $log

hadoop fs -rm -r tmp input_tmp
hadoop fs -mkdir input_tmp
#hadoop fs -rm -r tmp_values
hadoop fs -cp $input input_tmp/

timeIncio=$(date +%s)

echo inicio: $(date) >> $log
#hadoop jar /home/hadoop/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.8.2.jar -D mapred.reduce.tasks=1 \
hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar -D mapred.reduce.tasks=1 \
    	-file src \
	    -mapper "src/sortMapper.py" \
	    -reducer "src/sortReducer.py" \
	    -input input_tmp \
	    -output tmp

hadoop jar /usr/local/giraph/giraph-examples/target/giraph-examples-with-dependencies.jar org.apache.giraph.GiraphRunner \
        -Dmapred.job.tracker=$hostname \
        -libjars /usr/local/giraph/giraph-examples/target/giraph-examples-with-dependencies.jar org.apache.giraph.examples.SimplePageRankComputation \
        -vif org.apache.giraph.io.formats.JsonLongDoubleFloatDoubleVertexInputFormat \
        -vip tmp/part-00000 \
        -vof org.apache.giraph.io.formats.IdWithValueTextOutputFormat \
        -op $output \
        -mc "org.apache.giraph.examples.SimplePageRankComputation\$SimplePageRankMasterCompute" \
        -ca giraph.SplitMasterWorker=false -w $workers


timeFin=$(date +%s)
duracion=$((($timeFin-$timeIncio)))
min=$(($duracion/60))
seg=$(($duracion-(min*60)))

echo fin:    $(date)  >> $log
echo duracion: $min:$seg   >> $log
hadoop fs -rm -r input_tmp tmp tmp2
