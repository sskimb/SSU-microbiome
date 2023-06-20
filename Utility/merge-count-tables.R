#!/usr/bin/env Rscript
# Merge two mothur-style count tables

args <- commandArgs(trailingOnly=TRUE)

if( length(args) != 2 ) {
	message("Two mothur-style count tables are required")
	q()
}

cnt1 <- read.delim(args[1], row.names=1)[,-1]
cnt2 <- read.delim(args[2], row.names=1)[,-1]

dim(cnt1)
dim(cnt2)

ComC <- intersect( colnames(cnt1), colnames(cnt2) )
UniC <- union( colnames(cnt1), colnames(cnt2) )
ComR <- intersect( rownames(cnt1), rownames(cnt2) )
UniR <- union( rownames(cnt1), rownames(cnt2) )
DifR <- setdiff( rownames(cnt1), rownames(cnt2) )

commonSamples <- function(CC) {
	sum1 <- sum(cnt1[,CC])
	sum2 <- sum(cnt2[,CC])
	print( paste('Total count for', args[1], CC, sum1) )
	print( paste('Total count for', args[2], CC, sum2) )
	print( summary(cnt1[,CC]) )
	print( summary(cnt2[,CC]) )
	if( sum1 < sum2 ) {
		cnt1 <- cnt1[,-which( colnames(cnt1) == CC )]
		f <- 1
	} else {
		cnt2 <- cnt2[,-which( colnames(cnt2) == CC )]
		f <- 2
	}
	f
}

if( length(ComC) > 0 ) {
	message( paste( length(ComC), 'samples common' ) )
	print( paste( 'Common samples between', args[1], 'and', args[2] ) )
	print( ComC )
	for( k in 1:length(ComC) ) {
		CC <- ComC[k]
		sum1 <- sum(cnt1[,CC])
		sum2 <- sum(cnt2[,CC])
		print( paste('Total count for', args[1], CC, sum1) )
		print( paste('Total count for', args[2], CC, sum2) )
		print( summary(cnt1[,CC]) )
		print( summary(cnt2[,CC]) )
		if( sum1 < sum2 ) {
			cnt1 <- cnt1[,-which( colnames(cnt1) == CC )]
			f <- 1
		} else {
			cnt2 <- cnt2[,-which( colnames(cnt2) == CC )]
			f <- 2
		}
		print( 'Removed in the following dataset' )
		print( args[f] )
		dim(cnt1)
		dim(cnt2)
	}
	ComC <- intersect( colnames(cnt1), colnames(cnt2) )
	UniC <- union( colnames(cnt1), colnames(cnt2) )
	print( paste( length(ComC), length(UniC) ) )
}

if( length(ComC) > 0 ) {
	message( paste( ComC, 'common samples' ) )
} else {
	message( 'No samples common' )
}

print( paste( length(UniC), 'unique samples' ) )

message( paste( length(ComR), 'OTUs common' ) )
message( paste( length(UniR), 'OTUs union' ) )

mgd <- matrix(0, nrow=length( UniR ), ncol=length( UniC ) )
rownames(mgd) <- UniR
length( colnames(cnt1) )
length( colnames(cnt2) )
colnames(mgd) <- c( colnames(cnt1), colnames(cnt2) )
dim(mgd)

RD1 <- match( rownames(cnt1), UniR )
head(RD1)
for( j in 1:dim(cnt1)[2] ) {
	mgd[ RD1, j ] <- cnt1[,j]
}
dim(mgd)

RD2 <- match( rownames(cnt2), UniR )
head(RD2)
for( j in 1:dim(cnt2)[2] ) {
	mgd[ RD2, (j+dim(cnt1)[2]) ] <- cnt2[,j]
}
dim(mgd)

total <- rowSums( mgd )
# When overlapped samples were removed, some OTUs can become 0 abundant. These should be removed.
mgd <- mgd[ total > 0, ]
total <- total[ total > 0 ]
mgd.df <- data.frame( merged=rownames(mgd), total=total, mgd )

write.table(mgd.df, file='merged.count_table', row.names=F, col.names=T, sep="\t", quote=F)
q()
