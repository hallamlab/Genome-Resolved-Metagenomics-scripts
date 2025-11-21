import pandas as pd

# Load the QC table
qc_file = "/home/jcsm2010/scratch/jcsm2010/AG_AD_metaG_analysis/Genome_QC_hybrid_read/Master_genome_QC_with_assembler.tsv"
df = pd.read_csv(qc_file, sep="\t")

# Function to determine binner based on pattern
def get_binner(genome_id):
    if "Bin-" in genome_id:
        return "LRBinner"
    elif "bin" in genome_id:
        return "UniteM"
    else:
        return "Unknown"

# Apply the function
if "Genome_Id" in df.columns:
    df["binner"] = df["Genome_Id"].apply(get_binner)
else:
    raise ValueError("The QC file must have a 'Genome_Id' column.")

# Save the updated file
output_file = "Master_genome_QC_with_binner.tsv"
df.to_csv(output_file, sep="\t", index=False)

print(f"Updated file saved as '{output_file}'")
