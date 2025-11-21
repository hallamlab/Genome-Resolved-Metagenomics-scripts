#!/bin/bash
#SBATCH --time=1:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=64GB
#SBATCH --job-name=track_reads_PB
#SBATCH --account=st-shallam-1
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=jcsm2010@mail.ubc.ca
#SBATCH --output=log_track_reads_PB_%A_%a.txt
#SBATCH --error=error_track_reads_PB_%A_%a.txt


project_path="/home/jcsm2010/scratch/jcsm2010/PacBio_Mycopots/GMCF_2763/demux_fastq/fastq_16S_PacBio"
reads_path="${project_path}/raw_reads"
out="${project_path}/read_tracking.tsv"
echo -e "Step\tReads" > "$out"


# 1. Raw input reads (all *.fastq.gz combined)
raw=$(zcat ${reads_path}/*.fastq.gz | wc -l)
echo -e "Raw_reads\t$((raw/4))" >> "$out"

# 2. Concatenated, relabeled reads
if [[ -f "${project_path}/all.concatenated.fq" ]]; then
    cat_lines=$(wc -l < "${project_path}/all.concatenated.fq")
    echo -e "Concatenated\t$((cat_lines/4))" >> "$out"
fi

# 2. Concatenated reads
if [[ -f "${project_path}/all.concatenated.fq" ]]; then
    conc=$(wc -l < "${project_path}/all.concatenated.fq")
    echo -e "Concatenated\t$((conc/4))" >> "$out"
fi

# 3. Filtered
if [[ -f "${project_path}/filtered.fa" ]]; then
    echo -e "Filtered\t$(grep -c '^>' "${project_path}/filtered.fa")" >> "$out"
fi

# 4. Dereplicated
if [[ -f "${project_path}/derep.fasta" ]]; then
    echo -e "Dereplicated\t$(grep -c '^>' "${project_path}/derep.fasta")" >> "$out"
fi

# 5. Centroids
if [[ -f "${project_path}/centroids.fasta" ]]; then
    echo -e "Centroids\t$(grep -c '^>' "${project_path}/centroids.fasta")" >> "$out"
fi

# 6. Non-chimera
if [[ -f "${project_path}/nochimeras.fasta" ]]; then
    echo -e "Nonchimera\t$(grep -c '^>' "${project_path}/nochimeras.fasta")" >> "$out"
fi

# 7. Final ASVs
if [[ -f "${project_path}/ASVs.fasta" ]]; then
    echo -e "ASVs\t$(grep -c '^>' "${project_path}/ASVs.fasta")" >> "$out"
fi

echo "Read tracking complete. Results in $out"