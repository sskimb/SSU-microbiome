#!/usr/bin/env Rscript

DB <- 'gg_97_otus_GTR'

tips <- scan( paste(DB, 'tips', sep='.'), what='character' )
nodes <- scan( paste(DB, 'nodes', sep='.'), what='character' )

library(Biostrings)

seq <- readDNAStringSet( paste(DB, 'seq', sep='.') )
seq.names <- do.call( 'rbind', strsplit( names(seq), ' ' ) )
seq.names.id <- seq.names[,1]

sum( seq.names.id %in% tips )
sum( seq.names.id %in% nodes )

writeXStringSet( seq[ which( seq.names.id %in% tips ) ], paste(DB, 'tips.seq', sep='.'), width=2000 )
writeXStringSet( seq[ which( seq.names.id %in% nodes ) ], paste(DB, 'nodes.seq', sep='.'), width=2000 )
