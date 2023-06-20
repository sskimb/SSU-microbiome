#!/usr/bin/env Rscript

# This is to access my local R packages
.libPaths("/bio/home/sskimb/R/x86_64-redhat-linux-gnu-library/3.6")

suppressPackageStartupMessages( library(Biostrings) )

args <- commandArgs(trailingOnly=TRUE)

setwd(args[1])

samples <- read.delim(args[2], header=FALSE, row.names=1, as.is=T)

if( grepl('gg', args[3]) ) {
#	ggDB V3-V4
	start <- 311
	end <- 756
	message( paste('Assuming GreenGene MSA, V3 starts at', start, 'and V4 ends at', end) )
} else if( grepl('RDP', args[3]) ) {
#	RDP trainingset 18 V3-V4
	start <- 2630
	end <- 3812
	message( paste('Assuming RDP 9 MSA, V3 starts at', start, 'and V4 ends at', end) )
} else {
	start <- 0
	end <- 0
	message( 'Assuming the reference contains only V3-V4, and thus no extraction of the alignment' )
}

# ifelse produces 1-element character regardless of the length of the source vector
cmat <- function(x) {
	if( start > 0 ) {
		xs <- subseq(x, start, end)
	} else {
		xs <- x
	}
	xsl <- consensusMatrix( DNAStringSet(xs), as.prob=F )[1:4,]
	as.vector(xsl)
}

for( i in 1:dim(samples)[1] ) {
	print( paste('Processing', samples[i,1]) )
	asn <- read.delim( as.character(samples[i,1]), comment.char='#', row.names=1, as.is=T )
	abd <- table( asn$taxon_id )
	cmi <- do.call('rbind', tapply( asn$alignment, asn$taxon_id, cmat ))
	rownames(cmi) <- names(abd)
	write.table( cbind(abd, cmi), file=paste( rownames(samples)[i], '.asn.cm', sep='' ), col.names=F, row.names=T, quote=F )
}
