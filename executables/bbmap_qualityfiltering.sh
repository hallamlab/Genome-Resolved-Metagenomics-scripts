#!/bin/bash
#SBATCH --time=12:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=256GB
#SBATCH --job-name=BBduk
#SBATCH --account=st-shallam-1
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=jcsm2010@mail.ubc.ca
#SBATCH --output=log_out_BBdukQC.txt
#SBATCH --error=errorBBduk.txt
#SBATCH --array=1-37

# LOAD MODULES, INSERT CODE, AND RUN YOUR PROGRAMS HERE

module load CVMFS_CC
module load bbmap/38.86

# Call workflow

project_path="/home/jcsm2010/project/jcsm2010/Ag_AD_metagenomics"
reads_path="${project_path}/raw_reads"
output_path="${project_path}/clean_reads"

INPUT_FILENAME=$(sed -n "${SLURM_ARRAY_TASK_ID}p" /home/jcsm2010/project/jcsm2010/Ag_AD_metagenomics/executables/sample_names.txt)

bbduk.sh in1=${reads_path}/${INPUT_FILENAME}_R1.fastq \
         in2=${reads_path}/${INPUT_FILENAME}_R2.fastq \
         out1=${output_path}/${INPUT_FILENAME}.clean_R1.fastq \
         out2=${output_path}/${INPUT_FILENAME}.clean_R2.fastq \
         ref=/home/jcsm2010/project/jcsm2010/Ag_AD_metagenomics/executables/adapters.fa \
         ktrim=r k=23 mink=11 hdist=1 tpe tbo maxns=4 qtrim=r trimq=0 maq=3 minlen=51 mlf=33 usejni=t \
         threads=16
	
