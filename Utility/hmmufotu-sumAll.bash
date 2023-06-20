#!/bin/bash

cd $1
PROJECT="$2"
DB=`find /srv -name \*.ptu | sed -e "s/.ptu//"`

export LD_LIBRARY_PATH="/lib:/usr/lib:/usr/local/lib"

hmmufotu-sum ${DB} \
`cut -f 2 ${PROJECT}.ALL.samples | tr '\n' ' '` \
                       -l ${PROJECT}.ALL.samples \
                       -o ${PROJECT}.ALL.sum.out \
                       -r ${PROJECT}.ALL.sum.otu \
                       -c ${PROJECT}.ALL.sum.fasta \
                       -t ${PROJECT}.ALL.sum.tre \
			-v -v -v

