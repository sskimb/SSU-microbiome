#!/usr/bin/env Rscript
# 1st argument: shared file name
# 2nd argument: minimum sample depth (default 20000)
# 3rd arguemnt: minimum OTU abudance (default 10)

args <- commandArgs(trailingOnly=TRUE)
if( length(args) == 0 ) {
	message("Supply shared file name as the first argument")
	q()
} else if( length(args) > 0 ) {
	shdin <- args[1]
	shdout <- sub('.shared', '.trim.shared', shdin)
	if( length(args) > 1 ) {
		minDepth <- as.numeric(args[2])
		if( length(args) > 2 ) {
			minAbd <- as.numeric(args[3])
		} else {
			minAbd <- 10
		}
	} else {
		minDepth <- 20000
		minAbd <- 10
	}
} 
print( paste('Input shared file', shdin) )
print( paste('Output shared file', shdout) )
print( paste('Sample depth', minDepth, sep=' >= ') )
print( paste('OTU abundance', minAbd, sep=' >= ') )

shd.df <- read.delim(shdin, row.names=2)
shd <- shd.df[,-(1:2)]
dim(shd)
otu.sum <- colSums(shd)
sum(otu.sum)
sam.sum <- rowSums(shd)
sum(sam.sum)
otu.srt <- sort(otu.sum, decreasing=T)
names(otu.srt)[ otu.srt >= minAbd ] -> otu.kept
names(sam.sum)[ sam.sum >= minDepth ] -> sam.kept
shd.kept <- shd[ sam.kept, otu.kept ]
dim(shd.kept)
sam.kept.sum <- rowSums( shd.kept )
sum(sam.kept.sum)
otu.kept.sum <- colSums( shd.kept )
sum(otu.kept.sum)
names(otu.kept.sum)[otu.kept.sum >= minAbd] -> otu.kept
shd.kept <- shd[ sam.kept, otu.kept ]
dim(shd.kept)
otu.kept.sum <- colSums( shd.kept )
sum(otu.kept.sum)
sam.kept.sum <- rowSums( shd.kept )
sum(sam.kept.sum)
shd.df <- data.frame( label=shd.df[sam.kept,1], Group=sam.kept, numOtus=length(otu.kept), shd.kept )
write.table(shd.df, file=shdout, row.names=F, col.names=T, quote=F, sep="\t")
