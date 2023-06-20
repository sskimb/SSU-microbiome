#!/usr/bin/env Rscript
# count_table can be cleaned during tree cleaning (cleaned.tree)
# the corresponding fasta should also be cleaned using cleaned.count_table

args <- commandArgs(trailingOnly=TRUE)
if( length(args) == 0 ) {
	message("Usage: ~/fasta.filtering.R count_table fasta_file")
	quit()
}

cntFile <- args[1]
fstFile <- args[2]

suppressPackageStartupMessages( library(Biostrings) )
cnt <- read.delim(cntFile, row.names=1)
message( paste( dim(cnt)[1], "OTUs in count_table" ) )
fst <- readDNAStringSet(fstFile)
fst
fst.names <- do.call('rbind', strsplit( names(fst), ' ' ) )[,1]
COM <- which( fst.names %in% rownames(cnt) )
message( paste( length(fst), "sequences in the", fstFile ) )
message( paste( length(COM), "sequences to be saved in 'cleaned.fasta'" ) )
writeXStringSet( fst[COM], file='cleaned.fasta', width=nchar(fst[1]) )
