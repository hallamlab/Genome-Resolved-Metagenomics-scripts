#!/bin/bash
#SBATCH --time=12:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=64GB
#SBATCH --job-name=VSEARCH-16S-mapping
#SBATCH --account=st-shallam-1
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=jcsm2010@mail.ubc.ca
#SBATCH --output=log_VSEARCH_%A_%a.txt
#SBATCH --error=error_VSEARCH_%A_%a.txt


# Load conda environment 
source /home/jcsm2010/mambaforge/bin/activate vsearch_cenv

# Define paths
illumina_path="/home/jcsm2010/scratch/jcsm2010/fastq_mycopots/fastq_16S_mycopots"
pacbio_path="/home/jcsm2010/scratch/jcsm2010/PacBio_Mycopots/GMCF_2763/demux_fastq/fastq_16S_PacBio"

vsearch \
  --usearch_global ${illumina_path}/ASVs.fasta \
  --db ${pacbio_path}/ASVs.fasta \
  --id 1.0 \
  --strand both \
  --blast6out ${illumina_path}/illumina_vs_pacbio.b6 \
  --maxaccepts 0 \
  --maxrejects 0 \
  --threads 32 \
  --userout ${illumina_path}/illumina_vs_pacbio.txt \
  --userfields query+target+id+alnlen+mism+opens+qlo+qhi+tlo+thi+evalue+bits+qcov+tcov

vsearch \
  --usearch_global ${illumina_path}/ASVs.fasta \
  --db ${pacbio_path}/ASVs.fasta \
  --id 1.0 \
  --strand both \
  --maxaccepts 0 \
  --maxrejects 0 \
  --threads 32 \
  --alnout  ${illumina_path}/illumina_vs_pacbio.aln

vsearch --usearch_global ${pacbio_path}/ASVs.fasta \
  --db ${illumina_path}/ASVs.fasta \
  --id 1.0 \
  --strand both \
  --blast6out ${pacbio_path}/pacbio_vs_illumina.b6 \
  --threads 32 \
  --maxaccepts 0 \
  --maxrejects 0 \
  --userout ${pacbio_path}/pacbio_vs_illumina.txt \
  --userfields query+target+id+alnlen+mism+opens+qlo+qhi+tlo+thi+evalue+bits+qcov+tcov 

  vsearch --usearch_global ${pacbio_path}/ASVs.fasta \
  --db ${illumina_path}/ASVs.fasta \
  --id 1.0 \
  --strand both \
  --threads 32 \
  --maxaccepts 0 \
  --maxrejects  0 \
  --alnout  ${pacbio_path}/pacbio_vs_illumina.aln

##Map PB filtered reads to Illumina ASVs

#vsearch --usearch_global  ${pacbio_path}/filtered.fa \
#            --db  ${illumina_path}/ASVs.fasta \
#            --id 0.99 \
#            --sizein \
#            --sizeout \
#            --otutabout ${pacbio_path}/ASV_table_Illumina_reads.tsv \
#            --threads 32

#vsearch --usearch_global  ${illumina_path}/filtered.fa \
 #           --db  ${pacbio_path}/ASVs.fasta \
  #          --id 0.99 \
   #         --sizein \
    #        --sizeout \
     #       --otutabout ${illumina_path}/ASV_table_PB_reads.tsv \
      #      --threads 32