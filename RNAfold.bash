#!/bin/bash

cd $1
FASTA=$2

RNAfold --infile=${FASTA} --outfile=${FASTA}.RNAfold.out

echo "RNAfold done for ${FASTA}"
