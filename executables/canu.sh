#!/bin/bash
#SBATCH --time=12:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=186GB
#SBATCH --job-name=canu
#SBATCH --account=st-shallam-1
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=jcsm2010@mail.ubc.ca
#SBATCH --output=canu_%A_%a.txt
#SBATCH --error=canu_%A_%a.txt
#SBATCH --array=1-12

module load perl
module load samtools
module load CVMFS_CC
module load java/21.0.1

# Define paths
#project_path="/home/jcsm2010/scratch/jcsm2010/AD_CC"
reads_path="/home/jcsm2010/scratch/jcsm2010/AD_CC"
canu_path="/home/jcsm2010/scratch/jcsm2010/canu-2.3/bin"

# Define input filename based on SLURM_ARRAY_TASK_ID
INPUT_FILENAME=$(sed -n "${SLURM_ARRAY_TASK_ID}p" /home/jcsm2010/jcsm2010/Ag_AD_metaG_PacBio/executables/sample_names_AD_CC.txt)

${canu_path}/canu -correct \
    -nanopore ${reads_path}/${INPUT_FILENAME}.corrected.fastq \
    -p nanocorrect_${INPUT_FILENAME} \
    -d ${reads_path}/canu_correction_${INPUT_FILENAME} \
    genomeSize=5m \
    corOutCoverage=all \
    corMhapSensitivity=high \
    correctedErrorRate=0.105 \
    corMaxEvidenceCoverageLocal=10 \
    corMaxEvidenceCoverageGlobal=10 \
    gridEngine=slurm \
    gridOptions="--nodes=1 --account=st-shallam-1"