#!/bin/bash
# The reference file should be transfered to the worker pior to the execution of this job

SRV=`pwd`
ls -lh
#cp /bio/home/sskimb/HumanGenomeAssemblies/kimdh/grch37/human_g1k_v37.fasta .
#cp /bio/home/sskimb/HumanGenomeAssemblies/kimdh/grch37/human_g1k_v37.fasta.fai .
#cp /bio/home/sskimb/HumanGenomeAssemblies/kimdh/grch37/exome_region.bed .
#ls -lh

X="X$1"
[[ $X == "X" ]] && echo "Missing Working Directory" && exit 1

cd $1

B=$2
C=`echo $B | sed -e "s/\.bam/.bcf/"`
echo "$B >> $C"
/bio/home/sskimb/bin/bcftools mpileup --max-depth 1500 -R ${SRV}/exome_region.bed -Ou -f ${SRV}/human_g1k_v37.fasta $B | /bio/home/sskimb/bin/bcftools call -mv --ploidy GRCh37 -Ob -o $C
