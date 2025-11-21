#!/bin/bash
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=186GB
#SBATCH --job-name=operams
#SBATCH --account=st-shallam-1
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=jcsm2010@mail.ubc.ca
#SBATCH --output=log_operams_%A_%a.txt
#SBATCH --error=error_operams_%A_%a.txt
#SBATCH --array=5

# Load conda environment(adjust as per your HPC system)
source /home/jcsm2010/mambaforge/bin/activate operams

# Define paths
project_path="/home/jcsm2010/scratch/jcsm2010/AG_AD_metaG_analysis"
reads_path="${project_path}/corrected_reads"
assemblies_path="${project_path}/assemblies/operams_assemblies"
pacbio_reads_path="${project_path}/Pac_Bio_reads"

# Define input filename based on SLURM_ARRAY_TASK_ID
INPUT_FILENAME=$(sed -n "${SLURM_ARRAY_TASK_ID}p" /home/jcsm2010/jcsm2010/Ag_AD_metagenomics/executables/sample_hybrid.txt)


# Run opera-ms
perl /home/jcsm2010/scratch/jcsm2010/operams/OPERA-MS/OPERA-MS.pl \
    --short-read1 ${reads_path}/${INPUT_FILENAME}_R1.corrected.fq \
    --short-read2 ${reads_path}/${INPUT_FILENAME}_R2.corrected.fq \
    --long-read ${pacbio_reads_path}/${INPUT_FILENAME}_PB.fastq \
    --out-dir  ${assemblies_path}/${INPUT_FILENAME} \
    --short-read-assembler spades --genome-db /home/jcsm2010/jcsm2010/gtdb/OPERA-MS-DB/ --num-processors 32 \
    --no-polishing  \
    --contig-file ${assemblies_path}/scaffolds.fasta

#rm -rf ${assemblies_path}/${INPUT_FILENAME}/intermediate_files