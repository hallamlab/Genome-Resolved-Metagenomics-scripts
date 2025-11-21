#!/bin/bash
#SBATCH --account=st-shallam-1
#SBATCH --array=1-14
#SBATCH --nodes=1
#SBATCH --time 1:0:0
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=10G
#SBATCH --job-name=coverm-mapping-to-contigs
#SBATCH --output=coverm-mapping-to-contigs_%A_%a.out
#SBATCH --error=coverm-mapping-to-contigs_%A_%a.err
#SBATCH --mail-user=jcsm2010@mail.ubc.ca
#SBATCH --mail-type=ALL


# load modules
module load CVMFS_CC
module load bowtie2 samtools
source /home/jcsm2010/mambaforge/bin/activate coverm
# array jobs
mapping_file=$(sed -n "${SLURM_ARRAY_TASK_ID}p" /home/jcsm2010/jcsm2010/Ag_AD_metagenomics/executables/sample_hybrid.txt)

#Paths

project_path="/home/jcsm2010/scratch/jcsm2010/AG_AD_metaG_analysis" 
mapping_path="${project_path}/mapping_results/spades_hybrid/5000"
out_path="${mapping_path}/coverM_results"

# coverm command
coverm contig --bam-files ${mapping_path}/${mapping_file}.sorted.bam --min-read-aligned-percent 0.75 --min-read-percent-identity 0.95 --min-covered-fraction 0 &> ${out_path}/${mapping_file}_coverage.txt