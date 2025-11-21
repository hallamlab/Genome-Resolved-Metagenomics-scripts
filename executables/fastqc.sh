#!/bin/bash
#SBATCH --time=2:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=186GB
#SBATCH --job-name=fastqc2
#SBATCH --account=st-shallam-1
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=jcsm2010@mail.ubc.ca
#SBATCH --output=fastqc_%A_%a.txt
#SBATCH --error=fastqc_%A_%a.txt
#SBATCH --array=1-16

# LOAD MODULES, INSERT CODE, AND RUN YOUR PROGRAMS HERE

source /home/jcsm2010/mambaforge/bin/activate fastqc


# Call workflow

project_path="/home/jcsm2010/scratch/jcsm2010/outputs_sakinaw"
reads_path="${project_path}/CLEAN_READS"
fastqc_output_path="${project_path}/READ_QC/fastqc_output/output_corrected_reads"
#output_path="${project_path}/clean_reads"

INPUT_FILENAME=$(sed -n "${SLURM_ARRAY_TASK_ID}p" /home/jcsm2010/jcsm2010/Ag_AD_metagenomics/executables/sample_names_sakinaw.txt)

fastqc -t 32 \
    ${reads_path}/${INPUT_FILENAME}* \
    -o ${fastqc_output_path}
