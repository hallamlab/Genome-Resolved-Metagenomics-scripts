import os

def rename_bin_files(base_dir, assembler_name="hybrid_spades"):
    for sample_folder in os.listdir(base_dir):
        sample_path = os.path.join(base_dir, sample_folder)
        bins_path = os.path.join(sample_path, "binned_contigs")
        
        if os.path.isdir(bins_path):
            for filename in os.listdir(bins_path):
                if filename.startswith("Bin-") and filename.endswith(".fasta"):
                    bin_number = filename.replace("Bin-", "").replace(".fasta", "")
                    new_filename = f"{assembler_name}_{sample_folder}_Bin-{bin_number}.fasta"
                    
                    old_path = os.path.join(bins_path, filename)
                    new_path = os.path.join(bins_path, new_filename)
                    
                    os.rename(old_path, new_path)
                    print(f"Renamed: {filename} → {new_filename}")

# Set your base directory
bin_directory = "/home/jcsm2010/scratch/jcsm2010/AG_AD_metaG_analysis/bins_spades_hybrid/bins_LRbinner"
rename_bin_files(bin_directory)