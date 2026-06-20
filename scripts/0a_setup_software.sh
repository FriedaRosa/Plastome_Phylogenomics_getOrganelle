#!/bin/bash
conda create -n plastomes python=3.10 -y
conda activate plastomes
pip install biopython
conda install bioconda::sra-tools
conda install -c bioconda getorganelle
conda install bioconda::mafft
conda install -y blast
conda install bioconda::amas
# download and initialize database of organelle genome type
get_organelle_config.py --add embplant_pt,embplant_mt
conda deactivate