#!/bin/bash
# Check for each *.samples.* in the folder, whether any of the asn.cm files not exist

for S in `ls *.samples.*`
do
	echo $S
	while read SM ASN LEN
	do
		if [[ -e ${SM}.asn.cm ]]; then
			continue
		fi
		echo "${SM}.asn.cm missing"
	done < $S
	echo ""
done
