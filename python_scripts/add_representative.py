import os
import pandas as pd

# Path to dereplicated genomes
derep_dir = "/home/jcsm2010/scratch/jcsm2010/AG_AD_metaG_analysis/hybrid_read_bins/derep_bins/Dereplicated_Representative_Genomes"

# Load the existing QC table
qc_file = "/home/jcsm2010/scratch/jcsm2010/AG_AD_metaG_analysis/Genome_QC_hybrid_read/Master_genome_QC_with_Sequencing_platform.tsv"
df = pd.read_csv(qc_file, sep="\t")

# Get set of filenames (without .fasta extension) from dereplicated genomes folder
derep_genomes = {
    os.path.splitext(f)[0]
    for f in os.listdir(derep_dir)
    if f.endswith(".fasta")
}

# Add TRUE/FALSE to indicate if each Genome_Id is in the dereplicated set
if "Bin Id" in df.columns:
    df["is_representative"] = df["Bin Id"].apply(lambda x: x in derep_genomes)
else:
    raise ValueError("The QC file must have a 'Genome_Id' column.")

# Save updated file
df.to_csv("Master_genome_QC_with_representative.tsv", sep="\t", index=False)

print("Updated file saved as 'Master_genome_QC_with_representative.tsv'")
