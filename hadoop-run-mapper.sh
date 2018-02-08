#!/usr/bin/env bash
input=$1
times=$2
for i in `seq 1 $times`
do
	echo mapper: $i
	./hadoop-run.sh $input $i 20
done
