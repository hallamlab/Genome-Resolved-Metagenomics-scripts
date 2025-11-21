#!/bin/bash
#SBATCH --time=1:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=64GB
#SBATCH --job-name=Quast_spades
#SBATCH --account=st-shallam-1
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=jcsm2010@mail.ubc.ca
#SBATCH --output=Quast_out_%A_%a.txt
#SBATCH --error=Quast_err_%A_%a.txt
#SBATCH --array=1-14

source /home/jcsm2010/mambaforge/bin/activate metawrap-env

#PATHS
project_path="/home/jcsm2010/scratch/jcsm2010/AG_AD_metaG_analysis"
assemblies_path="${project_path}/assemblies/operams_assemblies"
output_dir="${project_path}/quast_reports/operams"
 #Define input filename based on SLURM_ARRAY_TASK_ID
INPUT_FILENAME=$(sed -n "${SLURM_ARRAY_TASK_ID}p" /home/jcsm2010/jcsm2010/Ag_AD_metagenomics/executables/sample_hybrid.txt)

#Software
quast.py ${assemblies_path}/${INPUT_FILENAME}_1000_operams_contigs.fasta\
    -t 32 \
    -o ${output_dir}/${INPUT_FILENAME}_1000
