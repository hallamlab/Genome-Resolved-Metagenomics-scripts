#!/bin/bash

# Set the parent directory where sample directories are located
PARENT_DIR="/home/jcsm2010/scratch/jcsm2010/AG_AD_metaG_analysis/remaining_binning/greedy_output"

# Loop through each sample directory
for SAMPLE_DIR in "$PARENT_DIR"/*; do
    # Extract the sample directory name
    SAMPLE_NAME=$(basename "$SAMPLE_DIR")
    
    # Check if the sample directory exists
    if [ -d "$SAMPLE_DIR" ]; then
        # Loop through each contig file in the parent directory
        for BIN_FILE in "$SAMPLE_DIR"/bins/*.fna.gz; do
            # Extract the contig filename
            BIN_NAME=$(basename "$BIN_FILE")
            
            # Construct the new filename
            NEW_NAME="operams_${SAMPLE_NAME}_${BIN_NAME}"
            
            # Rename the file
            mv "$BIN_FILE" "$SAMPLE_DIR/bins/$NEW_NAME"
        done
    fi
done