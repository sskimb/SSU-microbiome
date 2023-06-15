#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)	# prefix
outFile <- paste(args[1], 'out', sep='.')
cntFile <- paste(args[1], 'count_table', sep='.')
taxFile <- paste(args[1], 'taxonomy', sep='.')

out <- read.delim(outFile, comment.char='#', row.names=1)
ndgt <- max( nchar( rownames(out)))
sfmt <- paste('UFOtu%0', ndgt, 'd', sep='')
rownames(out) <- sprintf(sfmt, as.numeric(rownames(out)))

tax <- out[, dim(out)[2]]
tax <- paste(tax, ';', sep='')
names(tax) <- rownames(out)
out <- out[, -dim(out)[2]]
total <- rowSums(out)

cat("Representative_Sequence\t", file=cntFile)
write.table(data.frame(total, out), file=cntFile, row.names=T, col.names=T, quote=F, sep="\t", append=T)
write.table(data.frame(tax), file=taxFile, row.names=T, col.names=F, quote=F, sep="\t")
