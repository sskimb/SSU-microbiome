#!/bin/bash

SM="$1" && echo ${SM}
FILE=`grep ${SM} *.files.*` && echo ${FILE}
R1=`echo ${FILE} | cut -d ' ' -f 2` && echo ${R1}	# echo removes tabs
R2=`echo ${FILE} | cut -d ' ' -f 3` && echo ${R2}

NL=10000
[[ "X$2" == "X" ]] || NL="$2"
echo "Split to chunks of approximately $NL sequences"
NS=$((NL*4))

mkdir -p ${SM}/SPLIT/condor; cd ${SM}
pwd

fastp --in1 ../../${R1} --in2 ../../${R2} --out1 ${SM}_R1.fq.gz --out2 ${SM}_R2.fq.gz -S ${NS} -QLA

mothur "#make.file(inputdir=., type=gz, prefix=FILES)"
NF=`wc -l FILES.files`
echo "Split to ${NF} files"
cd SPLIT
ln -s ../FILES.files FILES.files.0

condor_submit <<EOJ
Universe = vanilla
Executable = /bio/home/sskimb/Scripts/fastpHmmufotu.new.bash

Log = condor/${SM}.log
Output = condor/${SM}.out
Error = condor/${SM}.err
Accounting_Group = group_genome.bio

should_transfer_files = YES
when_to_transfer_output = ON_EXIT
arguments = "\$ENV(PWD) FILES 0"
transfer_input_files = /bio/home/sskimb/Microbiome/ggDB/toWN

Request_cpus = 20
Request_memory = 40GB
Request_disk = 1GB

Notification = Always
Notify_user = sskimb@ssu.ac.kr

+SingularityImage = "/bio/home/sskimb/hmmufotu.sif"
+SingularityBind = "/bio"

Queue
EOJ
