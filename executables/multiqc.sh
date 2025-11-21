#!/bin/bash
#SBATCH --time=1:00:00
#SBATCH --cpus-per-task=8
#SBATCH --nodes=1
#SBATCH --mem=32GB
#SBATCH --job-name=multiqc_spades
#SBATCH --account=st-shallam-1
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=jcsm2010@mail.ubc.ca
#SBATCH --output=multiqc_%A.txt
#SBATCH --error=multiqc_%A.txt

source /home/jcsm2010/mambaforge/bin/activate fastqc

project_path="/home/jcsm2010/scratch/jcsm2010/AG_AD_metaG_analysis"
fastqc_output_path="${project_path}/READ_QC/fastqc_output/output_raw_reads"
quast_output_path="${project_path}/quast_reports/operams"

multiqc ${quast_output_path} \
    --filename ${quast_output_path}/multiqc_AG_AD_operams.html