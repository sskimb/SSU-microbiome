#!/bin/bash

cd $1
PROJECT="$2"

export LD_LIBRARY_PATH="/lib:/usr/lib:/usr/local/lib"

env 1>&2

hmmufotu-merge ${PROJECT}.sum.out.* -o ${PROJECT}.mgd.out -t ${PROJECT}.mgd.tre --db /bio/home/sskimb/Microbiome/ggDB/gg_97_otus_GTR -v -v -v
