#!/bin/bash
# Runs FastP and Kraken2
# Outputs: ${SM}.fastp.json
#          ${SM}.fastp.html
#          ${SM}.kreport2
#          ${SM}.kraken2.out.gz
#          ${PROJECT}.samples.${SPLIT}
# Input arguments:
#          1: current working directory
#          2: project symbol
#          3: split number to be appended to ${PROJECT}.samples., from which sample list will be read in
#          4: Kraken2 reference DB
# Reference database should be availble from the server root directory (should be transfered prior to execution of this script)
# The samples whose kraken2.out.gz file is missing or of zero size will be processed, so that this script can be resubmitted over existing result files intact.
# If some samples have failed in the previous run, remove the relevant kraken2.out.gz and re-submit this script to process only those samples.
# This new version transfers fastq files to the server and saves the outputs in the server so that the condor can transfer them back to the host upon job termination.

WORKDIR="$1"
PROJECT="$2"
SPLIT="$3"
DB="$4"

export LD_LIBRARY_PATH="/lib:/usr/lib:/usr/local/lib"

[[ -e ${WORKDIR}/${PROJECT}.samples.${SPLIT} ]] && rm ${WORKDIR}/${PROJECT}.samples.${SPLIT}
while read SM R1 R2
do
	if [[ -e ${WORKDIR}/${SM}.kraken2.out.gz ]]; then
		SZ=`zcat ${WORKDIR}/${SM}.kraken2.out.gz | wc -l`
		if [[ ${?} -eq 1 || ${SZ} -eq 0 ]]; then
			rm ${WORKDIR}/${SM}.fastp.json ${WORKDIR}/${SM}.fastp.html ${WORKDIR}/${SM}.kraken2.out.gz
			echo "${SM}.kraken2.out.gz corrupt or empty, remove it and continue" 1>&2
		else
			echo "${SM}	${SM}.kraken2.out.gz	${SZ}" >> ${WORKDIR}/${PROJECT}.samples.${SPLIT}
			echo "${SM}.kraken2.out.gz exists with >0 records, skip this sample" 1>&2
			continue
		fi
	fi
	cp ${WORKDIR}/../${R1} .
	cp ${WORKDIR}/../${R2} .
	P1="${SM}.R1.fastp.fq"
	P2="${SM}.R2.fastp.fq"
	/bio/home/sskimb/bin/fastp -i ${R1} -I ${R2} -o ${P1} -O ${P2} \
		-A \
		--cut_tail \
		--length_required 150 \
		--json ${SM}.fastp.json --html ${SM}.fastp.html
	mv ${SM}.fastp.json ${SM}.fastp.html ${WORKDIR}
	rm ${R1} ${R2}
	echo "${SM} done FastP" 1>&2

        kraken2 --db ${DB} \
                --threads 20 \
                --report ${SM}.kreport2 \
                --paired ${P1} ${P2} \
                --output ${SM}.kraken2.out

	if [[ ${?} -eq 0 ]]; then
		L=`wc -l ${SM}.kraken2.out`
		gzip ${SM}.kraken2.out
		mv ${SM}.kraken2.out.gz ${WORKDIR}
		echo "${SM}	${SM}.kraken2.out.gz	$L" >> ${WORKDIR}/${PROJECT}.samples.${SPLIT}
		echo "${SM} done Kraken2" 1>&2
		echo "" 1>&2
	else
		echo "Kraken2 failed for ${SM} ${P1} ${P2}" 1>&2
		echo "" 1>&2
	fi
	rm ${P1} ${P2}
done < ${WORKDIR}/${PROJECT}.files.${SPLIT}
