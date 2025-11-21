#!/bin/bash
#SBATCH --time=12:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=64GB
#SBATCH --job-name=VSEARCH-16S
#SBATCH --account=st-shallam-1
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=jcsm2010@mail.ubc.ca
#SBATCH --output=log_VSEARCH_%A_%a.txt
#SBATCH --error=error_VSEARCH_%A_%a.txt


# Load conda environment 
source /home/jcsm2010/mambaforge/bin/activate vsearch_cenv

# Define paths
project_path="/home/jcsm2010/scratch/jcsm2010/fastq_mycopots/fastq_16S_mycopots"
reads_path="${project_path}/raw_reads"

# Run VSEARCH
for Sample in ${reads_path}/*_R1.fastq.gz
do
  # Extract the sample name by stripping the _R1.fastq.gz suffix
  SampleName=$(basename ${Sample} _R1.fastq.gz)

  # Merge paired reads diffs 10 and 100 for 16S, 20 and 50 for ITS
  vsearch \
    --fastq_mergepairs ${reads_path}/${SampleName}_R1.fastq.gz \
    --reverse ${reads_path}/${SampleName}_R2.fastq.gz \
    --relabel ${SampleName}. \
    --fastq_maxdiffs 10 \
    --fastq_maxdiffpct 100 \
    --fastqout ${reads_path}/${SampleName}.merged.fq \
    --threads 32

  # Concatenate merged reads into all.merged.fq.gz
  cat ${reads_path}/${SampleName}.merged.fq >> ${project_path}/all.merged.fq
done

# Convert full merged FASTQ to FASTA for mapping later
vsearch --fastq_filter ${project_path}/all.merged.fq \
        --fastaout ${project_path}/all.merged.fasta

# Strip primers (V3F is 19, V4R is 20)
vsearch --fastx_filter ${project_path}/all.merged.fq \
    --fastq_stripleft 19 \
    --fastq_stripright 20 \
    --fastq_maxee 1.0 \
    --fastaout ${project_path}/filtered.fa

#Find Unique sequences (derep)
vsearch --derep_fulllength ${project_path}/filtered.fa \
            --output ${project_path}/derep.fasta \
            --relabel Uniq \
            --sizeout

#Denoise (UNOISE3 algorithm). In VSEARCH this does not perform chimera removal. Also, min-size specfies the min abundance of sequences, so no need to remove singletons afterwards.
vsearch --cluster_unoise ${project_path}/derep.fasta \
        --minsize 8 \
       --unoise_alpha 2 \
       --relabel proto_ASV \
       --sizein \
       --sizeout \
       --centroids ${project_path}/centroids.fasta \
       --threads 32

#Remove Chimeras
vsearch --uchime3_denovo ${project_path}/centroids.fasta \
        --nonchimeras ${project_path}/nochimeras.fasta \
        --relabel proto_ASV_nonchimera\
        --sizein \
        --sizeout

#sort by size
vsearch --sortbysize ${project_path}/nochimeras.fasta \
        --output   ${project_path}/ASVs.fasta \
        --relabel ASV \
        --sizein \
        --sizeout \
        --minsize 2 \
        --threads 32

#Make ASV table
vsearch --usearch_global  ${project_path}/filtered.fa \
            --db  ${project_path}/ASVs.fasta \
            --id 0.99 \
            --sizein \
            --sizeout \
            --otutabout ${project_path}/ASV_table.tsv \
            --threads 32

#Taxonomic classification #--db /home/jcsm2010/jcsm2010/UNITE_db/utax_reference_dataset_19.02.2025.fasta #--db /home/jcsm2010/jcsm2010/midas_db/MiDAS_5.3.fa \
vsearch --sintax ${project_path}/ASVs.fasta \
        --db /home/jcsm2010/jcsm2010/silva_db/SILVA_138.2_SSURef_NR99_tax_silva_SINTAX.fasta \
        --tabbedout ${project_path}/taxonomic_classifications.tsv \
        --sintax_cutoff 0.8 \
        --strand both

echo "VSEARCH pipeline complete! 🎉"