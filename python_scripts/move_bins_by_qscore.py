import pandas as pd
import os
import shutil
import sys

tsv_file = "/home/jcsm2010/scratch/jcsm2010/AG_AD_metaG_analysis/Genome_QC_hybrid_read/Master_genome_QC_with_Sequencing_platform.tsv"         # Master tsv file
qscore_threshold = 50                         # Minimum acceptable Q-score
bin_dir = "/home/jcsm2010/scratch/jcsm2010/AG_AD_metaG_analysis/hybrid_read_bins/bins/renamed_bins"                  # Directory with all bins
output_dir = "/home/jcsm2010/scratch/jcsm2010/AG_AD_metaG_analysis/hybrid_read_bins/HQMQ_bins"      # Where to move filtered bins
bin_column = "Bin Id"                         # Column name with bin filenames
qscore_column = "qscore"                      # Column name with Q-score
bin_extensions = [".fa", ".fna", ".fasta", ".fa.gz", ".fna.gz"]  # possible extensions


os.makedirs(output_dir, exist_ok=True)

# Load table
df = pd.read_csv(tsv_file, sep="\t")

# Filter by Q-score
filtered_df = df[df[qscore_column] >= qscore_threshold]

# Move each valid bin file
for bin_id in filtered_df[bin_column]:
    found = False
    for ext in bin_extensions:
        src = os.path.join(bin_dir, f"{bin_id}{ext}")
        if os.path.exists(src):
            shutil.move(src, os.path.join(output_dir, os.path.basename(src)))
            print(f"Moved: {src}")
            found = True
            break
    if not found:
        print(f"⚠️ Bin not found for ID: {bin_id}")

print("✅ Done moving bins.")