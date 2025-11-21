#!/bin/bash
#SBATCH --account=st-shallam-1
#SBATCH --time 0:15:0
#SBATCH --cpus-per-task=16
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=64G
#SBATCH --job-name=filter_contigs_size
#SBATCH --output=filter_contigs_size_%A_%a.txt
#SBATCH --error=filter_contigssize_error_%A_%a.txt
#SBATCH --mail-user=jcsm2010@mail.ubc.ca
#SBATCH --mail-type=ALL
#SBATCH --array=1-14

# array job
contig_file=$(sed -n "${SLURM_ARRAY_TASK_ID}p" /home/jcsm2010/jcsm2010/Ag_AD_metagenomics/executables/sample_hybrid.txt)

#Paths
project_path="/home/jcsm2010/scratch/jcsm2010/AG_AD_metaG_analysis"
contigs_path="${project_path}/assemblies/operams_assemblies"
#out_path="${contigs_path}/../assemblies_5000"

# load module
module load CVMFS_CC
module load bbmap

# reformat from deinterleaved to interleaved
reformat.sh in=${contigs_path}/${contig_file}_operams_contigs.fasta out=${contigs_path}/${contig_file}_1000_operams_contigs.fasta fastaminlength=1000
