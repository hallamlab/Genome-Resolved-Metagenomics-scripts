#!/bin/bash
#SBATCH --time=12:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=64GB
#SBATCH --job-name=opera-ms-db
#SBATCH --account=st-shallam-1
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=jcsm2010@mail.ubc.ca
#SBATCH --output=log_opera-ms-db.txt
#SBATCH --error=error_opera-ms-db.txt

python /home/jcsm2010/scratch/jcsm2010/gtdb/make_operams_db_from_gtdb.py /home/jcsm2010/scratch/jcsm2010/gtdb/all_genomes.txt.gz /home/jcsm2010/scratch/jcsm2010/gtdb/all_taxonomy_r220.tsv.gz --move --threads 32 --outdir /home/jcsm2010/scratch/jcsm2010/gtdb/operams_db