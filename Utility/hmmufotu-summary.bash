#!/bin/bash

cd $1
env 1>&2

PROJECT="$2"
NSPLIT="$3"

export LD_LIBRARY_PATH="/lib:/usr/lib:/usr/local/lib"

SPLIT=0
while [ $SPLIT -lt $NSPLIT ]; do
hmmufotu-sum /srv/ggDB/gg_97_otus_GTR `cut -f 2 ${PROJECT}.samples.${SPLIT} | tr '\n' ' '` \
                       -l ${PROJECT}.samples.${SPLIT} \
                       -o ${PROJECT}.sum.out.${SPLIT} \
                       -r ${PROJECT}.sum.otu.${SPLIT} \
                       -c ${PROJECT}.sum.fasta.${SPLIT} \
                       -t ${PROJECT}.sum.tre.${SPLIT} \
			-v -v -v

echo "Summarizing $SPLIT" 1>&2

let SPLIT=$SPLIT+1
done

hmmufotu-merge ${PROJECT}.sum.out.* -o ${PROJECT}.mgd.out -t ${PROJECT}.mgd.tre --db /srv/ggDB/gg_97_otus_GTR -v -v -v
