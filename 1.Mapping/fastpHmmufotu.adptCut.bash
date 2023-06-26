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
# This new version transfers fastq files to the server and saves the outputs in the server so that the condor can transfer them back to the host upon job termination.

WORKDIR="$1"
PROJECT="$2"
SPLIT="$3"
DB=`find . -name \*.ptu | sed -e "s/.ptu//"`

export LD_LIBRARY_PATH="/lib:/usr/lib:/usr/local/lib"

[[ -e ${WORKDIR}/${PROJECT}.samples.${SPLIT} ]] && rm ${WORKDIR}/${PROJECT}.samples.${SPLIT}
while read SM R1 R2
do
	if [[ -e ${WORKDIR}/${SM}.asn.gz ]]; then
		zcat ${WORKDIR}/${SM}.asn.gz > TEMP.ASN
		RT=${?}
		SZ=`cat TEMP.ASN | wc -l` && rm TEMP.ASN
		if [[ $RT -eq 1 || ${SZ} -eq 0 ]]; then
			rm ${WORKDIR}/${SM}.fastp.json ${WORKDIR}/${SM}.fastp.html ${WORKDIR}/${SM}.asn.gz
			echo "${SM}.asn.gz corrupt or empty, remove it and continue" 1>&2
		else
			echo "${SM}	${SM}.asn.gz	${SZ}" >> ${WORKDIR}/${PROJECT}.samples.${SPLIT}
			echo "${SM}.asn.gz exists with >0 records, skip this sample" 1>&2
			continue
		fi
	fi
# Prior fastp splitting may produce zero sized fastq files
	if [[ ! -s ${WORKDIR}/../${R1} ]]; then
		echo "Skip zero sized ${WORKDIR}/../${R1}"
		continue
	fi
	if [[ ! -s ${WORKDIR}/../${R2} ]]; then
		echo "Skip zero sized ${WORKDIR}/../${R2}"
		continue
	fi
	cp ${WORKDIR}/../${R1} .
	cp ${WORKDIR}/../${R2} .
	P1="${SM}.R1.fastp.fq"
	P2="${SM}.R2.fastp.fq"
	/bio/home/sskimb/bin/fastp -i ${R1} -I ${R2} -o ${P1} -O ${P2} \
		--cut_tail \
		--length_required 150 \
		--json ${SM}.fastp.json --html ${SM}.fastp.html
	mv ${SM}.fastp.json ${SM}.fastp.html ${WORKDIR}
	rm ${R1} ${R2}
	echo "${SM} done FastP" 1>&2

	hmmufotu ${DB} ${P1} ${P2} -o ${SM}.asn.gz --fmt fastq --single --strand 1 --process 8
	if [[ ${?} -eq 0 ]]; then
		L=`zcat ${SM}.asn.gz | wc -l`
		mv ${SM}.asn.gz ${WORKDIR}
		echo "${SM}	${SM}.asn.gz	$L" >> ${WORKDIR}/${PROJECT}.samples.${SPLIT}
		echo "${SM} done HmmUfOtu" 1>&2
		echo "" 1>&2
	else
		echo "HmmUfOtu failed for ${SM} ${P1} ${P2}" 1>&2
		echo "" 1>&2
	fi
	rm ${P1} ${P2}
done < ${WORKDIR}/${PROJECT}.files.${SPLIT}

