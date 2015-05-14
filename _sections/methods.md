---
title: "Methods"
order: 3
---

### Obtaining and preparing HIV gene sequences

Gene sequences came from the HIV database at Los Alamos National Laboratory ([HIV Database](http://www.hiv.lanl.gov/content/index)). We used only pre-made gene alignments. The alignments were assumed correct and therefore not changed for all of the genes in this study. To identify the genes in the whole genome sequences, we used the annotation landmarks available in the sequence database ([HIV Landmarks](http://www.hiv.lanl.gov/content/sequence/HIV/MAP/landmark.html)). The sequences were filtered to only include those with entirely canonical bases. 

### Obtaining and mapping protein structures

Protein structures were obtained from the RCSB Protein Databank (PDB). For each of the six proteins, we obtained both the monomeric structure and, if quaternary structure was functionally important, the full biological assembly. This study included all three of the enzymes encoded by the HIV *pol* gene: reverse transcriptase (PDBID: 1HYS), integrase (PDBID: 1EX4), and protease (PDBID: 1HPV). In addition we included the three HIV structural proteins that did not bind nucleic acid. Those included the capsid (p24, PDBID: 3H47), the matrix (p17, PDBID: 1HIW), and the major component of the HIV receptor binding protein (gp120, PDBID: 4TVP). We broadly followed the HIV structure suggestions curated by the PDB ([HIV Structures](http://www.rcsb.org/pdb/education_discussion/educational_resources/struct_bio_hiv_lores.pdf)).

To map the protein structures onto the existing alignment, we used a developmental version of the sequence alignment software MAFFT. This version included the ability to add a sequence to an existing alignment while removing any sites where there was an insertion in the protein structure sequence. Therefore, we used the following input line.

<pre> <span style="font-family:Georgia">mafft --mapout --addfragments aas.fasta alignment.fasta > added_alignment.fasta</span> </pre>

### Calculating evolutionary rates

### Building models and mapping back to the protein structures