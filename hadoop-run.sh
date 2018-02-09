#!/usr/bin/env bash
input=$1
nro_work=$2
times=$3
input_file=$(basename "$input")

#Se genera archivo temporal de values
rm tmp_values
touch tmp_values
hadoop fs -rm tmp_values resultado-m$nro_work-$input_file
hadoop fs -put tmp_values
echo ............................................... >> log_$input_file
echo $input_file - worker: $nro_work >> log_$input_file
echo ............................................... >> log_$input_file
totTimeIncio=$(date +%s)
for i in `seq 1 $times`
do
	echo iteracion: $i
	echo ............................................... >> log_$input_file
	echo interacion: $i - $input_file >> log_$input_file 
	echo ............................................... >> log_$input_file
	hadoop fs -rm -r tmp tmp2
	timeIncio=$(date +%s)
	echo $i - inicio: $(date) >> log_$input_file

#	hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-2.8.2.jar \
#	hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar -D mapred.map.tasks=$nro_map -D mapred.reduce.tasks=1 \
	hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar -D mapred.reduce.tasks=1 \
        	-file src \
		-mapper "src/sortMapper.py" \
		-reducer "src/sortReducer.py" \
		-input tmp_values \
		-input $input \
		-output tmp

#	hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-2.8.2.jar \
#    	hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar -D mapred.map.tasks=$nro_map -D mapred.reduce.tasks=1 \
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
	echo $i - fin:    $(date)  >> log_$input_file
	echo duracion: $min:$seg   >> log_$input_file
done
totTimeFin=$(date +%s)
totDuracion=$((($totTimeFin-$totTimeIncio)))
totMin=$(($totDuracion/60))
totSeg=$(($totDuracion-(totMin*60)))
echo Con $nro_work worker - duracion total: $totMin:$totSeg   >> log_$input_file
hadoop fs -mv tmp_values resultado-m$nro_work-$input_file
