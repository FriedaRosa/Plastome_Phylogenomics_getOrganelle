#!/bin/bash

# run a species tree on the concatenated plastome alignment

# run locally - takes < 1h

source activate iqtree

aln=data/plastome_seq/plastome.fasta.concat
# 1000 ultrafast bootstraps
iqtree -s $aln -m GTR+G -T 4 -B 1000 --redo

conda deactivate