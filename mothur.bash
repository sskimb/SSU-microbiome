#!/bin/bash

set -x
whoami
cd /bio/home/sskimb/Microbiome
pwd
ls -ltr
# /bio/home/sskimb/mothur/mothur "#summary.seqs(fasta=BLNH.trim.contigs.fasta)"
#screen.seqs(fasta=BLNH.trim.contigs.fasta, group=BLNH.contigs.groups, contigsreport=BLNH.contigs.report, ostart=176, oend=289, minoverlap=124)
#summary.seqs(fasta=current)
#unique.seqs(fasta=BLNH.trim.contigs.good.fasta)
#count.seqs(name=BLNH.trim.contigs.good.names, group=BLNH.contigs.good.groups)
#summary.seqs(count=BLNH.trim.contigs.good.count_table)
#align.seqs(fasta=BLNH.trim.contigs.good.unique.fasta, reference=silva.v3v4.fasta)
#summary.seqs(fasta=BLNH.trim.contigs.good.unique.align, count=BLNH.trim.contigs.good.count_table)
/bio/home/sskimb/mothur/mothur << EOJ
screen.seqs(fasta=BLNH.trim.contigs.good.unique.align, count=BLNH.trim.contigs.good.count_table, summary=BLNH.trim.contigs.good.unique.summary, start=1, end=18929, maxhomop=8)
summary.seqs(fasta=current, count=current)
filter.seqs(fasta=BLNH.trim.contigs.good.unique.good.align, vertical=T, trump=.)
unique.seqs(fasta=BLNH.trim.contigs.good.unique.good.filter.fasta, count=BLNH.trim.contigs.good.good.count_table)
pre.cluster(fasta=BLNH.trim.contigs.good.unique.good.filter.unique.fasta, count=BLNH.trim.contigs.good.unique.good.filter.count_table, diffs=5)
chimera.vsearch(fasta=BLNH.trim.contigs.good.unique.good.filter.unique.precluster.fasta, count=BLNH.trim.contigs.good.unique.good.filter.unique.precluster.count_table, dereplicate=t)
remove.seqs(fasta=BLNH.trim.contigs.good.unique.good.filter.unique.precluster.fasta, accnos=BLNH.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.accnos)
summary.seqs(fasta=current, count=current)
quit()
EOJ
ls -ltr
