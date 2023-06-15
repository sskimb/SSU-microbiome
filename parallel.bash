#!/bin/bash

cd $1
LIST=$2
SCRIPT=$3

echo "${LIST} ${SCRIPT}"

JOBmax=20
for L in `cat ${LIST}`
do
	bash ${SCRIPT} $L &
	J=`jobs | grep Running | wc -l`
	while [ $J -eq $JOBmax ]
	do
		sleep 60
		jobs > jobs.list
		J=`grep Running jobs.list | wc -l`
	done
done

# All jobs submitted, check whether still running
J=`jobs | grep Running | wc -l`
while [ $J -gt 0 ]
do
	sleep 60
	jobs > jobs.list
	J=`grep Running jobs.list | wc -l`
done
