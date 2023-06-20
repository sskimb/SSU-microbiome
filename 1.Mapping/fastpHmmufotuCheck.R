#!/usr/bin/env Rscript

samples <- dir(pattern='.samples.')
if( length(samples) == 0 ) {
	message("No samples file found")
	quit(status=1)
}

asn.summary.list <- list()
for( i in 1:length(samples) ) {
	asn.summary.list[[i]] <- read.delim(samples[i], header = F, row.names=1)
}
asn.summary <- do.call('rbind', asn.summary.list)

message( dim(asn.summary)[1] )
head(asn.summary)

fastp.summary <- read.delim("fastp.json.summary", row.names = 1)
message( dim(fastp.summary)[1] )
head(fastp.summary)

if( dim(asn.summary)[1] != dim(fastp.summary)[1] ) {
	MISSING <- setdiff( rownames(fastp.summary), rownames(asn.summary) )
	print( paste( length(MISSING), 'samples missing in ASN' ) )
	print( MISSING )
	fastp.summary <- fastp.summary[ match( rownames(asn.summary), rownames(fastp.summary) ), ]
}

fastp.before <- fastp.summary$before / 2
fastp.after <- fastp.summary$after / 2
names(fastp.before) <- rownames(fastp.summary)
names(fastp.after) <- rownames(fastp.summary)

plotCooksd <- function( x,y ) {
	mod <- lm( y ~ x )
	cooksd <- cooks.distance(mod)
	names(cooksd) <- names(x)
	plot(cooksd, pch='*', cex=0.5)
	abline(h = 4*mean(cooksd, na.rm=T), col='red')
	text(x=1:length(cooksd)+1, y=cooksd, labels=ifelse(cooksd>4*mean(cooksd, na.rm=T), names(cooksd), ""), col='red')
	which( cooksd>4*mean(cooksd, na.rm=T) )
}

cat("sample\t", file='fastpHmmufotuChecking.out')
write.table( data.frame(fastpBefore=fastp.before, fastpAfter=fastp.after, asnSummary=asn.summary[,2]), file='fastpHmmufotuChecking.out', row.names=T, col.names=T, sep="\t", quote=F, append=T )

pdf( 'fastpHmmufotuChecking.pdf' )
plot( fastp.before, asn.summary[,2], ylab='After hmmufotu' )
CD <- plotCooksd( fastp.before, asn.summary[,2] )
print( 'Outliers against fastp.before' )
cbind( fastp.before[CD], asn.summary[CD,2] )
plot( fastp.after, asn.summary[,2], ylab='After hmmufotu' )
CD <- plotCooksd( fastp.after, asn.summary[,2] )
print( 'Outliers against fastp.after' )
cbind( fastp.after[CD], asn.summary[CD,2] )
dev.off()
Ratio <- (asn.summary[,2] - fastp.after)/fastp.after
names(Ratio) <- names(fastp.after)
head( sort(Ratio) )
q()
