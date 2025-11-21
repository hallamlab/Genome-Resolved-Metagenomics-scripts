import pandas as pd

# Load the existing QC table
qc_file = "/home/jcsm2010/scratch/jcsm2010/AG_AD_metaG_analysis/Genome_QC_hybrid_read/Master_genome_QC_with_binner.tsv"
sample_names_file = "/home/jcsm2010/jcsm2010/Ag_AD_metagenomics/executables/sample_names_NovaSeqX.txt"
df = pd.read_csv(qc_file, sep="\t")

# Load sample names for NovaSeq X
with open(sample_names_file, "r") as f:
    novaseqx_samples = [line.strip() for line in f if line.strip()]

# Function to determine sequencing platform
def get_sequencing_platform(genome_id):
    for sample in novaseqx_samples:
        if sample in genome_id:
            return "Illumina NovaSeq X 25B_PacBio Revio SMRT"
    return "Illumina NovaSeq 6000 S4 2500M_PacBio Revio SMRT"

# Apply only if Genome_Id exists
if "Genome_Id" in df.columns:
    df["Sequencing_platform"] = df["Genome_Id"].apply(get_sequencing_platform)
else:
    raise ValueError("The QC file must have a 'Genome_Id' column.")

# Save the updated file
output_file = "Master_genome_QC_with_Sequencing_platform.tsv"
df.to_csv(output_file, sep="\t", index=False)

print(f"Updated file saved as '{output_file}'")