#!/usr/bin/env Rscript
# If "_F_filt.fq.gz" and '_R_filt.fq.gz' exists in arg1 folder, skip the filtering step and use only those existing files.
# This assumes that some files failed filtering and use only those passed the filtering.

# arg1: submitting directory
# arg2: sample, read1, read2 (mothur's file)
# arg3: trimLengthF (character, should be coerced to numeric)
# arg4: trimLengthR (character, should be coerced to numeric)
# arg5: errF (character, should be coerced to numeric)
# arg6: errR (character, should be coerced to numeric)

.libPaths("/bio/home/sskimb/R/x86_64-redhat-linux-gnu-library/3.6")

library(dada2); packageVersion("dada2")
args <- commandArgs(trailingOnly=TRUE)

fileList <- read.delim( paste0(args[1], '/', args[2], '.files'), header=F, row.names=1, as.is=TRUE )
fnFs <- paste( args[1], fileList[,1], sep='/' )
fnRs <- paste( args[1], fileList[,2], sep='/' )
head( fnFs )
head( fnRs )

sample.names <- rownames(fileList)
filtFs <- paste0(sample.names, '_F_filt.fq.gz')
filtRs <- paste0(sample.names, '_R_filt.fq.gz')
names(filtFs) <- sample.names
names(filtRs) <- sample.names

out <- filterAndTrim( fnFs, filtFs, fnRs, filtRs, 
      truncLen=as.numeric(args[3:4]), maxN=0, maxEE=as.numeric(args[5:6]), truncQ=2, rm.phix=TRUE,
      compress=TRUE, multithread=TRUE) # On Windows set multithread=FALSE
dim(out)
head(out)
filtFs.exists <- file.exists( filtFs )
filtRs.exists <- file.exists( filtRs )
if( filtFs.exists %*% filtRs.exists < length( filtFs) ) {
	print( 'Some samples failed filtering. Use only passed samples' )
	print( paste( 'Forward', sum(filtFs.exists), 'and reverse', sum(filtRs.exists), 'files to be used' ) )
	filtFs <- filtFs[ filtFs.exists ]
	filtRs <- filtRs[ filtRs.exists ]
	sample.names <- sample.names[ filtFs.exists ]
	out <- out[ filtFs.exists, ]
}

errF <- learnErrors(filtFs, multithread=TRUE)
errR <- learnErrors(filtRs, multithread=TRUE)
pdf( paste0( args[2], '.errorProfile.pdf' ) )
plotErrors(errF, nominalQ=TRUE)
plotErrors(errR, nominalQ=TRUE)
dev.off()

dadaFs <- dada(filtFs, err=errF, multithread=TRUE)
dadaRs <- dada(filtRs, err=errR, multithread=TRUE)
dadaFs[[1]]
dadaRs[[1]]

mergers <- mergePairs(dadaFs, filtFs, dadaRs, filtRs, verbose=TRUE)
# Inspect the merger data.frame from the first sample
head(mergers[[1]])

seqtab <- makeSequenceTable(mergers)
dim(seqtab)

# Inspect distribution of sequence lengths
table(nchar(getSequences(seqtab)))

seqtab.nochim <- removeBimeraDenovo(seqtab, method="consensus", multithread=TRUE, verbose=TRUE)
dim(seqtab.nochim)

sum(seqtab.nochim)/sum(seqtab)

getN <- function(x) sum(getUniques(x))
track <- cbind(out, sapply(dadaFs, getN), sapply(dadaRs, getN), sapply(mergers, getN), rowSums(seqtab.nochim))
# If processing a single sample, remove the sapply calls: e.g. replace sapply(dadaFs, getN) with getN(dadaFs)
colnames(track) <- c("input", "filtered", "denoisedF", "denoisedR", "merged", "nonchim")
rownames(track) <- sample.names
track
save(seqtab, seqtab.nochim, track, file='seqtab.RData')
q()
