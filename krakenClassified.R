#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly=TRUE)
if(length(args) == 0 ) {
	message( 'Provide Kraken2 output file and count table [ezbio]' )
	q()
}

KOUTfile <- args[1]
CNTfile <- args[2]

if(length(args) == 3 & tolower(args[3]) == 'ezbio') {
	taxDB <- read.delim('/bio/home/sskimb/Microbiome/Kraken2/EzBio_DB/mothur.taxonomy.txt', header=F, as.is=T)
	taxDB <- cbind( taxDB[,2], taxDB[,1] )
	print('Now taxonomy file generation using EzBioCloud 2019')
} else {
	taxDB <- read.delim('/bio/home/sskimb/Microbiome/Kraken2/SILVA138_DB/tax_slv_ssu_138.1.txt', header=F, as.is=T)
	print('Now taxonomy file generation using SILVA138')
}	
head(taxDB)

KOUT <- read.delim(KOUTfile, header=F, as.is=T)
print( paste( paste(dim(KOUT), collapse='x'), 'from', KOUTfile ) )
CNT <- read.delim(CNTfile, header=T, as.is=T)
print( paste( paste(dim(CNT), collapse='x'), 'from', CNTfile ) )

Classified <- KOUT[ KOUT$V1 == 'C', 2 ]
print( paste( length(Classified), 'classified by Kraken2, out of', dim(KOUT)[1], 'OTUs' ) )

CNT.cls <- CNT[ CNT[,1] %in% Classified, ]
TxID <- KOUT[ match(CNT.cls[,1], KOUT[,2]), 3 ]
taxon <- taxDB[ match(TxID, taxDB[,2]), 1 ]
print( paste( sum( is.na(taxon) ), 'taxa were NA and removed' ) )
CNT.cls <- CNT.cls[ !is.na(taxon), ]
taxon <- taxon[ !is.na(taxon) ]

print( paste( dim(CNT.cls)[1], 'lines to be saved, out of', dim(CNT)[1], 'lines' ) )
print( paste( 'Total count is', sum(CNT.cls$total), '; was', sum(CNT$total) ) )

write.table( CNT.cls, file='kraken2.count_table', row.names=F, quote=F, sep="\t" )
write.table( cbind( CNT.cls[,1], taxon ), file='kraken2.taxonomy', row.names=F, col.names=F, quote=F, sep="\t" )
print('kraken2.taxonomy & kraken2.count_table files saved')
