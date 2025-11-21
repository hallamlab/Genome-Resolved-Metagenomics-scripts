#!/bin/bash
#SBATCH --time=96:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=376GB
#SBATCH --job-name=unicycler
#SBATCH --account=st-shallam-1
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=jcsm2010@mail.ubc.ca
#SBATCH --output=log_unicycler.txt
#SBATCH --error=error_unicycler.txt
#SBATCH --array=1

# Load Apptainer module (adjust as per your HPC system)
module load gcc
module load apptainer 

# Define paths
project_path="/home/jcsm2010/scratch/jcsm2010/AG_AD_metaG_analysis"
reads_path="${project_path}/corrected_reads"
assemblies_path="${project_path}/assemblies/unicycler_assemblies"
pacbio_reads_path="${project_path}/Pac_Bio_reads"

# Define input filename based on SLURM_ARRAY_TASK_ID
INPUT_FILENAME=$(sed -n "${SLURM_ARRAY_TASK_ID}p" /home/jcsm2010/jcsm2010/Ag_AD_metagenomics/executables/sample_hybrid.txt)

# Path to the LongQC Apptainer image
UNICYCLER_IMAGE="/home/jcsm2010/scratch/jcsm2010/Unicycler/unicycler_latest.sif"

# Run Apptainer container with LongQC
apptainer exec \
  --bind $reads_path:/input_short \
  --bind $pacbio_reads_path:/input_long \
  --bind $assemblies_path:/output \
  $UNICYCLER_IMAGE unicycler \
  --mode bold \
  -1 /input_short/${INPUT_FILENAME}_R1.corrected.fq \
  -2 /input_short/${INPUT_FILENAME}_R2.corrected.fq \
  -l /input_long/${INPUT_FILENAME}_PB.fastq \
  -o /output/${INPUT_FILENAME} \
  -t 32 