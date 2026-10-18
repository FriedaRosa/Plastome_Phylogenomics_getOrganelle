#!/bin/bash
# trim alignments
source /home/frieda/miniconda3/etc/profile.d/conda.sh
conda activate trimal

for aln in data/plastome_seq/*fasta.mafft
do
  # output file name
  outf=$(echo $aln | sed 's/\.mafft/\.mafft\.trm/')
  # run trimAl - base settings, using a heuristic to determine removal scores
  trimal -in $aln -out $outf -automated1 -keepheader
done

conda deactivate
