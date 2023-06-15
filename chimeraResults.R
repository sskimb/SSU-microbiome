#!/usr/bin/env Rscript

# 1st: taxonomy
# 2nd: count table
# 3rd: chimera

args <- commandArgs(trailingOnly=TRUE)

taxo <- read.delim(args[1], header=FALSE, as.is=TRUE, row.names=1)
head(taxo)
dim(taxo)

cntt <- read.delim(args[2], as.is=TRUE, row.names=1)
cntt[1:5, 1:5]
dim(cntt)

chim <- read.delim(args[3], header=FALSE, as.is=TRUE)
dim(chim)
chim <- chim[ chim[,18] == 'Y', ]
dim(chim)
Query <- sub('^K', '', chim[,2])
Left  <- sub('^K', '', chim[,3])
Right <- sub('^K', '', chim[,4])

df <- data.frame( Query, Left, Right, CntQ=cntt[Query,1], CntL=cntt[Left,1], CntR=cntt[Right,1], TaxQ=taxo[Query,1], TaxL=taxo[Left,1], TaxR=taxo[Right,1] )
write.table(df, file='Chimeras.count.taxonomy.txt', row.names=F, col.names=T, quote=F, sep="\t")

for( i in 1:10 ) {
	write( c(
	Query[i], cntt[Query[i],1], taxo[Query[i],1], 
	Left[i], cntt[Left[i],1], taxo[Left[i],1], 
	Right[i], cntt[Right[i],1], taxo[Right[i],1] 
	), ncolumn=3, file='', sep="\t")
	print( '' )
}
