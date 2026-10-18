#!/bin/bash

# ------------------------------ ## ------------------------------ #
#' PART 1 : Download and extract genes from Bischofia chloroplast genome AA as reference for Uapaca plastomes' # ----
# ------------------------------ ## ------------------------------ #

## This works with the genebank (.bg) file and is very fast (276 kb): 

# Check if 'Bischofia_MZ826267.gb' file exists, if not download it
if [ ! -f data/Bischofia_MZ826267.gb ]; then
    echo "Downloading Bischofia chloroplast genome from GenBank..."
    curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=MZ826267.1&rettype=gbwithparts&retmode=text" -o data/Bischofia_MZ826267.gb
else
    echo "Bischofia chloroplast genome already exists. Skipping download."
fi

# Run gene extraction from Bischofia chloroplast genome metadata file (GenBank format) to extract coding sequences (CDS) and save them in FASTA format.
# (arguments are also specified in the 1_extract_genes.py script)
python scripts/1_extract_genes.py \
    -i data/Bischofia_MZ826267.gb \
    -o data/genes.fasta


mkdir -p data/genes

# ------------------------------ ## ------------------------------ #
#' PART 2 : Create symlinks for the trimmed reads from HybSeq_pipeline_2026 # ----
# ------------------------------ ## ------------------------------ #

# check if trimmed_reads directory exists, if not create symlinks:

if [ -d "data/trimmed_reads" ]; then
    echo "Directory 'data/trimmed_reads' already exists. Skipping symlink creation."
else
    echo "Creating symlinks for trimmed reads..."
    # Create symlinks from trimmed raw reads to this folder:
    src="$HOME/HybSeq_pipeline_2026/data/output/NGS_dataset/03-My_clean_data/"
    dst="$HOME/Plastome_Phylogenomisc_2026/data/trimmed_reads"

    # Create the destination directory if it doesn't exist
    mkdir -p "$dst"

    # Create symlinks for all .fq.gz files in the source directory
    for f in "$src"/*.fq.gz; do
        ln -s "$f" "$dst/$(basename "$f")"
    done
fi


