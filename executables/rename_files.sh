#!/bin/bash

# Navigate to the directory containing the files
cd /home/jcsm2010/jcsm2010/Raw_sequences_2020

# Loop through all the files with the pattern S###_R#.fastq
for file in S*_R*.fastq; do
  # Extract the numeric part after 'S' (e.g., '001' from 'S001')
  number=$(echo "$file" | sed -E 's/^S([0-9]{3}).*/\1/')

    # Extract the R1 or R2 part of the filename
  read_type=$(echo "$file" | grep -o '_R[12]')

  # Construct the new filename with the desired prefix 'S00CJ-0'
   new_name="P00EY-${number}${read_type}.fastq"

  # Rename the file
  mv "$file" "$new_name"
done