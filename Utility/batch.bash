#!/bin/bash

while read SM R1 R2
do
	ON=`readlink ${R1}`
	DN=`dirname ${ON}`
	echo "${SM}	${DN}"
done < $1
