#!/bin/bash
# Runs FastP and hmmufotu
# Outputs: ${SM}.fastp.json
#          ${SM}.fastp.html
#          ${SM}.asn.gz
#          ${PROJECT}.samples.${SPLIT}
# Input arguments:
#          1: current working directory
#          2: project symbol
#          3: split number to be appended to ${PROJECT}.samples., from which sample list will be read in
# Reference database should be availble from the server root directory (should be transfered prior to execution of this script)
# The samples whose asn.gz file is missing or of zero size will be processed, so that this script can be resubmitted over existing result files intact.
# If some samples have failed in the previous run, remove the relevant asn.gz and re-submit this script to process only those samples.

pwd
SRV=`pwd`
cd $1
pwd
PROJECT="$2"
SPLIT="$3"
DB=`find ${SRV} -name \*.ptu | sed -e "s/.ptu//"`
echo "DB = ${DB}"
ls -l ${DB}.*

export LD_LIBRARY_PATH="/lib:/usr/lib:/usr/local/lib"

[[ -e ${PROJECT}.samples.${SPLIT} ]] && rm ${PROJECT}.samples.${SPLIT}
while read SM R1 R2
do
	if [[ -e ${SM}.asn ]]; then
		SZ=`cat ${SM}.asn | wc -l`
		if [[ ${SZ} -eq 0 ]]; then
			rm ${SM}.fastp.json ${SM}.fastp.html ${SM}.asn
			echo "${SM}.asn empty, remove it and continue" 1>&2
		else
			echo "${SM}	${SM}.asn	${SZ}" >> ${PROJECT}.samples.${SPLIT}
			echo "${SM}.asn exists with >0 records, skip this sample" 1>&2
			continue
		fi
	fi
	P1="${SM}.R1.fastp.fq"
	P2="${SM}.R2.fastp.fq"
	/bio/home/sskimb/bin/fastp -i ../${R1} -I ../${R2} -o ${P1} -O ${P2} \
		-A \
		--cut_front --cut_right --qualified_quality_phred 20 --unqualified_percent_limit 20 \
		--length_required 150 \
		--json ${SM}.fastp.json --html ${SM}.fastp.html
	echo "${SM} done FastP" 1>&2

	hmmufotu ${DB} ${P1} ${P2} -o ${SM}.asn --fmt fastq --single FALSE --strand 1 --process 20
	if [[ ${?} -eq 0 ]]; then
		L=`cat ${SM}.asn | wc -l`
		echo "${SM}	${SM}.asn	$L" >> ${PROJECT}.samples.${SPLIT}
		echo "${SM} done HmmUfOtu" 1>&2
		echo "" 1>&2
	else
		echo "HmmUFOtu failed for ${SM} ${P1} ${P2}" 1>&2
		echo "" 1>&2
	fi
	rm ${P1} ${P2}
done < ${PROJECT}.files.${SPLIT}

