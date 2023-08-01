#!/bin/bash

PATH=$PATH:/bio/home/sskimb/bin
echo $PATH
whoami
env

cd /bio/home/sskimb/Microbiome/ggDB/CMalign

cmalign -g --noss --noprob --dnaout --mapali gg_97_otus_GTR.tips.stk -o gg_97_otus_GTR.RDP18.stk --sfile gg_97_otus_GTR.RDP18.score gg_97_otus_GTR_tips.cm RDP18.fa
