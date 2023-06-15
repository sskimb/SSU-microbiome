# SSU-microbiome
## A Streamlined Pipeline based on HmmUFOtu for Microbial Community Profiling Using 16S rRNA Amplicon Sequencing

Microbial community profiling using 16S rRNA amplicon sequencing allows for taxonomic characterization of diverse microorganisms. We present a streamlined pipeline that integrates FastP for read trimming, HmmUFOtu for OTU clustering, Vsearch for chimera checking, and Kraken2 for taxonomic assignment.

The pipeline proposed in this study is outlined in Figure 1. The input consists of quality trimmed paired-end fastq files, which are then subjected to phylogenetic OTU clustering using HmmUFOtu. The process utilizes a hidden Markov model (HMM) that represents the multiple alignment of the reference sequences, as well as a phylogenetic tree of these sequences. 

From the HmmUFOtu clustering result, consensus sequences are generated for each cluster using the Biostrings package in Bioconductor. These consensus sequences undergo a screening step to detect chimeric combinations, which is performed using the de novo chimera checking algorithm in Mothur. The taxonomic annotations of the non-chimeric clusters are obtained using Kraken2. 

Next, clusters assigned to the same taxonomic groups are merged to form phylotypes using a custom R script. Phylotypes represent higher-level taxonomic units that encompass multiple closely related clusters. This merging step helps to reduce the complexity of the data and provides a more consolidated view of the microbial community composition. Once the resulting phylotype abundance table is prepared, downstream statistical analyses can be performed using Mothur, a versatile software package that offers  a range of statistical tools for analyzing microbial community data. 

For benchmarking processes, the same paired-end fastq files are processed using the DADA2 protocol, available as a Bioconductor package. The output from DADA2, consisting of Amplicon Sequence Variants (ASVs), is also taxonomically annotated using Kraken2 and merged into phylotypes as described above.


Figure 1. The outline of the pipeline. The objects filled by light blue represent the pipeline that includes HmmUFOtu clustering as proposed in this work. The objects filled by apricot represent the steps taken with DADA2 for benchmark comparison. The yellow objects represent the input and output items as well as common analyses steps.
