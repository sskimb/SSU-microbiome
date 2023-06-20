#!/bin/bash
# Usage: $0  DB_NAME  FASTA

kraken2 --db $1 $2.fasta \
	--threads 20 \
	--classified-out $2.classified.fasta \
	--unclassified-out $2.unclassified.fasta \
	--report $2.kreport2 \
	--output $2.kraken2.out
