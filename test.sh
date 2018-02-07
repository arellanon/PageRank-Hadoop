#!/usr/bin/env bash
times=20
cat values > tmp/values
rm log.txt
for i in `seq 1 $times`
do
    timeIncio=$(date +%s)
	echo $i - inicio: $(date) >> log.txt
	#cat tmp/values
	cat nodes tmp/values | ./src/sortMapper.py | sort | ./src/sortReducer.py | ./src/prMapper.py | sort | ./src/prReducer.py > tmp/values_tmp
    rm tmp/values
    mv tmp/values_tmp tmp/values
	echo '---------'
    timeFin=$(date +%s)
    duracion=$((($timeFin-$timeIncio)/(60*60*24)))
	echo $i - fin:    $(date) - duracion: $duracion >> log.txt
done
