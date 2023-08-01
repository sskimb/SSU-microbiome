library(ape)
source("../ape.R")

rdp <- read.tree("gg_97_otus_GTR.RDP18.adjusted.fast.tree")
ZR <- which( rdp$edge.length == 0 )
ZR.parent <- unique( rdp$edge[ZR, 1] )

toRM <- NULL
for( i in 1:length(ZR.parent) ) {
	ZR.parent.edge <- which( rdp$edge[,1] == ZR.parent[i] )
	ZR.children <- rdp$edge[ ZR.parent.edge, 2 ]
	ZR.parent.edge.length <- rdp$edge.length[ ZR.parent.edge ]
	print( paste( ZR.parent[i], ZR.children, ZR.parent.edge.length ) )
	if( length( ZR.parent.edge ) == 1 ) next
	toRM <- c( toRM, ZR.children[-1] )  # keep the first child
}
toRM

print( paste( length(ZR), 'edges with 0 length' ) )
print( paste( length(ZR.parent), 'unique parents' ) )
print( paste( length(toRM), 'tips to remove' ) )

tips.toRM <- rdp$tip.label[ toRM ]
tips.toRM
tips.toKeep <- rdp$tip.label[ -toRM ]

rdp.new <- treePruned( tips.toKeep, tree.old=rdp )
rdp.new <- treeSimple(rdp.new)
write.tree(rdp.new, file="gg_97_otus_GTR.RDP18.adjusted.fast.zeroRM.simple.tree")
