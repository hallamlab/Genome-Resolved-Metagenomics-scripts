#!/bin/bash
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=186G
#SBATCH --job-name=metapathways_build_db
#SBATCH --account=st-shallam-1
#SBATCH --mail-type=ALL
#SBATCH --mail-user=jcsm2010@mail.ubc.ca
#SBATCH --output=log_metapathways_build_db.txt
#SBATCH --error=error_metapathways_build_db.txt

# Load modules
module load http_proxy   

# in case sub-processes don’t inherit these
export http_proxy=$HTTP_PROXY
export https_proxy=$HTTPS_PROXY

# Activate your environment
source /home/jcsm2010/mambaforge/bin/activate metapathways_env

# Define paths
project_path="/home/jcsm2010/scratch"
db_path="${project_path}/cazy_db"

# Run MetaPathways database build
metapathways build_db \
    -t 32 \
    --refdb_dir "${db_path}" \
    --func cazy \
    --aligner blast \
    --snakemake cores=32 \
    --snakemake rerun-incomplete \
    --snakemake keep-going \
    --snakemake printshellcmds
