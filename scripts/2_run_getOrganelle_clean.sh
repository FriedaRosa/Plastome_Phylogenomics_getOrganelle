#!/usr/bin/env bash
set -euo pipefail

conda activate plastomes

reads_dir="data/trimmed_reads"
output_dir="data/getorganelle_output"
seed_file="data/genes.fasta"

mkdir -p "$output_dir"

# make a file list for all samples from the reads directory and assing them $forward and $reverse variables and paired and unpaired variables.
# the ending for all reads is .fq.gz and the naming convention is taxon_1_clean.paired.fq.gz for paired reads and taxon_1_clean.unpaired.fq.gz for unpaired reads. The same applies for the reverse reads with _2_ instead of _1_.
# the script should be able to handle multiple samples and multiple files for each sample.

for sample in $(ls "$reads_dir"/*_1_clean.paired.fq.gz | sed 's/_1_clean.paired.fq.gz//'); do
  sample_name=$(basename "$sample" | sed 's/_1_clean.paired.fq.gz//')
  forward_paired="$reads_dir/${sample_name}_1_clean.paired.fq.gz"
  reverse_paired="$reads_dir/${sample_name}_2_clean.paired.fq.gz"
  forward_unpaired="$reads_dir/${sample_name}_1_clean.unpaired.fq.gz"
  reverse_unpaired="$reads_dir/${sample_name}_2_clean.unpaired.fq.gz"

  get_organelle_from_reads.py \
  -1 "$forward_paired" \
  -2 "$reverse_paired" \
  -u "$forward_unpaired","$reverse_unpaired" \
  -o "$output_dir/$sample_name" \
  -s "$seed_file" \
  -k 21,45,65,85,105 \
  -R 15 \
  --max-reads 1.5E7 \
  --overwrite \
  -F embplant_pt \
  -t 8

done


conda deactivate plastomes