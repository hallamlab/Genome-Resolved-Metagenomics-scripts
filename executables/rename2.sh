#!/bin/bash

# Change to the directory where the files are located
cd /home/jcsm2010/scratch/jcsm2010/AG_AD_metaG_analysis/Pac_Bio_reads || exit

# Loop through nanocorrect files ending with correctedReads.fasta.gz
for file in *.corrected.fastq; do

    sample="${file%.corrected.fastq}"

    # Create new filename
    new_name="${sample}.clean.fastq"

    # Rename the file
    mv "$file" "$new_name"

    echo "Renamed: $file -> $new_name"
done