#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly=TRUE)

suppressPackageStartupMessages(
	library(Biostrings)
)

fasta <- readDNAStringSet(args[1])
outfile <- paste(args[1], '.ssCheck', sep='')
ct.df <- read.delim(args[2], header = FALSE)
fw <- paste0( as.character(ct.df[,2]), collapse='' )
cat(fw, 'Consensus forwad', "\n", file=outfile)
rv <- paste0( as.character(ct.df[,3]), collapse='' )
rc <- as.character(complement( RNAString(rv) ))
cat(rc, 'Consensus reverse', "\n", file=outfile, append=T)
cat( compareStrings(fw,rc), 'Comparison', "\n", file=outfile, append=T)

ir1 <- IRanges( start=ct.df[,1], width=1 )
ir2 <- IRanges( start=ct.df[,4], width=1 )

ssComp <- function(seqi, ir1, ir2) {
	s1 <- DNAString( paste0(extractAt( seqi, ir1 ),collapse='') )
	s2 <- complement( DNAString( paste0(extractAt( seqi, ir2 ),collapse='') ) )
	cs <- compareStrings(s1,s2)
	at <- unlist(gregexpr2( '?', cs ))
#	print(at)
	s1at <- extractAt( s1, IRanges(start=at, width=1 ))
	s2at <- extractAt( s2, IRanges(start=at, width=1 ))
	st <- 0
	n <- 0
	for( i in 1:length(s1at) ) {
	  s1ati <- as.character(s1at[[i]])
	  s2ati <- as.character(s2at[[i]])
		if( s1ati == 'G' & s2ati == 'A' ) {
			next
		} else if( s1ati == 'T' & s2ati == 'C' ) {
			next
		} else {
			n <- n + 1
			st[n] <- at[i]
		}
	}
#	print(st)
	mm <- rep('-', nchar(s1))
	mm[st] <- '*'
	paste0(mm, collapse = '')
}

for( i in 1:length(fasta) ) {
	print( paste(i, names(fasta)[i]) )
	seqi <- unlist( strsplit(as.character(fasta[i]),'') )
#	ct.df[,2*i+3] <- seqi[ct.df[,1]]
#	ct.df[,2*i+4] <- seqi[ct.df[,4]]
	cat( ssComp( fasta[[i]], ir1, ir2 ), names(fasta)[i], "\n", file=outfile, append=T )
}
#write.table(ct.df, file='ct.df.txt', row.names=F, col.names=F, quote=F, sep="\t")
