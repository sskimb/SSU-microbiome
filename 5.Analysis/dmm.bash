#!/bin/bash

SHD="$1".shared

echo "${SHD}"
ls -ltr

/bio/home/sskimb/TGZ/mothur/mothur <<EOJ
get.communitytype(shared=${SHD})
quit()
EOJ

ls -ltr
