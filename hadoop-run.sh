#!/usr/bin/env bash
times=20
input=$1
input_file=$(basename "$input")

#Se genera archivo temporal de values
rm tmp_values log_$input_file
touch tmp_values
hadoop fs -rm tmp_values resultado_$input_file
hadoop fs -put tmp_values

for i in `seq 1 $times`
do
	echo $i - $input_file
	hadoop fs -rm -r tmp tmp2

	timeIncio=$(date +%s)
	echo $i - inicio: $(date) >> log_$input_file

#	hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-2.8.2.jar \
	hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar -D mapred.reduce.tasks=1 \
        	-file src \
		-mapper "src/sortMapper.py" \
		-reducer "src/sortReducer.py" \
		-input tmp_values \
		-input $input \
		-output tmp

#	hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-2.8.2.jar \
    	hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar -D mapred.reduce.tasks=1 \
        	-file src \
        	-mapper "src/prMapper.py" \
        	-reducer "src/prReducer.py" \
		-input tmp/part-00000 \
		-output tmp2

	hadoop fs -rm -r tmp_values
	hadoop fs -mv tmp2/part-00000 tmp_values

	timeFin=$(date +%s)
	duracion=$((($timeFin-$timeIncio)))
	min=$(($duracion/60))
	seg=$(($duracion-(min*60)))
	echo $i - fin:    $(date) - duracion: $min:$seg   >> log_$input_file
done
hadoop fs -mv tmp_values resultado_$input_file
