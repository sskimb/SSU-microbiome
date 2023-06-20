#!/usr/bin/env Rscript
# Pick up the first OTU of each phylotype as the representative and save its sequence
# It assumes the OTU list is sorted by the abundance

args <- commandArgs(trailingOnly=T)

if( length(args) == 0 ) {
	message( 'Arg1: Input fasta file' )
	message( 'Arg2: Otu list file of the phylotypes' )
	quit()
}

library(Biostrings)
fst <- readDNAStringSet(args[1])
fst
fstN <- do.call('rbind', strsplit(names(fst), ' '))[,1]

otu <- read.delim(args[2], header=F, row.names=1, as.is=T)
otuL <- strsplit(otu[,2], ',')
head( otu )
dim( otu )

otuX <- sapply( otuL, function(x) x[1] )
FD <- match( otuX, fstN )
message( paste( length(FD), 'matches found' ) )
if( sum( FD == 0 ) > 0 ) {
	message( paste( sum( FD == 0 ), 'phylotypes not matched' ) )
	quit()
}

names(fst)[FD] <- paste0( names(fst)[FD], ' phyloCnt=', otu[,1] )

writeXStringSet( fst[FD], file='kraken2.phylo.fasta' )
message('Saved as kraken2.phylo.fasta')
