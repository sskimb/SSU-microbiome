#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly=TRUE)
matx <- read.delim(args[1], header=T, as.is=T)
print( paste('# of columns', dim(matx)[2]) )
head( colnames(matx) )
print( paste('# of rows', dim(matx)[1]) )
matx[ 1:min( dim(matx)[1], 5 ), 1:min( dim(matx)[2], 5 ) ]
