#!/bin/bash


conda activate plastomes
# run locally
# align plastome sequences by gene

alndir=data/plastome_seq

# for each gene...

for f in $alndir/*.fasta; do
  mafft --thread 4 $f > $f.mafft
done


conda deactivate