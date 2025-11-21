#!/bin/bash
#SBATCH --time=24:00:00           # Maximum walltime
#SBATCH --nodes=1                # Number of nodes
#SBATCH --ntasks-per-node=1     # Number of tasks (CPUs) per node
#SBATCH --cpus-per-task=32      # Number of CPUs per task
#SBATCH --mem=192G                # Total memory
#SBATCH --job-name=metaspades_run  # Job name
#SBATCH --account=st-shallam-1    # Account name
#SBATCH --mail-type=ALL           # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=jcsm2010@mail.ubc.ca   # Where to send the mail
#SBATCH --output=log_out_metaspades.txt   # Standard output log file
#SBATCH --error=error_metaspades.txt   # Standard error log file
#SBATCH --array=1-14

#PATHS
project_path="/home/jcsm2010/scratch/jcsm2010/AG_AD_metaG_analysis"
reads_path="${project_path}/corrected_reads"
assemblies_path="${project_path}/assemblies/spades_hybrid_assemblies"
pacbio_reads_path="${project_path}/Pac_Bio_reads"

INPUT_FILENAME=$(sed -n "${SLURM_ARRAY_TASK_ID}p" /home/jcsm2010/jcsm2010/Ag_AD_metagenomics/executables/sample_hybrid.txt)
# LOAD MODULES, INSERT CODE, AND RUN YOUR PROGRAMS HERE

echo "Input R1: ${reads_path}/${INPUT_FILENAME}_R1.corrected.fq"
echo "Input R2: ${reads_path}/${INPUT_FILENAME}_R2.corrected.fq"

# I installed spades in my base environment
metaspades.py -1 ${reads_path}/${INPUT_FILENAME}_R1.corrected.fq -2 ${reads_path}/${INPUT_FILENAME}_R2.corrected.fq --pacbio ${pacbio_reads_path}/${INPUT_FILENAME}_PB.fastq.gz -m 376 -t 32 -o ${assemblies_path}/${INPUT_FILENAME}  --only-assembler 