#!/bin/bash
#SBATCH --time=2:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=186GB
#SBATCH --job-name=chopper
#SBATCH --account=st-shallam-1
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=jcsm2010@mail.ubc.ca
#SBATCH --output=chopper_%A_%a.txt
#SBATCH --error=chopper_%A_%a.txt
#SBATCH --array=1-17

# Define paths
#project_path="/home/jcsm2010/scratch/jcsm2010/AD_CC"
reads_path="/home/jcsm2010/scratch/jcsm2010/AG_AD_metaG_analysis/Pac_Bio_reads"
contaminant_ref="/home/jcsm2010/scratch/jcsm2010/ref_genomes"

# Define input filename based on SLURM_ARRAY_TASK_ID
INPUT_FILENAME=$(sed -n "${SLURM_ARRAY_TASK_ID}p" /home/jcsm2010/jcsm2010/Ag_AD_metaG_PacBio/executables/sample_names.txt)

/home/jcsm2010/scratch/jcsm2010/chopper/chopper-linux -i ${reads_path}/${INPUT_FILENAME}.fastq \
    --quality 10 \
    --minlength 200 \
    --contam  ${contaminant_ref}/combined_contaminants.fa.gz > ${reads_path}/${INPUT_FILENAME}.corrected.fastq