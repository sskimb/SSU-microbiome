#!/bin/bash

S=$1
mothur <<EOJ
chimera.vsearch(fasta=BLNH.trim.contigs.good.unique.good.filter.unique.precluster.${S}.fasta, count=BLNH.trim.contigs.good.unique.good.filter.unique.precluster.${S}.count_table, processors=1)
remove.seqs(fasta=BLNH.trim.contigs.good.unique.good.filter.unique.precluster.${S}.fasta, count=BLNH.trim.contigs.good.unique.good.filter.unique.precluster.${S}.count_table, accnos=BLNH.trim.contigs.good.unique.good.filter.unique.precluster.${S}.denovo.vsearch.accnos)
quit()
EOJ
rm BLNH.trim.contigs.good.unique.good.filter.unique.precluster.${S}.${S}.fasta
rm BLNH.trim.contigs.good.unique.good.filter.unique.precluster.${S}.${S}.count_table
