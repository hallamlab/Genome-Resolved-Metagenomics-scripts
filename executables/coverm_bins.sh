#!/bin/bash
#SBATCH --account=st-shallam-1
#SBATCH --nodes=1
#SBATCH --time 2:0:0
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=128G
#SBATCH --job-name=coverm-mapping-to-bins
#SBATCH --output=coverm-mapping-to-bins_%A_%a.out
#SBATCH --error=coverm-mapping-to-bins_%A_%a.err
#SBATCH --mail-user=jcsm2010@mail.ubc.ca
#SBATCH --mail-type=ALL


# load modules
module load CVMFS_CC
module load bowtie2 samtools
source /home/jcsm2010/mambaforge/bin/activate coverm
# array jobs
#mapping_file=$(sed -n "${SLURM_ARRAY_TASK_ID}p" /home/jcsm2010/jcsm2010/Ag_AD_metaG_PacBio/executables/sample_names_AD_CC.txt)

#Paths

project_path="/home/jcsm2010/scratch/jcsm2010/AG_AD_metaG_analysis" 
mapping_path="${project_path}/mapping_results/derep_bins_hybrid_read"
out_path="${mapping_path}/coverM_results"

# coverm command
coverm genome -s "~" -m relative_abundance --bam-files ${mapping_path}/*.sorted.bam --min-read-aligned-percent 0.75 --min-read-percent-identity 0.95 --min-covered-fraction 0 -x fasta &> ${out_path}/AG_AD_derep_hybrid_bins_coverage.txt