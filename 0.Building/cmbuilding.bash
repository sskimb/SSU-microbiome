#!/bin/bash

PATH=$PATH:/bio/home/sskimb/bin
echo $PATH
whoami
env

cd /bio/home/sskimb/Microbiome/ggDB/CMalign

cmbuild --noss --ere 0.85 --iflank --informat Stockholm gg_97_otus_GTR_tips.cm gg_97_otus_GTR.tips.stk \
	&& \
cmcalibrate gg_97_otus_GTR_tips.cm
