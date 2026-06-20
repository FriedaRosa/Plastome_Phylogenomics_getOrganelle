# Download Bischofia chloroplast genome from GenBank
curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=MZ826267.1&rettype=gbwithparts&retmode=text" -o data/Bischofia_MZ826267.gb

# Run gene extraction from Bischofia chloroplast genome
python scripts\\1_extract_genes.py -i data\\Bischofia_MZ826267.gb -o data\\genes.fasta





mkdir -p data/genes

conda activate plastomes


# Alternatively use SRA-tools (fastq-dump):
fastq-dump --origfmt --split-files --gzip SRR26662821 -O data/




# Create symlinks from trimmed raw reads to this folder:
src="$HOME/HybSeq_pipeline_2026/data/output/NGS_dataset/03-My_clean_data/"
dst="$HOME/Plastome_Phylogenomisc_2026/data/trimmed_reads"
mkdir -p "$dst"

for f in "$src"/*.fq.gz; do
    ln -s "$f" "$dst/$(basename "$f")"
done