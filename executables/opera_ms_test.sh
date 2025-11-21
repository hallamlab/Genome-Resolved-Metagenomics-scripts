#!/bin/bash
#SBATCH --time=1:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64GB
#SBATCH --job-name=operams_test2
#SBATCH --account=st-shallam-1
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=jcsm2010@mail.ubc.ca
#SBATCH --output=log_operams_test2.txt
#SBATCH --error=error_operams_test2.txt

source /home/jcsm2010/mambaforge/bin/activate operams

cd /home/jcsm2010/scratch/jcsm2010/operams/OPERA-MS/test_files
perl ../OPERA-MS.pl \
    --contig-file contigs.fasta \
    --short-read1 R1.fastq.gz \
    --short-read2 R2.fastq.gz \
    --long-read long_read.fastq \
    --genome-db /home/jcsm2010/scratch/jcsm2010/gtdb/OPERA-MS-DB/ \
    --out-dir RESULTS2 2> log.err