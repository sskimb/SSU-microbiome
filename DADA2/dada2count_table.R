#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly=TRUE)
if( length(args) == 0 ) {
	message( '1st argument count table is missing, abort' )
	quit()
}

cname <- sub( '.count_table', '.asv.count_table', args[1] )
fname <- sub( '.count_table', '.asv.fasta', args[1] )

cnt <- read.delim(args[1], row.names=1, as.is=TRUE)

library(Biostrings)
seq <- DNAStringSet(rownames(cnt))
dig <- floor( log10( length(seq) )) + 1
fmt <- paste0( '%0', dig, 'd' )
asv <- paste0( 'ASV', sprintf( fmt, 1:length(seq) ) )

names(seq) <- asv

print( dim(cnt) )
print( paste( dig, 'digits in naming ASVs with format', fmt ) )
head( asv )

write.table( data.frame( asv=asv, cnt ), file=cname, row.names=F, col.names=T, sep="\t", quote=F )
print( paste( 'Revised count tables written to', cname ) )

writeXStringSet(seq, file=fname, format='fasta', width=1000)
print( paste( 'Sequences are saved in', fname ) )
