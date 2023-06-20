#!/bin/env Rscript

# To use locally installed packages
.libPaths("/bio/home/sskimb/R/x86_64-redhat-linux-gnu-library/3.6")

args <- commandArgs(trailingOnly=TRUE)
treeFile <- args[1]
cntFile  <- args[2]
minAbd   <- args[3]
if( is.na( minAbd ) ) {
	minAbd <- 30000
} else {
	minAbd <- as.numeric(minAbd)
}
print(minAbd)

library(ape)
library(parallel)
source("/bio/home/sskimb/Microbiome/ggDB/ape.R")

tree <- read.tree(file=treeFile)
message( 'Tree read' )
print( str(tree) )
print( paste('Tree is read from', treeFile) )
print( 'Cleaned tree is to be saved in cleaned.tree')

cnt <- read.delim(cntFile, row.names=1)
message( 'Count table read' )
print( paste('Abundance is read from', cntFile) )

cntSum <- colSums(cnt)
NC <- which( cntSum < minAbd )
if( length(NC) > 0 ) {
	print( paste0( paste( colnames(cnt)[NC] ), ' rejected due to abundance < ', minAbd ) )
	cnt <- cnt[, -NC]
	cntSum <- rowSums( cnt[,-1] )
	NR <- which( cntSum == 0 )
	if( length(NR) > 0 ) {
		print( paste( length(NR), 'OTUs become zero-abundant and are removed' ) )
		print( paste0( rownames(cnt)[NR] ) )
		cnt <- cnt[-NR,]
	}
	message( 'Low abundance samples filtered' )
}

tree <- treePruned( rownames(cnt), tree )
message( 'Pruning tips not found in count_table' )

InNode <- intersect( rownames(cnt), tree$node.label )
message( 'Internal nodes appearing in count table were identified' )

DESC.list <- mclapply( InNode, descendents, tree, mc.cores=20 )
message( 'Descendents of internal nodes were identified' )

TIPS.list <- mclapply( DESC.list, intersect, tree$tip.label, mc.cores=20 )
message( 'among them, tips were identified' )

TIPS.list <- mclapply( TIPS.list, intersect, rownames(cnt), mc.cores=20 )
message( 'Tips appearing in count table were identified' )

WEIT.list <- mclapply( TIPS.list, function(x) cnt[x,1]/sum(cnt[x,1],na.rm=TRUE), mc.cores=20 )
message( 'Count distribution weights based on total counts were calculated' )

str(DESC.list)
str(TIPS.list)
str(WEIT.list)

for( i in 1:length(InNode) ) {
	TIPS <- TIPS.list[[i]]
	WEIT <- WEIT.list[[i]]
	WEIT.cnt <- crossprod( t(WEIT), as.numeric( cnt[InNode[i],-1] ) )	# data.frame to vector
	cnt[TIPS,-1] <- cnt[TIPS,-1] + WEIT.cnt
	if( i %% 100 == 0 ) message( paste( 'Node', i, 'processed' ) )
}
message( "Distribution of internal nodes' counts were done" )
str(cnt)

cnt <- cnt[-match(InNode, rownames(cnt)),]
str(cnt)
cnt <- round(cnt)
str(cnt)
cnt[,1] <- rowSums(cnt[,-1])
str(cnt)
message( 'These internal nodes are removed from count_table' )

cat("Representative_sequence\t", file='cleaned.count_table')
write.table(cnt, file='cleaned.count_table', row.names=T, col.names=T, sep="\t", quote=F, append=T)
print("Cleaned abundance is saved in cleaned.count_table")
message( 'Cleaned count table is saved' )

tree <- treeSimple( tree )
message( 'As some tips were removed, single-child parents were merged to grand-parent' )

# Root node can have missing branch length
summary( tree$edge.length )
tree <- treeFixNaN(tree)

print( str(tree) )
write.tree(tree, file='cleaned.tree')
message( 'Cleaned tree was saved. All done' )

q()
