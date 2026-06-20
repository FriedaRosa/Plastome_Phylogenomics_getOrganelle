## Split into separate files
from Bio import SeqIO

record = SeqIO.read("data/Bischofia_MZ826267.gb", "genbank")

for feature in record.features:
    if feature.type == "CDS":
        gene = feature.qualifiers.get("gene", ["unknown"])[0]
        seq = feature.extract(record.seq)

        with open(f"data/genes/{gene}.fasta", "a") as out:
            out.write(f">{record.name}\n{seq}\n")