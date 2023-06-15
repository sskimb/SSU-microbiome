#!/usr/bin/env Rscript

# Summarize taxonomy of opti-cluster OTUs from taxonomy of hmmufotu consensus sequence
# 1st argument: taxonomy of hmmufotu consensus sequence
# 2nd argument: OTU list of opti-clustering
# 3rd argument: count table of hmmufotu consensus sequence

args <- commandArgs(trailingOnly=TRUE)
print( args )

taxFile <- args[1]
tax <- read.delim(taxFile, header=F, as.is=T, row.names=1)
tax.lst <- strsplit( tax[,1], ';' )
tax.mat <- matrix(NA, ncol=6, nrow=length(tax.lst))
rownames(tax.mat) <- rownames(tax)

for( i in 1:length(tax.lst) ) {
	tl <- tax.lst[[i]]
	ml <- min(6,length(tl))
	tax.mat[i,1:ml] <- tl[ 1:ml ]
	if( i %% 10000 == 0 ) {
		print( tax[i,1] )
		print( tax.mat[i,] )
	}
}

otuFile <- args[2]
outTaxa <- sub('.otu$', '.taxonomy', otuFile)
otu <- read.delim(otuFile, as.is=T, header=F, row.names=1)
otu.lst <- strsplit(otu[,1], ',')
otu.tax <- vector('character', length=length(otu.lst))
names(otu.tax) <- rownames(otu)

cntFile <- args[3]
cnt <- read.delim(cntFile, row.names=1)

consensusTax <- function( x, w ) {
	total <- sum(w)
	NZ <- which( !is.na(x) )
	if( length(NZ) == 0 ) {
		c( 'NA', 100 )
	} else {
		w <- w[NZ]
		x <- x[NZ]
		xt <- tapply( w, x, sum )
#	xt <- table(x, useNA='ifany')
		wm <- which.max(xt)
		c( names(xt)[wm], round(xt[wm]/total*100) )
	}
}

for( j in 1:length(otu.lst) ) {
	if( j %% 10000 == 0 ) print( j )
	ol <- otu.lst[[j]]
	if( j %% 10000 == 0 ) print( ol )
	iol <- match( ol, rownames(tax.mat) )
	if( j %% 10000 == 0 ) print( iol )
	if( sum( is.na(iol) ) > 0 ) {
		print( paste( 'Missing in taxonomy for ', j, '-th OTU', sep='' ) )
		print( ol[which(is.na(iol))] )
		if( sum( !is.na(iol) ) == 0 ) {
			print( 'No non-NA taxa, skip' )
			otu.tax[j] <- NA
			next
		} else {
			ol <- ol[!is.na(iol)]
		}
	}
	tl <- tax.mat[ ol, ]
	if( length(ol) > 1 ) {
		cs <- apply( tl, 2, consensusTax, cnt[ol,1] )
	} else {
		cs <- matrix( c( tl, rep(100, length(tl)) ), nrow=2, byrow=TRUE )
	}
	if( j %% 10000 == 0 ) print( cs )
	otu.tax[j] <- paste( cs[1,], '(', cs[2,], ')', sep='', collapse=';' )
	if( j %% 10000 == 0 ) {
		print( otu.tax[j] )
	}
}

write.table( data.frame( names(otu.tax), otu.tax ), file=outTaxa, row.names=F, col.names=F, quote=F, sep="\t" )
print( paste('Consensus Taxonomy for opti-clust OTUs is saved in', outTaxa) )
