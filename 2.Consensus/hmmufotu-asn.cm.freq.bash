#!/bin/bash

echo "Examination of CM files in this folder"
echo "[ACGT] frequency of the 1st base of each CM file is tabulated"
echo "If it is close to 0, the reads do not start from V3, perhaps V4 region only construct"
echo "Output is stored in 1stBaseFreq.txt"
echo ""

for C in *.cm; do P=`awk -f ~/Scripts/hmmufotu-asn.cm.freq.awk $C`; echo "$C $P"; done | sort -k 2 -g > 1stBaseFreq.txt

ZERO=`awk 'BEGIN {cnt=0} $2 < 0.5 {cnt++} END {print cnt}' 1stBaseFreq.txt`
if [ $ZERO -gt 0 ]; then
	echo "$ZERO V4 constructs out of `ls *.cm | wc -l`"
else
	echo "None V4 constructs"
fi
