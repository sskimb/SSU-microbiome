#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly=TRUE)

cnt <- read.delim(args[1], row.names=1)
cntSum <- colSums(cnt)
sort(cntSum)
cntSum.sample <- cntSum[ names(cntSum) != 'total' ]
print( 'Now without "total" column' )
summary(cntSum.sample)
print( paste( 'Sum of sample counts is', sum( cntSum.sample ) ) )
print( paste( '# of samples is', dim(cnt[,-1])[2] ) )
print( paste( '# of OTUs is', dim(cnt)[1] ) )
