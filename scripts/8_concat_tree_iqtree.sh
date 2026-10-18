#!/bin/bash

# run a species tree on the concatenated plastome alignment

# run locally - takes < 1h
source /home/frieda/miniconda3/etc/profile.d/conda.sh
conda activate iqtree

aln=data/plastome_seq/plastome.fasta.concat
# 1000 ultrafast bootstraps
iqtree \
-s $aln \
-m MFP \
-mtree \
-T 4 \
-B 1000 \
--redo

conda deactivate