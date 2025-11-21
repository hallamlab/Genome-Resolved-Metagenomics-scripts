#!/bin/bash
#SBATCH --time=12:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=64GB
#SBATCH --job-name=VSEARCH-PacBio-ITS
#SBATCH --account=st-shallam-1
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=jcsm2010@mail.ubc.ca
#SBATCH --output=log_VSEARCH_%A_%a.txt
#SBATCH --error=error_VSEARCH_%A_%a.txt


# Load conda environment 
source /home/jcsm2010/mambaforge/bin/activate vsearch_cenv

# Define paths
project_path="/home/jcsm2010/scratch/jcsm2010/PacBio_Mycopots/GMCF_2763/demux_fastq/fastq_ITS_PacBio"
reads_path="${project_path}/raw_reads"

# Run VSEARCH for PacBio single-end
for Sample in ${reads_path}/*.fastq.gz
do
  # Extract the sample name by stripping .fastq.gz
  SampleName=$(basename ${Sample} .fastq.gz)

  # Use vsearch to relabel reads
  vsearch \
    --fastq_filter ${Sample} \
    --fastq_qmax 93 \
    --relabel ${SampleName}. \
    --fastqout ${reads_path}/${SampleName}.labeled.fq \
    --threads 32

  # Concatenate all labeled reads
  cat ${reads_path}/${SampleName}.labeled.fq >> ${project_path}/all.concatenated.fq
done

# Convert full merged FASTQ to FASTA for mapping later
vsearch --fastq_filter ${project_path}/all.concatenated.fq \
        --fastq_qmax 93 \
        --fastaout ${project_path}/all.concatenated.fasta

# Strip primers 
vsearch --fastx_filter ${project_path}/all.concatenated.fq \
    --fastq_qmax 93 \
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


#Taxonomic classification #--db /home/jcsm2010/jcsm2010/silva_db/SILVA_138.2_SSURef_NR99_tax_silva_SINTAX.fasta #--db /home/jcsm2010/jcsm2010/midas_db/MiDAS_5.3.fa \
vsearch --sintax ${project_path}/ASVs.fasta \
        --db /home/jcsm2010/jcsm2010/UNITE_db/utax_reference_dataset_19.02.2025.fasta \
        --tabbedout ${project_path}/taxonomic_classifications.tsv \
        --sintax_cutoff 0.8 \
        --strand both

echo "VSEARCH pipeline complete! 🎉"