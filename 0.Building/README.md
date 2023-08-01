# Building HmmUFOtu Reference HMM database
The pre-built HMM databases distributed by the HmmUFOtu authors are based on GreenGene reference sequences that have not been update since *. 
We downloaded one of the databases, gg_97_otus_GTR, recommended by the original authurs. We added RDP Version 18 reference sequences to this database sequences and rebuilt the database.

## hmmufotu-inspect.bash
From the downloaded pre-built HmmUFOtu database, extract several text files.
- input: gg_97_otus_GTR (inclusives of '.msa', '.hmm', '.ptu', '.csfm')
- output1: gg_97_otus_GTR.tree
- output2: gg_97_otus_GTR.anno
- output3: gg_97_otus_GTR.seq

## read.tree in the R ape package
Read in the phylogenetic tree using read.tree function of R ape package and save the lists of tips and internal nodes separately.
- input: gg_97_otus_GTR.tree
- output1: gg_97_otus_GTR.tips
- output2: gg_97_otus_GTR.nodes

## splitFasta.R
HmmUFOtu reference tree includes both tips and internal nodes. The corresponding fasta file contains both groups. For rebuilding the tree, we need only the tip sequences.
This is accomplished with Biostrings in Bioconductor.
- input1: gg_97_otus_GTR.tips
- input2: gg_97_otus_GTR.nodes
- input3: gg_97_otus_GTR.seq
- output1: gg_97_otus_GTR.tips.seq
- output2: gg_97_otus_GTR.nodes.seq

## cmbuilding.bash
Here we use cmbuild program in Infernal package to build consensus model from the multiple alignment of gg_97_otus saved in the Stockholm format.
- input: gg_97_otus_GTR.tips.stk
- output: gg_97_otus_GTR_tips.cm

## cmaligning.bash
Against the consensus model created above, the RDP18 sequences are aligned using cmalign.
- input1: gg_97_otus_GTR.tips.stk
- input2: gg_97_otus_GTR_tips.cm
- input3: RDP18.fa
- output1: gg_97_otus_GTR.RDP18.stk
- output2: gg_97_otus_GTR.RDP18.score

## hmmufotu-build.bash
Based on the multiply aligned sequences, hmmufotu database is built.
- input1: gg_97_otus_GTR.RDP18.adjusted.fasta
- input2: gg_97_otus_GTR.RDP18.adjusted.fast.zeroRM.simple.tree
- input3: ggRDP18.anno
- output1: ggRDP18_GTR.msa
- output2: ggRDP18_GTR.hmm
- output3: ggRDP18_GTR.ptu
- output4: ggRDP18_GTR.csfm
