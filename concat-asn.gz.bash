#!/bin/bash

N=0
for F in `ls 0*.asn.gz`
do
	let N=$N+1
	echo "$N $F"
	gunzip -t $F
	if [ $? -eq 1 ]
	then
		echo "$F skipped"
		continue
	fi
	if [ $N -eq 1 ]
	then
		ASN=`echo $F | sed -e "s/[0-9]\+\.//" -e "s/\.gz//"`
		zcat $F > $ASN
	else
		zcat $F | tail -n +4 >> $ASN
	fi
done

ls -lh $ASN
gzip $ASN
ls -lh $ASN.gz
