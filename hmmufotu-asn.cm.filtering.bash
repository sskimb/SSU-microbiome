#!/bin/bash

INFILE=$1
ABDMIN=$2
GAPMAX=$3

echo "${INFILE} ${ABDMIN} ${GAPMAX}"

R --vanilla <<EOJ

suppressPackageStartupMessages(
library(Biostrings)
)

infile <- "${INFILE}"	# like SMK_CD_Saliva_107.ASN.CM.CS.fasta
abdmin <- ${ABDMIN}	# 100
gapmax <- ${GAPMAX}	# 100
outfile <- sub('.fasta', '.pick.fasta', infile)
pdffile <- sub('.fasta', '.pdf', infile)

cs <- readDNAStringSet(infile)
cs
nm <- names(cs)
head(nm)
nm <- strsplit(nm, ' ')
nm <- do.call('rbind', nm)
head(nm)
abd <- as.numeric(nm[,3])
gap <- as.numeric(nm[,5])
summary(abd)
summary(gap)
ID <- abd > abdmin
print( paste( sum(ID), 'GT', abdmin ) )
summary( abd[ID] )
JD <- gap < gapmax
print( paste( sum(JD), 'LT', gapmax ) )
summary( gap[JD] )
ID <- which( ID & JD )
summary(abd[ID])
summary(gap[ID])
writeXStringSet(cs[ID], file=outfile, width=1000)
print( paste(length(ID), 'saved in', outfile) )
pdf(pdffile)
plot(abd, gap, log='xy', cex=0.1, main=infile)
abline( v=abdmin, col='red')
abline( h=gapmax, col='red')
dev.off()
q()
EOJ
