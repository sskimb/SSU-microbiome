#!/bin/bash
# Check for each *.files.* in the folder, whether any of them not exist

for F in `ls *.files.*`
do
	echo $F
	while read SM R1 R2
	do
		if [[ -e ${SM}.asn.gz ]]; then
			if [[ ! -s ${SM}.asn.gz ]]; then
				echo "${SM} zero size"
			fi
			continue
		fi
		echo "${SM}.asn.gz missing"
	done < $F
	echo ""
done
