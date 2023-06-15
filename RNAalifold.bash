#!/bin/bash

cd $1
FASTA=$2

RNAalifold ${FASTA} > ${FASTA}.RNAalifold.out

echo "RNAalifold done for ${FASTA}"
