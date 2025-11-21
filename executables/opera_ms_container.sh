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
#SBATCH --output=log_operams_container.txt
#SBATCH --error=error_operams_container.txt
#SBATCH --array=1

# Load Apptainer module (adjust as per your HPC system)
module load CVMFS_CC
module load gcc
module load apptainer 

# Define paths
project_path="/home/jcsm2010/scratch/jcsm2010/AG_AD_metaG_analysis"
reads_path="${project_path}/corrected_reads"
assemblies_path="${project_path}/assemblies/operams_assemblies_container"
pacbio_reads_path="${project_path}/Pac_Bio_reads"
genome_db="/home/jcsm2010/scratch/jcsm2010/gtdb/OPERA-MS-DB/"

# Define input filename based on SLURM_ARRAY_TASK_ID
INPUT_FILENAME=$(sed -n "${SLURM_ARRAY_TASK_ID}p" /home/jcsm2010/jcsm2010/Ag_AD_metagenomics/executables/sample_hybrid.txt)

    # Path to the OPERA-MS Apptainer image
OPERA_MS_IMAGE="/home/jcsm2010/scratch/jcsm2010/operams/operams.sif"

# Run Apptainer container with OPERA-MS
apptainer exec \
  --bind $reads_path:/input_short \
  --bind $pacbio_reads_path:/input_long \
  --bind $assemblies_path:/output \
  --bind $genome_db:/OPERA-MS-DB \
   $OPERA_MS_IMAGE operams \
  --short-read1 /input_short/${INPUT_FILENAME}_R1.corrected.fq \
  --short-read2 /input_short/${INPUT_FILENAME}_R2.corrected.fq \
  --long-read /input_long/${INPUT_FILENAME}_PB.fastq \
  --out-dir /output/${INPUT_FILENAME} \
  --genome-db  /OPERA-MS-DB/ \
  --short-read-assembler spades \
  --num-processors 32 