#!/usr/bin/env Rscript

# Phylotyping from the hmmufotu otu's
# 1st argument: taxonomy from kraken2
# 2nd argument: count table

args <- commandArgs(trailingOnly=TRUE)
if( length(args) == 0 ) {
	message('Provide *.taxonomy and *.count_table')
	q()
}
print( args )

taxFile <- args[1]
tax <- read.delim(taxFile, header=F, as.is=T, row.names=1)
taxon <- rownames(tax)
tax <- tax[,1]
names(tax) <- taxon

# Up to genus only
tax.lst <- strsplit( tax, ';' )
tax6 <- sapply(tax.lst, function(x) {
	if( length(x) > 6 ) {
		paste0( paste0( x[1:6], collapse=';' ), ';')
	} else {
		paste0( paste0( x, collapse=';' ), ';')
	}
})
names(tax6) <- names(tax)
head( cbind( tax, tax6 ) )
tax <- tax6

#tax.mat <- matrix(NA, ncol=6, nrow=length(tax.lst))
#rownames(tax.mat) <- rownames(tax)
#
#for( i in 1:length(tax.lst) ) {
#	tl <- tax.lst[[i]]
#	ml <- min(6,length(tl))
#	tax.mat[i,1:ml] <- tl[ 1:ml ]
#	if( i %% 10000 == 0 ) {
#		print( tax[i,1] )
#		print( tax.mat[i,] )
#	}
#}
#
#phylo.lst <- tapply( rownames(tax), tax[,1], paste, collapse=',' )
#write.table( data.frame( names(phylo.lst), phylo.lst ), file=sub('.taxonomy', '.phylo.taxonomy', taxFile), row.names=F, col.names=F, quote=F, sep="\t" )

cntFile <- args[2]
cnt <- read.delim(cntFile, as.is=T, row.names=1)
dim(cnt)
cnt[1:10, 1:5]
tax <- tax[ names(tax) %in% rownames(cnt) ]

phyCnt <- function( otu, cnt ) {
	CSum <- colSums( cnt[otu,], na.rm=T )
	c( CSum, paste( otu[ order( cnt[otu,1], decreasing=T ) ], collapse=',' ) )		# add the OTU name of the maximum abundance per phylotype
}

phyloCnt <- do.call('rbind', tapply( names(tax), factor(tax), phyCnt, cnt ))
phyloTax <- rownames(phyloCnt)
phyloOtu <- phyloCnt[, ncol(phyloCnt)]
phyloCnt <- phyloCnt[, -ncol(phyloCnt)]		# character matrix
class(phyloCnt) <- 'numeric'			# to convert to numeric matrix

# Remove phylotypes annotated as "NA"
if( sum( phyloTax == "NA;" ) > 0 ) {
	message( 'NA phylotypes recognized, and removed' )
	print( summary( as.numeric( phyloCnt[ phyloTax == 'NA;', ] ) ) )
	phyloCnt <- phyloCnt[ phyloTax != "NA;", ]
	phyloTax <- phyloTax[ phyloTax != "NA;" ]
	phyloOtu <- phyloOtu[ phyloTax != "NA;" ]
} else {
	message( 'No phylotype annotated as "NA;"' )
}

rownames(phyloCnt) <- sprintf('Phy%05d', 1:dim(phyloCnt)[1])
write.table( cbind( rownames(phyloCnt), phyloTax ), file=sub('.count_table', '.phylo.taxonomy', cntFile), row.names=F, col.names=F, quote=F, sep="\t" )
write.table( cbind( rownames(phyloCnt), phyloCnt[,1], phyloOtu ), file=sub('.count_table', '.phylo.otu', cntFile), row.names=F, col.names=F, quote=F, sep="\t" )

phyloCnt <- t( phyloCnt[,-1] )

shared <- data.frame( label=rep('phy', dim(phyloCnt)[1]), Group=rownames(phyloCnt), numOtus=rep(dim(phyloCnt)[2], dim(phyloCnt)[1]), phyloCnt )
write.table( shared, file=sub('.count_table', '.phylo.shared', cntFile), row.names=F, col.names=T, quote=F, sep="\t" )
