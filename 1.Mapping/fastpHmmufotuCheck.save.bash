#!/bin/bash

for A in `ls *.asn`; do
	L=`cat $A | wc -l`
	let L="$L-3"
	J=`echo $A | sed -e "s/asn/fastp.json/"`
	S=`grep -A 1 filtering_result $J | tail -n 1 | cut -d ' ' -f 2 | sed -e "s/,//"`
	let S="$S/2"
	if [ $L -eq $S ]
	then
		EQ="=="
	else
		EQ="<>"
	fi
	echo "JSON: $S $EQ ASN: $L	$A"
done
