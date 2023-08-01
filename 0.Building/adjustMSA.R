#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly=TRUE)
if( ! grepl( '.fasta', args[1] ) ) {
	message('*.fasta should be given')
	q()
}

library(DECIPHER, quietly=T)
msa <- readDNAStringSet( args[1] )
msa

if( length(args) > 1 ) {
	excSeqs <- read.delim( args[2], head=F )[,1]
	message( paste( length(excSeqs), 'sequences to be removed' ) )
	print( paste( 'Sequences to be removed', paste( excSeqs, collapse=' ' ) ) )
	msa <- msa[ ! names(msa) %in% excSeqs ]
	msa
}

cm <- consensusMatrix( msa, as.prob=F )[1:4,]

cmc <- colSums(cm)
sort(cmc)

cmc.z <- cmc == 0
head(cmc.z, 100)
cmc.z.rle <- rle(cmc.z)

head( cmc.z.rle$values, 100 )
head( cmc.z.rle$lengths, 100 )
cmc.z.stop <- cumsum( cmc.z.rle$lengths )
head( cmc.z.stop, 100 )

n <- 0
for( i in length( cmc.z.rle$values ):1 ) {
	if( cmc.z.rle$values[i] ) {
		n <- n + 1
		stop <- cmc.z.stop[i]
		start <- stop - cmc.z.rle$lengths[i] + 1
		print( paste(i, start, stop) )
		subseq( msa, start = start, end = stop ) <- NULL
	}
}
print('Spliced gap-only positions')
msa

cm <- consensusMatrix( msa, as.prob=F )[1:4,]

cmc <- colSums(cm)
sort(cmc)

cmc.z <- cmc < length(msa)*0.01
head(cmc.z, 100)
cmc.z.rle <- rle(cmc.z)

head( cmc.z.rle$values, 100 )
head( cmc.z.rle$lengths, 100 )
cmc.z.stop <- cumsum( cmc.z.rle$lengths )
head( cmc.z.stop, 100 )

n <- 0
for( i in length( cmc.z.rle$values ):1 ) {
        if( cmc.z.rle$values[i] ) {
                n <- n + 1
                stop <- cmc.z.stop[i]
                start <- stop - cmc.z.rle$lengths[i] + 1
                print( paste(i, start, stop) )
                subseq( msa, start = start, end = stop ) <- NULL
        }
}
print('Spliced positions more than 99% gap')
msa

writeXStringSet(msa, sub('.fasta', '.compacted.fasta', args[1]), width=nchar(msa[1]))
print( sub('.fasta', '.compacted.fasta', args[1]) )
msa.adj <- AdjustAlignment(msa)
msa.adj
writeXStringSet(msa.adj, sub('.fasta', '.adjusted.fasta', args[1]), width=nchar(msa.adj[1]))
print( sub('.fasta', '.adjusted.fasta', args[1]) )
