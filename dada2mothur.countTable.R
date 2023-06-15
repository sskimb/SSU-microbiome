#!/usr/bin/env Rscript
# Usage: $0 seqtab*.RData

args <- commandArgs(trailingOnly=TRUE)
if( length(args) == 0 ) {
	args <- dir(pattern='seqtab*.RData')
}
print( 'Following files found' )
print( args )

for( i in 1:length(args) ) {
	load( args[i] )
	cnt <- t(seqtab.nochim)
	total <- rowSums(cnt)
	cnt.df <- data.frame( Representative_sequence=rownames(cnt), total, cnt )
	write.table( cnt.df, file=sub('.RData', '.count_table', args[i]), sep="\t", quote=F, row.names=F, col.names=T )
}
