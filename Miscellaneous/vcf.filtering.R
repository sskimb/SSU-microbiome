#!/usr/bin/Rscript --vanilla

args <- commandArgs(TRUE)
vcf.name <- args[1]

TNpair <- function( labels ) {
	n1 <- nchar( labels[1] )
	n2 <- nchar( labels[2] )
	for( i in 1:min(n1,n2) ) {
		if( substr( labels[1], i, i ) == substr( labels[2], i, i ) ) next
		if( substr( labels[1], i, i ) == 'N' && substr( labels[2], i, i ) == 'T' ) return( c( 2, 1 ) )
		if( substr( labels[1], i, i ) == 'T' && substr( labels[2], i, i ) == 'N' ) return( c( 1, 2 ) )
		cat( paste( 'Unrecognized Tumor-Normal pairing in ', labels ) )
		q()
	}
}

abnormal.plot <- function( vcf.name ) {
	piping <- paste( "sed -e 's/^#//'", vcf.name, sep=' ' )
	vcf <- read.table( pipe( piping ), head=T, sep="\t" )
	cat( paste( vcf.name, ' read', "\n", sep='') )
	vcf.filtered <- vcf[ vcf$FILTER == 'PASS', ]
	sample.offset <- which( colnames(vcf) == 'FORMAT' )
	if( dim(vcf)[2] != sample.offset+2 ) {
		cat( '# of columns is not compatible with paired sampling' )
		q()
	}
	Pairing <- TNpair( colnames(vcf)[-(1:sample.offset)] )
	Normal <- strsplit( as.character(vcf.filtered[,sample.offset+Pairing[2]]), ':' )
	Tumor  <- strsplit( as.character(vcf.filtered[,sample.offset+Pairing[1]]), ':' )

	AD.N <- sapply( Normal, function(x) as.numeric(x[2]) )
	DP.N <- sapply( Normal, function(x) as.numeric(x[4]) )
	FA.N <- sapply( Normal, function(x) as.numeric(x[5]) )
	NZ <- which( FA.N > 0 )
	FA.N.NZ <- FA.N[ NZ ]
	DP.N.NZ <- DP.N[ NZ ]
	AD.N.NZ <- AD.N[ NZ ]

	AD.T <- sapply( Tumor, function(x) as.numeric(x[2]) )
	DP.T <- sapply( Tumor, function(x) as.numeric(x[4]) )
	FA.T <- sapply( Tumor, function(x) as.numeric(x[5]) )
	FA.T.NZ <- FA.T[ NZ ]
	DP.T.NZ <- DP.T[ NZ ]
	AD.T.NZ <- AD.T[ NZ ]

	x <- DP.T.NZ * FA.T.NZ
	y <- DP.N.NZ * FA.N.NZ

	pdf.name <- sub('vcf', 'pdf', vcf.name)
	print( t.test( FA.T[-NZ], FA.T.NZ ) )
	pdf(pdf.name)
	boxplot( list(FA.T[-NZ], FA.T.NZ), names=c('FA.N=0', 'FA.N>0'), main=vcf.name, xlab='Normal Allele Fraction', ylab='Tumor Allele Fraction' )
	plot( x, y, xlab='Allele depth (Tumor)', ylab='Allele depth (Normal)', main=vcf.name )
	dev.off()
	cat( paste( vcf.name, ' plot', "\n", sep='') )
}

abnormal.plot( vcf.name )
