#!/bin/bash
#SBATCH --time=1:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=64GB
#SBATCH --job-name=Skder_AG_AD_hybrid_read
#SBATCH --account=st-shallam-1
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=jcsm2010@mail.ubc.ca
#SBATCH --output=Skader_out_%A_%a.txt
#SBATCH --error=Skader_err_%A_%a.txt

source /home/jcsm2010/mambaforge/bin/activate skder_env

#PATHS
project_path="/home/jcsm2010/scratch/jcsm2010/AG_AD_metaG_analysis"
bins_path="${project_path}/hybrid_read_bins/HQMQ_bins"
derep_bins_path="${project_path}/hybrid_read_bins/derep_bins"

#Software
skder -g ${bins_path}/*.fasta \
    -o ${derep_bins_path} \
    -d dynamic \
    -i 95.0 \
    -c 32 \
    -n
