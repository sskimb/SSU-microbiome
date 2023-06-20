#!/bin/bash

set -x
whoami
cd /bio/home/sskimb/Microbiome
pwd
env
#classify.seqs(fasta=BLNH.trim.contigs.good.unique.good.filter.unique.precluster.pick.fasta, count=BLNH.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.count_table, reference=trainset16_022016.pds.fasta, taxonomy=trainset16_022016.pds.tax, cutoff=80)
#remove.lineage(fasta=BLNH.trim.contigs.good.unique.good.filter.unique.precluster.pick.fasta, count=BLNH.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.count_table, taxonomy=BLNH.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.taxonomy, taxon=Chloroplast-Mitochondria-unknown-Archaea-Eukaryota)
#summary.tax(taxonomy=current, count=current)
#
#The following cluster.split failed due to memory problem
#[ERROR]: std::bad_allocRAM used: 358.304Gigabytes . Total Ram: 377.622Gigabytes.
#cluster.split(fasta=BLNH.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.fasta, count=BLNH.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.count_table, taxonomy=BLNH.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.pick.taxonomy, splitmethod=classify, taxlevel=4, cutoff=0.03)
#We now turn to phylotype method
mothur << EOJ
phylotype(taxonomy=BLNH.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.pick.taxonomy)
make.shared(list=BLNH.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.pick.tx.list, count=BLNH.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.count_table, label=1)
classify.otu(list=BLNH.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.pick.tx.list, count=BLNH.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.count_table, taxonomy=BLNH.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.pick.taxonomy, label=1)
quit()
EOJ
