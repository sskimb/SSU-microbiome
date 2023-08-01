library(ape)
rdp <- read.tree("gg_97_otus_GTR.RDP18.adjusted.fast.tree")
sum( rdp$edge.length == 0)
ZR <- which( rdp$edge.length == 0 )
length(ZR)
ZR.parent <- rdp$edge[ZR, 1]
for( i in 1:length(ZR.parent) ) {
	ZR.parent.edge <- which( rdp$edge[,1] == ZR.parent[i] )
	ZR.children <- rdp$edge[ ZR.parent.edge, 2 ]
	ZR.parent.edge.length <- rdp$edge.length[ ZR.parent.edge ]
	print( paste( ZR.parent[i], ZR.children, ZR.parent.edge.length ) )
}

