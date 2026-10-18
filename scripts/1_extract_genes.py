#!/usr/bin/env python3
import argparse
from Bio import SeqIO
from Bio.SeqRecord import SeqRecord

p = argparse.ArgumentParser(description="Extract CDS/tRNA/rRNA from GenBank")
p.add_argument("-i","--infile", default="data/Bischofia_MZ826267.gb")
p.add_argument("-o","--outfile", default="data/genes.fasta")
args = p.parse_args()

recs = list(SeqIO.parse(args.infile, "genbank"))
if not recs:
    raise SystemExit("No records found")
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
        out.append(SeqRecord(seq, id=header, description=""))
SeqIO.write(out, args.outfile, "fasta")




