#!/usr/bin/env Rscript

.libPaths("/bio/home/sskimb/R/x86_64-redhat-linux-gnu-library/3.6")

library(DECIPHER)
dbFile <- 'CD+UC+HC.kraken2.kraken2.filter.denovo.vsearch.classified.fasta.sqlite'
dbConn <- dbConnect(SQLite(), dbFile)
tiles <- TileSeqs(dbConn, add2tbl='Tiles', minCoverage=1)
dbDisconnect(dbConn)

head(tiles)
