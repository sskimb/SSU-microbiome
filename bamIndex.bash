#!/bin/bash

PATH=/bio/home/sskimb/bin:$PATH

X="X$1"
[[ $X == "X" ]] && echo "Missing CWD" && exit 1

cd $1

for B in `ls *.bam`
do
	samtools index -@ 8 $B
done
