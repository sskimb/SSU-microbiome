# Building HmmUFOtu Reference HMM database
The pre-built HMM databases distributed by the HmmUFOtu authors are based on GreenGene reference sequences ([version 13_5](https://greengenes.secondgenome.com/?prefix=downloads/greengenes_database/gg_13_5/)). 
We downloaded one of the databases, [gg_97_otus_GTR](https://upenn.box.com/shared/static/o146rpg53ebmn3pxikf7zm1uwatez6sl.zip), recommended by the original authurs. We added 21,195 RDP Version 18 training set sequences to this database sequences and rebuilt the database. The RDP sequence file, *trainset18_062020.fa*, was extracted from the [zip file](https://sourceforge.net/projects/rdp-classifier/files/RDP_Classifier_TrainingData/RDPClassifier_16S_trainsetNo18_rawtrainingdata.zip/download).

## hmmufotu-inspect.bash
From the downloaded pre-built HmmUFOtu database, extract several text files using *hmmufotu-inspect*.
- input: gg_97_otus_GTR (inclusives of '.msa', '.hmm', '.ptu', '.csfm')
- output1: gg_97_otus_GTR.tree
- output2: gg_97_otus_GTR.anno
- output3: gg_97_otus_GTR.seq (in aligned fasta format)

## read.tree in the R ape package
Read in the phylogenetic tree using *read.tree* function of R ape package and save the lists of tips and internal nodes separately.
- input: gg_97_otus_GTR.tree
- output1: gg_97_otus_GTR.tips
- output2: gg_97_otus_GTR.nodes

## splitFasta.R
HmmUFOtu reference tree includes both tips and internal nodes. The corresponding fasta file contains both groups. For rebuilding the tree, we need only the tip sequences. This is accomplished with *Biostrings* in Bioconductor.
- input1: gg_97_otus_GTR.tips
- input2: gg_97_otus_GTR.nodes
- input3: gg_97_otus_GTR.seq
- output1: gg_97_otus_GTR.tips.seq
- output2: gg_97_otus_GTR.nodes.seq

## cmbuilding.bash
Here we use *cmbuild* program in the [Infernal package](http://eddylab.org/infernal/) (version 1.1.4) to build covariance model from the multiple alignment of gg_97_otus saved in aligned fasta format, which can be converted to Stockholm format using *esl-reformat* from the [Easel package](https://github.com/EddyRivasLab/easel).
- input: gg_97_otus_GTR.tips.stk
- output: gg_97_otus_GTR_tips.cm

## cmaligning.bash
Against the covariance model created above, the RDP18 sequences are aligned using *cmalign*. The output is in Stockholm format, which can be converted to aligned fasta format using *esl-reformat* from the [Easel package](https://github.com/EddyRivasLab/easel).
- input1: gg_97_otus_GTR.tips.stk
- input2: gg_97_otus_GTR_tips.cm
- input3: RDP18.fa (*trainset18_062020.fa* from the RDP 18 traininset)
- output1: gg_97_otus_GTR.RDP18.stk
- output2: gg_97_otus_GTR.RDP18.score

## adjustMSA.R
The MSA created above requires some adjustments, which can be done with *adjustMSA* fucntion in DECIPHER Bioconductor package.
- input: gg_97_otus_GTR.RDP18.fasta
- output: gg_97_otus_GTR.RDP18.adjusted.fasta

## FastTree.bash
Create a phylogenetic tree based on generalized time-reversal model using [FastTreeMP](http://www.microbesonline.org/fasttree/) (version 2.1.11 SSE3 OpenMP).
- input: gg_97_otus_GTR.RDP18.adjusted.fasta
- output: gg_97_otus_GTR.RDP18.adjusted.fast.tree

## zeroEdgeLength.R
There are some identical sequences between GreenGene and RDP, causing 0 edge length. In such cases, we keep one of them using a locally developed R script.
- input: gg_97_otus_GTR.RDP18.adjusted.fast.tree
- output: gg_97_otus_GTR.RDP18.adjusted.fast.zeroRM.simple.tree
## hmmufotu-build.bash
Based on the multiply aligned sequences, hmmufotu database is built using *hmmufotu-build*. From this database, the fasta-formatted MSA can be extracted using *hmmufotu-inspect*.
- input1: gg_97_otus_GTR.RDP18.adjusted.fasta
- input2: gg_97_otus_GTR.RDP18.adjusted.fast.zeroRM.simple.tree
- input3: ggRDP18.anno
- output1: ggRDP18_GTR.msa
- output2: ggRDP18_GTR.hmm
- output3: ggRDP18_GTR.ptu
- output4: ggRDP18_GTR.csfm
