---
title: "Methods"
order: 3
---

### Obtaining and preparing HIV gene sequences

Gene sequences came from the HIV database at Los Alamos National Laboratory ([HIV Database](http://www.hiv.lanl.gov/content/index)). We used only pre-made gene alignments. The alignments were assumed correct and therefore not changed for all of the genes in this study. To identify the genes in the whole genome sequences, we used the annotation landmarks available in the sequence database ([HIV Landmarks](http://www.hiv.lanl.gov/content/sequence/HIV/MAP/landmark.html)). With [this script](data/gp120/gp120_sequences/translate_dna_sequences.py), sequences were filtered to include only those with entirely canonical bases, and to change stop codons in the original alignment to gaps. 

### Calculating the site-wise evolutionary rate ratio

We built phylogenetic trees with FastTree 2.1.7 with the following input line.

<pre> <span style="font-family:Courier">fasttree -nt -gtr -nosupport alignment.fasta > alignment.tree</span> </pre>

In addition, we made minor changes to the FastTree source code to prevent rounding errors in the tree branch lengths (the branch length issue was detailed  [here](http://darlinglab.org/blog/2015/03/23/not-so-fast-fasttree.html)).

Given a codon alignment and evolutionary tree, we used the phylogenetic software HyPHy to calculate the evolutionary rate ratio (*dN/dS*). We used the built-in one-rate fixed effects likelihood (FEL) method with the default model. The FEL method calculates an independent *dN/dS* value at each column in the alignment. To calculate a one-rate *dN/dS* value, the model computes a single *dS/dt* value for the entire alignment and an individual *dN/dt* at each site. It then normalizes each *dN/dt* value by dividing by the average *dS/dt* to obtain *dN/dS*. 

### Obtaining and mapping protein structures

Protein structures were obtained from the RCSB Protein Databank (PDB). For each of the six proteins, we obtained both the monomeric structure and, if quaternary structure was functionally important, the full biological assembly. This study included all three of the enzymes encoded by the HIV *pol* gene: reverse transcriptase (PDBID: 1HYS), integrase (PDBID: 1EX4), and protease (PDBID: 1HPV). In addition we included the three HIV structural proteins that did not bind nucleic acid. Those included the capsid (p24, PDBID: 3H47), the matrix (p17, PDBID: 1HIW), and the major component of the HIV receptor binding protein (gp120, PDBID: 4TVP). We broadly followed the HIV structure suggestions curated by the PDB ([HIV Structures](http://www.rcsb.org/pdb/education_discussion/educational_resources/struct_bio_hiv_lores.pdf)).

To map protein structures onto the existing alignment, we used a developmental version of the sequence alignment software MAFFT. This version included the ability to add a sequence to an existing alignment while removing any sites where there was an insertion in the protein structure sequence. Therefore, we used the following input line.

<pre> <span style="font-family:Courier">mafft --mapout --addfragments aas.fasta alignment.fasta > added_alignment.fasta</span> </pre>

### Calculating structural predictors

We used two independent structural predictors from the protein structures. The first was relative solvent accessibility (RSA) which has been detailed extensively previously. We used the program DSSP to compute the absolute solvent accessibilities of each residue in the protein. Then, we used maximum absolute accessibility values for each residue to normalize solvent exposure to a value between 0 and 1. For all models in this study, we used the RSA of a chain in the functional multimeric state of the biological assembly. The second metric was distance to a reference point. To compute the set of distances, we used each C-alpha in the protein as a reference point, and calculated the distance to every other C-alpha. Thus, the distances from a single C-alpha to every other C-alpha constituted a single distance set. We repeated this calculation using every amino acid to generate a symmetric matrix of distances where the diagonal is always zero as it is simply the distance from an amino acid to itself.

### Constructing linear models and cross validation

It has been shown previously that RSA is a relatively strong structural predictor for site-wise *dN/dS* both in viruses and large enzyme datasets. Thus, we started with a linear model that predicted site-wise *dN/dS* with site-wise RSA. Then, to find the best reference point among the entire set of reference points, we constructed combined linear models with both RSA and the distance set from a single reference point. To guard against overfitting, we trained the model on a randomly chosen 75% of the data and reserved 25% for validation of the best reference point found in the training set. To be clear, all of the possible reference points were available for training, but for each training set we only used *dN/dS*, RSA, and distances for 75% of the sites. We repeated the training and validation 100 times for each protein. We found that the training and validation R<sup>2</sup> and p-value we very similar. Therefore, for each protein, we used the site that was found most frequently during training as the best site for the final prediction.
