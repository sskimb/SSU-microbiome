#!/bin/bash

SHD="$1".shared
DGN="$1".design

echo "${SHD} ${DGN}"
ls -ltr

/bio/home/sskimb/TGZ/mothur/mothur <<EOJ
metastats(shared=${SHD}, design=${DGN})
quit()
EOJ

ls -ltr
