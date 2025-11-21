#!/bin/bash
#SBATCH --account=def-shallam
#SBATCH --time=6:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=5970GB
#SBATCH --job-name=pilon_polishing2
#SBATCH --output=pilon2.out
#SBATCH --mail-user=jcsm2010@mail.ubc.ca
#SBATCH --mail-type=ALL
#SBATCH --error=error_pilon2.txt
#SBATCH --array=2

module load StdEnv/2023
module load java/21.0.1

# Define paths
project_path="/home/jcsm2010/scratch/AG_AD"
assemblies_path="${project_path}/operams_assemblies"

# Define input filename based on SLURM_ARRAY_TASK_ID
INPUT_FILENAME=$(sed -n "${SLURM_ARRAY_TASK_ID}p" /home/jcsm2010/projects/def-shallam/jcsm2010/Ag_AD_metaGs/executables/sample_hybrid.txt)

java -Xmx3980G -jar /home/jcsm2010/scratch/pilon-1.24.jar \
    --genome ${assemblies_path}/${INPUT_FILENAME}/contigs.fasta \
    --frags ${assemblies_path}/${INPUT_FILENAME}/contigs.sorted.bam \
    --output ${assemblies_path}/${INPUT_FILENAME}/contigs.polished
