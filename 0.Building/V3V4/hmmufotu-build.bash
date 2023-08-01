#!/bin/bash

#export LD_LIBRARY_PATH="/lib:/usr/lib:/usr/local/lib"

cd $1 

hmmufotu-build gg_97_otus_GTR.RDP18.adjusted.V3V4.fasta gg_97_otus_GTR.RDP18.adjusted.V3V4.fast.zeroRM.simple.tree -n ggRDP18V3V4. --fmt fasta --anno ggRDP18.anno --sub-model GTR --process 20 -v -v -v --root k__Bacteria

hmmufotu-inspect ggRDP18V3V4._GTR --tree ggRDP18V3V4._GTR.tree --anno ggRDP18V3V4._GTR.anno --seq ggRDP18V3V4._GTR.seq -n TRUE -v -v -v
