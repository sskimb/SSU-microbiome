#!/bin/bash

cd $1
env 1>&2

PROJECT="$2"
NSPLIT="$3"

export LD_LIBRARY_PATH="/lib:/usr/lib:/usr/local/lib"

SPLIT=0
while [ $SPLIT -lt $NSPLIT ]; do
hmmufotu /srv/ggDB/gg_97_otus_GTR ${PROJECT}.sum.fasta.${SPLIT} \
                       -o ${PROJECT}.sum.nonchimera.asn.${SPLIT} \
                       -a ${PROJECT}.sum.nonchimera.fasta.${SPLIT} \
			--fmt fasta --single F --strand 1 --chimera T \
			--chimera-out ${PROJECT}.sum.chimera.asn.${SPLIT} \
			--chimera-info T \
			--process 1 \
			-v -v -v

echo "Chimera checked $SPLIT" 1>&2

let SPLIT=$SPLIT+1
done

