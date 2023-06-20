# From taxonomy/{names,nodes}.dump files,
# create mothur-style taxonomy file

names.dmp <- readLines("taxonomy/names.dmp")
head(names.dmp)
names.dmp <- gsub('\\t', '', names.dmp)
names.dmp <- do.call('rbind', strsplit(names.dmp, '\\|'))
rownames(names.dmp) <- names.dmp[,1]
names.dmp <- as.data.frame( names.dmp[,-1] )
head(names.dmp)

nodes.dmp <- readLines("taxonomy/nodes.dmp")
head(nodes.dmp)
nodes.dmp <- gsub('\\t', '', nodes.dmp)
nodes.dmp <- do.call('rbind', strsplit(nodes.dmp, '\\|'))
rownames(nodes.dmp) <- nodes.dmp[,1]
nodes.dmp <- as.data.frame( nodes.dmp[,-1] )
head(nodes.dmp)

dim(names.dmp)
dim(nodes.dmp)
table( nodes.dmp[,2] )

oneLetter <- c('r', 'k', 'p', 'c', 'o', 'f', 'g', 's')
names(oneLetter) <- c('no rank', 'superkingdom', 'phylum', 'class', 'order', 'family', 'genus', 'species')
nodes.dmp[,2] <- oneLetter[ as.character(nodes.dmp[,2]) ]
table( nodes.dmp[,2] )

taxa <- rep(NA, times=dim(names.dmp)[1])
names(taxa) <- rownames(names.dmp)
taxa[1] <- names.dmp[1,1]
for( i in 2:dim(names.dmp)[1] ) {
	RN <- as.character( nodes.dmp[i,1] )
	taxa[i] <- paste( taxa[ RN ], as.character( names.dmp[ RN, 1 ] ), '', sep=';' )
}
head( taxa, 10 )
write.table( cbind( names(taxa), taxa ), file='mothur-style.taxonomy', sep="\t", quote=F, row.names=F, col.names=F )
