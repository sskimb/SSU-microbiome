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
chimera.vsearch(fasta=TMP.filter.fasta, count=TMP.count_table, dereplicate=T)
summary.seqs(fasta=current, count=current, processors=1)
dist.seqs(fasta=TMP.filter.denovo.vsearch.fasta, cutoff=0.03)
cluster(column=TMP.filter.denovo.vsearch.dist, count=TMP.denovo.vsearch.count_table)
make.shared(list=TMP.filter.denovo.vsearch.opti_mcc.list, count=TMP.denovo.vsearch.count_table)
get.otulist(list=TMP.filter.denovo.vsearch.opti_mcc.list)
quit()
EOJ

# These files are no longer needed
rm TMP.fasta TMP.count_table TMP.filter.fasta TMP.filter.denovo.vsearch.dist

sed -s "s/^K//" TMP.denovo.vsearch.count_table > ${RT}.denovo.vsearch.count_table
sed -s "s/^>K/>/" TMP.filter.denovo.vsearch.fasta > ${RT}.filter.denovo.vsearch.fasta
sed -s "s/K//g" TMP.filter.denovo.vsearch.opti_mcc.list > ${RT}.filter.denovo.vsearch.opti_mcc.list
sed -s "s/K//g" TMP.filter.denovo.vsearch.opti_mcc.0.03.otu > ${RT}.filter.denovo.vsearch.opti_mcc.0.03.otu
wc -l ${RT}.filter.denovo.vsearch.opti_mcc.*

# The edited version of these files were already saved
rm TMP.denovo.vsearch.count_table TMP.filter.denovo.vsearch.fasta TMP.filter.denovo.vsearch.opti_mcc.list TMP.filter.denovo.vsearch.opti_mcc.0.03.otu

for T in TMP*.denovo.vsearch.*
do
	R=`echo ${T} | sed -e "s/TMP.//"`
	sed -e "s/K//g" ${T} > ${RT}.${R}
	echo "Returning to host: ${RT}.${R}"
done
# Do not return sample-wise fasta and count_table files
rm TMP.*
