#!/bin/bash

# Set the parent directory where sample directories are located
PARENT_DIR="/home/jcsm2010/scratch/jcsm2010/AG_AD_metaG_analysis/remaining_binning/greedy_output"

# Set the destination directory where bin files will be moved
DEST_DIR="/home/jcsm2010/scratch/jcsm2010/AG_AD_metaG_analysis/hybrid_bins_compiled"

# Ensure the destination directory exists
mkdir -p "$DEST_DIR"

# Loop through each sample directory
for SAMPLE_DIR in "$PARENT_DIR"/*; do

    
    # Check if the bins directory exists
    if [ -d "$SAMPLE_DIR" ]; then
        # Move all bin files to the destination directory
        mv "$SAMPLE_DIR"/bins/* "$DEST_DIR"/
    fi
done

# Base directory containing all sample folders
#BASE_DIR="/home/jcsm2010/scratch/jcsm2010/outputs_sakinaw/assemblies_stats/megahit_stats"

# Loop through all subdirectories of megahit_stats
#for SAMPLE_DIR in "$BASE_DIR"/*/; do
 #   QUAST_DIR="${SAMPLE_DIR}QUAST_out/"

    # Check if QUAST_out directory exists
  #  if [ -d "$QUAST_DIR" ]; then
   #     echo "Moving files from $QUAST_DIR to $SAMPLE_DIR"
        # Move all files (but not subdirectories)
    #    find "$QUAST_DIR" -maxdepth 1 -type f -exec mv {} "$SAMPLE_DIR" \;
    #else
     #   echo "No QUAST_out directory in $SAMPLE_DIR, skipping."
    #fi
#done