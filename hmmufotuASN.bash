#!/bin/bash

#!/bin/bash

for A in `ls *.asn*`; do
	if [[ $A =~ .gz$ ]]
	then
		P="zcat"
	else
		P="cat"
	fi
        L=`$P $A | wc -l`
        let L="$L-3"
	B=`echo $A | sed -e "s/.asn.*//"`
	echo "$B	$L"
	echo "$B	$L" 1>&2
done
