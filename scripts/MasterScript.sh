#!/usr/bin/env bash
set -euo pipefail

source /home/frieda/miniconda3/etc/profile.d/conda.sh

conda activate plastomes


echo "Running MasterScript.sh --- " 
date



# echo -n "Running 0b_setup_data.sh --- "
# date
# bash ./scripts/0b_setup_data.sh
# date


# echo -n "Running 1b_split_genes_to_fasta.py --- "
# date
# python3 ./scripts/1b_split_genes_to_fasta.py
# date


# echo -n "Running 2_run_getOrganelle_clean.sh --- "
# date
# bash ./scripts/2_run_getOrganelle_clean.sh
# date


# echo -n "Running 3_archive_plastomes.sh --- "
# date
# bash ./scripts/3_archive_plastomes.sh
# date


# echo -n "Running 4_blast_genes.R --- " 
# date
# Rscript ./scripts/4_blast_genes.R
# date

echo -n "Running 5_align_genes.sh --- "
date
bash ./scripts/5_align_genes.sh
date

echo -n "Running 6_trim_alignments.sh --- "
date
bash ./scripts/6_trim_alignments.sh
date


echo -n "Running 7_concatenate_alignments.sh --- "
date
bash ./scripts/7_concatenate_alignments.sh
date

echo -n "Running 8_concat_tree_iqtree.sh --- "
date
bash ./scripts/8_concat_tree_iqtree.sh
date

echo -n "Running 9_plot_tree.R --- "
date
Rscript ./scripts/9_plot_tree.R
date