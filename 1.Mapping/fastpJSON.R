#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly=TRUE)
if( length(args) == 0 ) {
	files <- dir(pattern='.fastp.json')
} else {
	files <- args
}

print(paste(files))

df <- data.frame( sample=sub('.fastp.json', '', files), before=rep(0, length(files)), after=rep(0, length(files)), lowQ=rep(0, length(files)), manyN=rep(0, length(files)), short=rep(0, length(files)), long=rep(0, length(files)), GCcontent=rep(0, length(files)), duplication=rep(0, length(files)), filtering=rep(0, length(files)) )

suppressPackageStartupMessages( library(jsonlite) )

for( i in 1:length(files) ) {
	lst <- read_json(files[i])
	df[i,2] <- lst$summary$before_filtering$total_reads
	df[i,3] <- lst$summary$after_filtering$total_reads
	df[i,4] <- lst$filtering_result$low_quality_reads
	df[i,5] <- lst$filtering_result$too_many_N_reads
	df[i,6] <- lst$filtering_result$too_short_reads
	df[i,7] <- lst$filtering_result$too_long_reads
	df[i,8] <- lst$summary$after_filtering$gc_content
	df[i,9] <- lst$duplication$rate
	df[i,10] <- round( (df[i,2] - df[i,3]) / df[i,2], 6)
	message(files[i])
}

write.table( df, file='fastp.json.summary', row.names=F, col.names=T, quote=F, sep="\t" )
