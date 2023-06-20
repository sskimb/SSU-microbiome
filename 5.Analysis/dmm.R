#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly=TRUE)
if( length(args) == 0 ) {
	message('Provide shared file and k (default 7)')
	q()
} else if( length(args) == 1 ) {
	message( args[1] )
	message( 'k is assumed to 7' )
	k <- 7
} else {
	k <- as.numeric(args[2])
}

library(DirichletMultinomial)

shd <- read.delim(args[1], row.names=2, as.is=TRUE)[,-(1:2)]
shd[1:5, 1:3]

fit <- mclapply(1:k, dmn, count=as.matrix(shd), verbose=TRUE, mc.cores=k)
save(fit, file=sub('.shared', '.dmm.RData', args[1]))
