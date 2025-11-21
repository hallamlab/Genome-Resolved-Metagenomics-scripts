#!/bin/bash
#SBATCH --time=1:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=64GB
#SBATCH --job-name=track_reads
#SBATCH --account=st-shallam-1
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=jcsm2010@mail.ubc.ca
#SBATCH --output=log_track_reads_%A_%a.txt
#SBATCH --error=error_track_reads_%A_%a.txt


project_path="/home/jcsm2010/scratch/jcsm2010/fastq_mycopots/fastq_16S_mycopots"
reads_path="${project_path}/raw_reads"

out="${project_path}/read_tracking.tsv"
echo -e "Step\tReads" > "$out"

### 1. Raw reads (paired)
# Count R1 lines (4 lines/read) across all samples
raw_R1=$(zcat ${reads_path}/*_R1.fastq.gz | wc -l)
raw_R2=$(zcat ${reads_path}/*_R2.fastq.gz | wc -l)
echo -e "Raw_R1\t$((raw_R1/4))" >> "$out"
echo -e "Raw_R2\t$((raw_R2/4))" >> "$out"

### 2. Merged reads (all samples concatenated)
if [[ -f "${project_path}/all.merged.fq" ]]; then
    merged=$(wc -l < "${project_path}/all.merged.fq")
    echo -e "Merged\t$((merged/4))" >> "$out"
fi

### 3. Primer-trimmed & quality-filtered FASTA
if [[ -f "${project_path}/filtered.fa" ]]; then
    filtered=$(grep -c '^>' "${project_path}/filtered.fa")
    echo -e "Filtered\t${filtered}" >> "$out"
fi

### 4. Dereplicated uniques
if [[ -f "${project_path}/derep.fasta" ]]; then
    derep=$(grep -c '^>' "${project_path}/derep.fasta")
    echo -e "Dereplicated\t${derep}" >> "$out"
fi

### 5. UNOISE denoised centroids
if [[ -f "${project_path}/centroids.fasta" ]]; then
    unoise=$(grep -c '^>' "${project_path}/centroids.fasta")
    echo -e "UNOISE\t${unoise}" >> "$out"
fi

### 6. Non-chimeric ASVs
if [[ -f "${project_path}/nochimeras.fasta" ]]; then
    nonchim=$(grep -c '^>' "${project_path}/nochimeras.fasta")
    echo -e "Nonchimera\t${nonchim}" >> "$out"
fi

### 7. Final ASVs
if [[ -f "${project_path}/ASVs.fasta" ]]; then
    final_asvs=$(grep -c '^>' "${project_path}/ASVs.fasta")
    echo -e "Final_ASVs\t${final_asvs}" >> "$out"
fi

echo "Done!  Counts saved to $out"