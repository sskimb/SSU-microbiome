#!/usr/bin/env Rscript
# This is NMF for 16S rRNA amplicon data

.libPaths("/bio/home/sskimb/R/x86_64-redhat-linux-gnu-library/3.6")

library(NMF)

args <- commandArgs(trailingOnly=TRUE)
if( length( args ) == 0 ) {
	message( "Arguments: 1 shared file; 2 # of runs; 3 K's" )
	quit()
}

shdF <- args[1]
nruns <- 50
Ks <- 1:20
if( length(args) > 1 ) {
	nruns <- as.numeric( args[2] )
}
if( length(args) > 2 ) {
	Ks <- as.numeric( args[-(1:2)] )
}

if( length(Ks) == 1 ) {
	print( paste( "From shared file", shdF, nruns, "iterations for a fixed rank", Ks ) )
} else {
	print( paste( "From shared file", shdF, nruns, "iterations for each of ranks", paste(Ks, collapse=' ') ) )
}

shd <- read.delim(shdF, row.names=2, as.is=T)[,-(1:2)]
print( paste( dim(shd)[1], 'features for each of', dim(shd)[2], 'samples, read in' ) )

if( length(Ks) == 1 ) {
	nmfF <- sub('.shared', paste0('.nmfRes.',Ks,'.RData'), shdF)
} else {
	nmfF <- sub('.shared', '.nmf.ranks.RData', shdF)
}
print( paste( 'NMF results to be saved in', nmfF ) )

X <- t(shd)
nmf.res <- nmf(X, Ks, nrun=nruns, seed=123456, .opt='vP')
save(nmf.res, file=nmfF)

if( length(Ks) == 1 ) {
	pdfF <- sub('.shared', paste0('.nmfRes.',Ks,'.pdf'), shdF)
	print( paste( 'NMF basis and coef plots saved in', pdfF ) )
	pdf(pdfF)
	basismap(nmf.res)
	coefmap(nmf.res)
	dev.off()
} else {
	pdfF <- sub('.shared', '.nmf.ranks.pdf', shdF)
	print( paste( 'NMF rank estimation plots saved in', pdfF ) )
	pdf(pdfF)
	plot(nmf.res)
	dev.off()
}
quit()
