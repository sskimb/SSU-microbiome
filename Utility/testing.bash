#!/bin/bash

export LD_LIBRARY_PATH="/lib:/usr/lib:/usr/local/lib"

df -h
pwd
ls -l

cd $1
PROJECT="$2"
SPLIT="$3"

while read SM R1 R2
do
	P1=`echo ${R1} | sed -e "s/fastq/fastp.fastq/"`
	P2=`echo ${R2} | sed -e "s/fastq/fastp.fastq/"`
	ls -l ../${R1} ../${R2} ${P1} ${P2}
done < ${PROJECT}.files.${SPLIT}
echo "Done ${PROJECT} ${SPLIT}"
