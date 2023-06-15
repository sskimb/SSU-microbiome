#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)	# prefix
if( length(args) == 0 ) {
	message("Usage: hmmufotu2mothur.R <PREFIX>")
	message("Input: <PREFIX>.out")
	message("Outputs: <PREFIX>.count_table & <PREFIX>.taxonomy")
	q()
}

outFile <- paste(args[1], 'out', sep='.')	# input: .out file from hmmufotu-summary
cntFile <- paste(args[1], 'count_table', sep='.')	# output: mothur-style count_table
taxFile <- paste(args[1], 'taxonomy', sep='.')	# output: mothur-style taxonomy file split from .out file

out <- read.delim(outFile, comment.char='#', row.names=1)
#ndgt <- max( nchar( rownames(out)))
#sfmt <- paste('UFOtu%0', ndgt, 'd', sep='')
#rownames(out) <- sprintf(sfmt, as.numeric(rownames(out)))

tax <- out[, dim(out)[2]]
tax <- paste(tax, ';', sep='')
names(tax) <- rownames(out)
out <- out[, -dim(out)[2]]
total <- rowSums(out)

cat("Representative_Sequence\t", file=cntFile)
write.table(data.frame(total, out), file=cntFile, row.names=T, col.names=T, quote=F, sep="\t", append=T)
write.table(data.frame(tax), file=taxFile, row.names=T, col.names=F, quote=F, sep="\t")
