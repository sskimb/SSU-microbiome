#!/bin/bash

PWD=`pwd`
ls

cd $1

B=$2
C=`echo $B | sed -e "s/\.bam/.cov/"`
echo "$B >> $C"

/bio/home/sskimb/bin/samtools bedcov ${PWD}/exome_region.bed ${B} > ${C}
