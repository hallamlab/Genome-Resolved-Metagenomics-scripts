import pandas as pd

# Load the existing QC table
qc_file = "/home/jcsm2010/scratch/jcsm2010/AG_AD_metaG_analysis/Genome_QC_hybrid_read/Master_genome_QC.tsv"
df = pd.read_csv(qc_file, sep="\t")

 #Function to determine binner from Genome_Id
def get_binner(genome_id):
    if genome_id.startswith("spades_hybrid"):
        return "spades_hybrid"
    elif genome_id.startswith("hybrid_spades"):
        return "spades_hybrid"
    elif genome_id.startswith("operams"):
        return "operams"
    else:
       return "Unknown"

# Apply the function to create the binner column
if "Genome_Id" in df.columns:
    df["assembler"] = df["Genome_Id"].apply(get_binner)
else:
    raise ValueError("The QC file must have a 'Genome_Id' column.")

# Save the updated file
df.to_csv("Master_genome_QC_with_assembler.tsv", sep="\t", index=False)

print("Updated file saved as 'Master_genome_QC_with_assembler.tsv'")
