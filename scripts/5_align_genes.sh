#!/bin/bash

source /home/frieda/miniconda3/etc/profile.d/conda.sh
conda activate plastomes
# run locally
# align plastome sequences by gene

alndir=data/plastome_seq

# check if output (files ending in .mafft) already exist, else run loop

if ls $alndir/*.mafft 1> /dev/null 2>&1; then
  echo "MAFFT output files already exist. Skipping alignment step."
else
  echo "MAFFT output files do not exist. Running alignment step."
  # Align each gene.
  for f in "$alndir"/*.fasta; do
    mafft \
      --maxiterate 1000 \
      --genafpair \
      --thread -1 \
      "$f" > "$f.mafft"
  done
fi


conda deactivate