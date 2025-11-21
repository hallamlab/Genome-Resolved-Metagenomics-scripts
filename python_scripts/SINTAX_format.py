#!/usr/bin/env python3
"""
Convert semicolon-delimited taxonomy FASTA headers into SINTAX format.

Input header example:
>AY846379.1.1791 Eukaryota;Archaeplastida;Chloroplastida;Chlorophyta;Chlorophyceae;Sphaeropleales;Monoraphidium;Monoraphidium sp.

Output header example (SINTAX):
>AY846379.1.1791;tax=d:Eukaryota,p:Archaeplastida,c:Chloroplastida,o:Chlorophyta,f:Chlorophyceae,g:Sphaeropleales,s:Monoraphidium_sp
"""

import sys

if len(sys.argv) != 3:
    print(f"Usage: {sys.argv[0]} input.fasta output_sintax.fasta")
    sys.exit(1)

input_fasta = sys.argv[1]
output_fasta = sys.argv[2]

rank_labels = ["d", "p", "c", "o", "f", "g", "s"]

with open(input_fasta) as infile, open(output_fasta, "w") as outfile:
    for line in infile:
        line = line.strip()
        if line.startswith(">"):
            # Split the header into ID and taxonomy
            try:
                seq_id, tax_str = line.split(None, 1)
            except ValueError:
                # No taxonomy, just write as-is
                outfile.write(f"{line}\n")
                continue

            taxa = tax_str.split(";")
            sintax_taxa = []
            for i, t in enumerate(taxa):
                if i >= len(rank_labels):
                    break
                t_clean = t.strip().replace(" ", "_")
                sintax_taxa.append(f"{rank_labels[i]}:{t_clean}")

            sintax_header = seq_id + ";tax=" + ",".join(sintax_taxa) + ";"
            outfile.write(f"{sintax_header}\n")
        else:
            outfile.write(line + "\n")
