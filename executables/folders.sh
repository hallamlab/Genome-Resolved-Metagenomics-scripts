#!/bin/bash
#SBATCH --time=6:00:00           # Maximum walltime
#SBATCH --nodes=1                # Number of nodes
#SBATCH --ntasks-per-node=1     # Number of tasks (CPUs) per node
#SBATCH --cpus-per-task=8      # Number of CPUs per task
#SBATCH --mem=16G                # Total memory
#SBATCH --job-name=folders  # Job name
#SBATCH --account=st-shallam-1    # Account name
#SBATCH --mail-type=ALL           # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=jcsm2010@mail.ubc.ca   # Where to send the mail
#SBATCH --output=log_out_folders.txt   # Standard output log file
#SBATCH --error=error_folders.txt   # Standard error log file
#SBATCH --array=1-15

#PATHS

stats_path="/home/jcsm2010/scratch/jcsm2010/outputs_sakinaw/assemblies_stats/megahit_stats/"
assemblies_path="/home/jcsm2010/scratch/jcsm2010/outputs_sakinaw/ASSEMBLIES/megahit_assemblies/"
INPUT_FILENAME=$(sed -n "${SLURM_ARRAY_TASK_ID}p" /home/jcsm2010/scratch/jcsm2010/executables/Sakinaw/sample_names.txt)

mkdir ${stats_path}/${INPUT_FILENAME}
mv ${assemblies_path}/${INPUT_FILENAME}/megahit/ ${stats_path}/${INPUT_FILENAME}
mv ${assemblies_path}/${INPUT_FILENAME}/QUAST_out/ ${stats_path}/${INPUT_FILENAME}
mv ${assemblies_path}/${INPUT_FILENAME}/assembly_report.html ${stats_path}/${INPUT_FILENAME}


