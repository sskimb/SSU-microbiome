#!/bin/bash
# Runs FastP and figaro
# Outputs: ${SM}.fastp.json
#          ${SM}.fastp.html
# Input arguments:
#          1: current working directory
#          2: project symbol
# figaro assumes file names of the form: *_R[12]_[0-9][0-9][0-9].[fq|fastq]*
# figaro requires read lengths all the same (so we truncate to 290, discard less than this)

WORKDIR="$1"
PROJECT="$2"

export LD_LIBRARY_PATH="/lib:/usr/lib:/usr/local/lib"

mkdir figaro
while read SM R1 R2
do
	cp ${WORKDIR}/../${R1} .
	cp ${WORKDIR}/../${R2} .
	P1="figaro/${SM}_R1_999.fq.gz"
	P2="figaro/${SM}_R2_999.fq.gz"
	/bio/home/sskimb/bin/fastp -i ${R1} -I ${R2} -o ${P1} -O ${P2} \
		-A -Q \
		-b 290 -B 290 \
		--length_required 290 \
		--json ${SM}.fastp.json --html ${SM}.fastp.html
	rm ${R1} ${R2}
	echo "${SM} done FastP" 1>&2
done < ${WORKDIR}/${PROJECT}.files

python3 /opt/figaro/figaro/figaro.py -i figaro -o figaro -a 445 -f 20 -r 20

[[ -e ${WORKDIR}/figaro ]] && rm -rf ${WORKDIR}/figaro
mv figaro ${WORKDIR}/
