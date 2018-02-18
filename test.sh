#!/usr/bin/env bash
times=$1
#cat values > tmp/values
rm log.txt
rm tmp/values
CONTINUAR=1
umbral=0.1
i=1
#for i in `seq 1 $times`
while [ $CONTINUAR -eq 1 ]
do  
    timeIncio=$(date +%s)
    echo $i
	echo $i - inicio: $(date) >> log.txt
	#cat tmp/values
	cat tmp/* | ./src/sortMapper.py | sort | ./src/sortReducer.py | ./src/prMapper.py | sort | ./src/prReducer.py >> tmp/values_tmp
    if [ $i -gt 1 ]; then
        cat tmp/values tmp/values_tmp | ./src/sortMapper.py | sort | ./src/MaxDiff.py >> delta.txt
        delta=`cat delta.txt`
        CONTINUAR=$( echo "$delta>$umbral" | bc )
    fi
    rm delta.txt
    rm tmp/values
    mv tmp/values_tmp tmp/values
	echo '---------'
    i=$((i+1))
    timeFin=$(date +%s)
    duracion=$((($timeFin-$timeIncio)/(60*60*24)))
	echo $i - fin:    $(date) - duracion: $duracion >> log.txt
done
