#!/bin/bash

WORKDIR="$1"
FT=`find . -name \*.fasta`
CT=`find . -name \*.count_table`
RT=${FT%.*}

# Avoid numeric sequence name by prefixing 'K'
sed -e "s/^>/>K/" ${FT} > TMP.fasta
sed -e "s/^/K/" ${CT} > TMP.count_table

mothur <<EOJ
filter.seqs(fasta=TMP.fasta, vertical=T)
dist.seqs(fasta=TMP.filter.fasta, cutoff=0.03)
cluster(column=TMP.filter.dist, count=TMP.count_table)
make.shared(list=TMP.filter.opti_mcc.list, count=TMP.count_table)
get.otulist(list=TMP.filter.opti_mcc.list)
quit()
EOJ

sed -s "s/K//g" TMP.filter.opti_mcc.list > ${RT}.filter.opti_mcc.list
sed -s "s/K//g" TMP.filter.opti_mcc.0.03.otu > ${RT}.filter.opti_mcc.0.03.otu
wc -l ${RT}.filter.opti_mcc.*

rm TMP.filter.opti_mcc.list TMP.filter.opti_mcc.0.03.otu TMP.fasta TMP.count_table TMP.filter.fasta TMP.filter.dist

for T in TMP.*
do
	R=`echo ${T} | sed -e "s/TMP.//"`
	mv ${T} ${RT}.${R}
	echo "Returning to host: ${RT}.${R}"
done
