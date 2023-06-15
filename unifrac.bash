#!/bin/bash

cd $1

/bio/home/sskimb/mothur/mothur <<EOJ
phylo.diversity(tree=$2, count=$3, rarefy=T)
unifrac.weighted(tree=$2, count=$3, distance=lt, random=F, subsample=T)
quit()
EOJ
