#!/bin/bash
# concatenate trimmed alignments

alndir=data/plastome_seq

source /home/frieda/miniconda3/etc/profile.d/conda.sh
conda activate plastomes

AMAS.py concat -f fasta -d dna -i $alndir/*.fasta.mafft.trm \
  -t $alndir/plastome.fasta.concat

conda deactivate