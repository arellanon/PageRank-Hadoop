#!/usr/bin/env bash
workers=$1
input=$2
times=$3
input_file=$(basename "$input")

output=/user/nahuel/out-hadoop-w-$workers-$input_file
log=~/log-hadoop-w-$workers-$input_file

#Se genera archivo temporal de values
#rm tmp_values
#touch tmp_values
hadoop fs -rm -r $output
hadoop fs -rm -r input_tmp
hadoop fs -mkdir input_tmp

hadoop fs -cp $input input_tmp/

echo ............................................... >> $log
echo hadoop - $input_file - worker  $workers         >> $log
echo ............................................... >> $log
totTimeIncio=$(date +%s)
for i in `seq 1 $times`
do
	echo iteracion: $i
	echo ............................................... >> $log
	echo interacion: $i - $input_file >> $log 
	echo ............................................... >> $log
	hadoop fs -rm -r tmp tmp2
	timeIncio=$(date +%s)
	echo $i - inicio: $(date) >> $log

	hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar -D mapred.reduce.tasks=1 \
        -file src \
		-mapper "src/sortMapper.py" \
		-reducer "src/sortReducer.py" \
		-input input_tmp \
		-output tmp

	hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar -D mapred.reduce.tasks=1 \
    	-file src \
    	-mapper "src/prMapper.py" \
    	-reducer "src/prReducer.py" \
		-input tmp/part-00000 \
		-output tmp2

    #el output es la nueva entrada para la proxima iteracion
	hadoop fs -rm -r input_tmp/tmp_values
	hadoop fs -mv tmp2/part-00000 input_tmp/tmp_values

	timeFin=$(date +%s)
	duracion=$((($timeFin-$timeIncio)))
	min=$(($duracion/60))
	seg=$(($duracion-(min*60)))
	echo $i - fin:    $(date)  >> $log
	echo duracion: $min:$seg   >> $log
done
totTimeFin=$(date +%s)
totDuracion=$((($totTimeFin-$totTimeIncio)))
totMin=$(($totDuracion/60))
totSeg=$(($totDuracion-(totMin*60)))
echo Con $workers worker - duracion total: $totMin:$totSeg   >> $log
hadoop fs -mv input_tmp/tmp_values $output
hadoop fs -rm -r input_tmp tmp tmp2
