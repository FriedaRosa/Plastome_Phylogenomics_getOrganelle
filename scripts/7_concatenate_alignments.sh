#!/bin/bash
# concatenate trimmed alignments

alndir=data/plastome_seq

conda activate plastomes

AMAS.py concat -f fasta -d dna -i $alndir/*.fasta.mafft.trm \
  -t $alndir/plastome.fasta.concat

conda deactivate