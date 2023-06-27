# Mapping read pairs in fastq files to create .asn files

The main script can be run as follows:

    ${SCRIPTS}/fastpHmmUFOtu.adptCut.bash ${WORKDIR} ${PROJECT} ${SPLIT}

where the symbols are defined as follows:
- ${SCRIPTS} represents the folder hosting this bash script,
- ${WORKDIR} is the working folder to host output files,
- ${PROJECT} is the root of the sample list file,
- ${SPLIT} is used to construct the actual sample list file name (see below for split jobs).

## Fastq files
This script assumes that the original fastq files are stored in "**../${WORKDIR}**". 
The fastp output fastq files are created in ${WORKDIR} and input to hmmufotu, but deleted afterwards.

## Sample list files
This script reads a mothur-style file of the sample list, named as **${WORKDIR}/${PROJECT}.files.${SPLIT}**, and processes line by line.
Each sample is given in each line as follows (*each field is separated by a tab*):

    ${SM}  ${R1}  ${R2}

where the symbols are defined as follows:
1. ${SM} is the sample id
2. ${R1} is the file name of the forward reads
3. ${R2} is the file name of the reverse reads

${SPLIT} is used to facilitate array jobs for processing many samples into several chunks (see below for split jobs).

## Output files
Fastp creates **${SM}.fastp.json** and **${SM}.fastp.html**.
HmmUFOtu creates **${SM}.asn.gz** which reports the mapping and OTU assigment information.
This script creates a summary file called **${WORKDIR}/${$PROJECT}.samples.${SPLIT}**, 
where each line is formed by (*each field is separated by a tab*):

      ${SM}  ${SM}.asn.gz  ${L}

where ${L} is the number lines in the asn file.

## Splitting the whole dataset processing into several batches
It is desirable to split large dataset into several chunks and process each chunk independently. 
We recommend the following procedure:
1. Create **${WORKDIR}/${PROJECT}.files** using mothur's "make.file" command
2. Split it into desired number of files using linux "split" command, so that **${WORKDIR}/${PROJECT}.files.${SPLIT}** files are to be created where **${SPLIT}** runs from 0 through the number of chunks minus 1.
3. Submit the split jobs to the batch queue (see [example scripting for HT condor or PBS](https://docs.google.com/document/d/12PcD8N30HdgR6bOFgEOAc9YXVcbsCr7CsZGO4HGPDJc/edit?usp=sharing)) 
