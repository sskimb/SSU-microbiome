#!/bin/bash

cd $1
PROJECT="$2"

export PATH=$PATH:/bio/home/sskimb/bin

hpc-clust -nthreads 20 -dfunc nogap -sl true -cl true -al true ${PROJECT}.ALL.sum.fasta
hpc-clust -makeotus_mothur ${PROJECT}.ALL.sum.fasta ${PROJECT}.ALL.sum.fasta.sl 0.99 > ${PROJECT}.ALL.sum.fasta.sl.0p99.list 
hpc-clust -makeotus_mothur ${PROJECT}.ALL.sum.fasta ${PROJECT}.ALL.sum.fasta.sl 0.97 > ${PROJECT}.ALL.sum.fasta.sl.0p97.list 
hpc-clust -makeotus_mothur ${PROJECT}.ALL.sum.fasta ${PROJECT}.ALL.sum.fasta.cl 0.99 > ${PROJECT}.ALL.sum.fasta.cl.0p99.list 
hpc-clust -makeotus_mothur ${PROJECT}.ALL.sum.fasta ${PROJECT}.ALL.sum.fasta.cl 0.97 > ${PROJECT}.ALL.sum.fasta.cl.0p97.list 
hpc-clust -makeotus_mothur ${PROJECT}.ALL.sum.fasta ${PROJECT}.ALL.sum.fasta.al 0.99 > ${PROJECT}.ALL.sum.fasta.al.0p99.list 
hpc-clust -makeotus_mothur ${PROJECT}.ALL.sum.fasta ${PROJECT}.ALL.sum.fasta.al 0.97 > ${PROJECT}.ALL.sum.fasta.al.0p97.list 
