#!/bin/bash

#export LD_LIBRARY_PATH="/lib:/usr/lib:/usr/local/lib"

cd $1 

hmmufotu-build gg_97_otus_GTR.RDP18.adjusted.fasta gg_97_otus_GTR.RDP18.adjusted.fast.zeroRM.simple.tree -n ggRDP18 --fmt fasta --anno ggRDP18.anno --sub-model GTR --process 20 -v -v -v --root k__Bacteria

hmmufotu-inspect ggRDP18_GTR -v -v -v
