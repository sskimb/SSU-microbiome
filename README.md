# SSU-microbiome
## A Streamlined Pipeline based on HmmUFOtu for Microbial Community Profiling Using 16S rRNA Amplicon Sequencing

Microbial community profiling using 16S rRNA amplicon sequencing allows for taxonomic characterization of diverse microorganisms. We present a streamlined pipeline that integrates [FastP](https://github.com/OpenGene/fastp) for read trimming, [HmmUFOtu](https://github.com/Grice-Lab/HmmUFOtu) for OTU clustering, [Vsearch](https://mothur.org/wiki/chimera.vsearch/) for chimera checking, and [Kraken2](https://ccb.jhu.edu/software/kraken2/) for taxonomic assignment.

The pipeline proposed in this study is outlined in the following figure:
![Overview](https://github.com/sskimb/SSU-microbiome/assets/12622306/a04892a1-f9d1-44b1-aab3-4b64a2af123d)
*where the objects filled by light blue represent the pipeline that includes HmmUFOtu clustering as proposed in this work. The objects filled by apricot represent the steps taken with DADA2 for benchmark comparison. The yellow objects represent the input and output items as well as common analyses steps.*

The input consists of quality trimmed paired-end fastq files, which are then subjected to phylogenetic OTU clustering using HmmUFOtu (for details, [see 1.Mapping](1.Mapping)). The process utilizes a hidden Markov model (HMM) that represents the multiple alignment of the reference sequences, as well as a phylogenetic tree of these sequences. There are various pre-built HMM databases provided at the [HmmUFOtu website](https://www.med.upenn.edu/gricelab/hmmufotu.html#databases). They are based on old GreenGene Reference sequences, and no updated versions are available. We downloaded the recommended database and augmented it with RDP18 reference sequences (for details, [see 0.Building](0.Building)).

From the HmmUFOtu clustering result, consensus sequences are generated for each cluster using the Biostrings package in Bioconductor (for details, [see 2.Consensus](2.Consensus)). These consensus sequences undergo a screening step to detect chimeric combinations, which is performed using the de novo chimera checking algorithm in Mothur (for details, [see 3.Chimera](3.Chimera)). The taxonomic annotations of the non-chimeric clusters are obtained using Kraken2 (for details, [see 4.Taxonomy](4.Taxonomy)). 

Next, clusters assigned to the same taxonomic groups are merged to form phylotypes using a custom R script. Phylotypes represent higher-level taxonomic units that encompass multiple closely related clusters. This merging step helps to reduce the complexity of the data and provides a more consolidated view of the microbial community composition. Once the resulting phylotype abundance table is prepared, downstream statistical analyses can be performed using Mothur, a versatile software package that offers  a range of statistical tools for analyzing microbial community data (for details, [see 5.Analysis](5.Analysis)). 

For benchmarking processes, the same paired-end fastq files are processed using the DADA2 protocol, available as a Bioconductor package (for details, [see DADA2](DADA2)). The output from DADA2, consisting of Amplicon Sequence Variants (ASVs), is also taxonomically annotated using Kraken2 and merged into phylotypes as described above.


