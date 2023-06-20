#!/bin/bash

SHD="$1".shared

echo "${SHD}"
ls -ltr

/bio/home/sskimb/TGZ/mothur/mothur <<EOJ
rarefaction.single(shared=${SHD}, calc=sobs, freq=100)
summary.single(shared=${SHD}, calc=nseqs-coverage-sobs-shannon-chao-ace-invsimpson, subsample=T)
dist.shared(shared=${SHD}, calc=braycurtis-thetayc-jclass, subsample=T)
quit()
EOJ

ls -ltr
BC=`find . -name \*.braycurtis.\*.ave.dist`
JC=`find . -name \*.jclass.\*.ave.dist`
TY=`find . -name \*.thetayc.\*.ave.dist`
echo "${SHD} ${BC} ${JC} ${TY}"
/bio/home/sskimb/TGZ/mothur/mothur <<EOK
pcoa(phylip=${BC})
pcoa(phylip=${JC})
pcoa(phylip=${TY})
nmds(phylip=${BC}, mindim=3, maxdim=3)
nmds(phylip=${JC}, mindim=3, maxdim=3)
nmds(phylip=${TY}, mindim=3, maxdim=3)
quit()
EOK

ls -ltr
