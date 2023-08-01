#!/bin/bash

#export LD_LIBRARY_PATH="/lib:/usr/lib:/usr/local/lib"

cd $1 

hmmufotu-inspect ggRDP18_GTR --tree ggRDP18_GTR.tree --anno ggRDP18_GTR.anno --seq ggRDP18_GTR.seq -n TRUE -v -v -v
