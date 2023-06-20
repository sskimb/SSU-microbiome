#!/usr/bin/env Rscript

suppressPackageStartupMessages(
library(Biostrings)
)
args <- commandArgs(trailingOnly=TRUE)
print(args)

infile <- args[1]		# like SMK_CD_Saliva_107.ASN.CM.CS.fasta
abdmin <- as.numeric(args[2])	#  50
gapmax <- as.numeric(args[3])	# 100
outfile <- sub('.fasta', '.pick.fasta', infile)
pdffile <- sub('.fasta', '.pdf', infile)

cs <- readDNAStringSet(infile)
cs
nm <- names(cs)
nm <- strsplit(nm, ' ')
nm <- do.call('rbind', nm)
abd <- as.numeric(nm[,3])
gap <- as.numeric(nm[,5])
summary(abd)
ID <- abd > abdmin
print( paste( sum(ID), 'GT', abdmin ) )
summary( abd[ID] )
summary(gap)
JD <- gap < gapmax
print( paste( sum(JD), 'LT', gapmax ) )
summary( gap[JD] )
ID <- which( ID & JD )
print( paste( sum(ID), 'abd >', abdmin, '& gap <', gapmax ) )
summary(abd[ID])
summary(gap[ID])
writeXStringSet(cs[ID], file=outfile, width=1000)
print( paste(length(ID), 'saved in', outfile) )
pdf(pdffile)
plot(abd, gap, log='xy', cex=0.1, main=infile)
abline( v=abdmin, col='red')
abline( h=gapmax, col='red')
dev.off()
