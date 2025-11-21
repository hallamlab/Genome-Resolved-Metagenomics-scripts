#!/bin/bash
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=376GB
#SBATCH --job-name=LRbinner
#SBATCH --account=st-shallam-1
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=jcsm2010@mail.ubc.ca
#SBATCH --output=log_out_LRbinner.txt
#SBATCH --error=error_LRBinner.txt
#SBATCH --array=1-14

# LOAD MODULES, INSERT CODE, AND RUN YOUR PROGRAMS HERE
module load gcc
module load apptainer
#source /home/jcsm2010/mambaforge/bin/activate lrbinner  

assemblies="/home/jcsm2010/scratch/jcsm2010/AG_AD_metaG_analysis/assemblies/operams_assemblies"
reads_path="/home/jcsm2010/scratch/jcsm2010/AG_AD_metaG_analysis/Pac_Bio_reads"
output="/home/jcsm2010/scratch/jcsm2010/AG_AD_metaG_analysis/bins_operams/LRBinner_bins"
INPUT_FILENAME=$(sed -n "${SLURM_ARRAY_TASK_ID}p" /home/jcsm2010/jcsm2010/Ag_AD_metagenomics/executables/sample_hybrid.txt)

# Call workflow
#/home/jcsm2010/scratch/jcsm2010/LRBinner/lrbinner.py contigs -r ${reads_path}/${INPUT_FILENAME}.fastq --k-size 3 \
 #-bs 32 -bc 10 -o ${output}/${INPUT_FILENAME} --ae-dims 4 --ae-epochs 200 -t 16 -c ${assemblies}/${INPUT_FILENAME}_renamed_flye_contigs.fa


# Path to the lrbinner Apptainer image
LRBINNER_IMAGE="/home/jcsm2010/scratch/jcsm2010/LRbinner/lrbinner.sif"

# Run Apptainer container with lrbinner
apptainer exec \
  --bind $assemblies:/assemblies \
  --bind $reads_path:/input \
  --bind $output:/output \
   $LRBINNER_IMAGE lrbinner.py contigs \
   -r /input/${INPUT_FILENAME}_PB.fastq \
   -o /output/${INPUT_FILENAME} \
   -c /assemblies/${INPUT_FILENAME}_operams_contigs.fasta \
   --k-size 3 \
   -bs 32 \
   -bc 10 \
  --ae-dims 4 \
  --ae-epochs 200 \
   -t 16 -sep
