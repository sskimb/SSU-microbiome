library(Biostrings)

ggRDP.full <- readDNAStringSet("../gg_97_otus_GTR.RDP18.adjusted.fasta")
writeXStringSet( subseq( ggRDP.full, 480, 947 ), file='gg_97_otus_GTR.RDP18.adjusted.V3V4.fasta', width=500 )
