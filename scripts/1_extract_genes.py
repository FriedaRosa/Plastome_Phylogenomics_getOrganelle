#!/usr/bin/env python3

import argparse
from Bio import SeqIO
from Bio.SeqRecord import SeqRecord

# Parse command-line arguments
p = argparse.ArgumentParser(description="Extract CDS/tRNA/rRNA from GenBank")
p.add_argument("-i","--infile", default="data/Bischofia_MZ826267.gb")
p.add_argument("-o","--outfile", default="data/genes.fasta")
args = p.parse_args()

# Read GenBank file and extract features
recs = list(SeqIO.parse(args.infile, "genbank"))

# Check if any records were found
if not recs:
    raise SystemExit("No records found")

# Extract features of interest (CDS, tRNA, rRNA, gene) as nucleotide sequences and write to output FASTA file
rec = recs[0]
out = []
for f in rec.features:
    if f.type in ("CDS","tRNA","rRNA","gene"):
        try:
            seq = f.extract(rec.seq)
        except Exception:
            continue
        gene = f.qualifiers.get("gene", ["NA"])[0]
        locus = f.qualifiers.get("locus_tag", ["NA"])[0]
        prod = f.qualifiers.get("product", ["NA"])[0]
        name = gene if gene!="NA" else locus
        header = f"{name}|{f.type}|{locus}|{prod}"
        out.append(SeqRecord(seq, id=header, description="")) # 
# Write the extracted features to the output FASTA file (genes.fasta)
SeqIO.write(out, args.outfile, "fasta")




