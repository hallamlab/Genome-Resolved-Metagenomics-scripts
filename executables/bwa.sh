#!/bin/bash
#SBATCH --time=24:00:00           # Maximum walltime
#SBATCH --nodes=1                # Number of nodes
#SBATCH --ntasks-per-node=1     # Number of tasks (CPUs) per node
#SBATCH --cpus-per-task=32      # Number of CPUs per task
#SBATCH --mem=186GB                # Total memory
#SBATCH --job-name=bwa_run  # Job name
#SBATCH --account=st-shallam-1    # Account name
#SBATCH --mail-type=ALL           # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=jcsm2010@mail.ubc.ca   # Where to send the mail
#SBATCH --output=log_out_bwa_%A_%a.out  # Standard output log file
#SBATCH --error=error_bwa_%A_%a.txt   # Standard error log file
#SBATCH --array=2-13

module load CVMFS_CC
module load samtools  #use this samtools because the one in the operams repo outputs to the logfile????

#PATHS
project_path="/home/jcsm2010/scratch/jcsm2010/AG_AD_metaG_analysis"
reads_path="${project_path}/corrected_reads"
assemblies_path="${project_path}/assemblies/operams_assemblies"
tools_path="/home/jcsm2010/scratch/jcsm2010/operams/OPERA-MS/tools_opera_ms"

INPUT_FILENAME=$(sed -n "${SLURM_ARRAY_TASK_ID}p" /home/jcsm2010/jcsm2010/Ag_AD_metagenomics/executables/sample_hybrid.txt)

#BWA index
${tools_path}/bwa index ${assemblies_path}/${INPUT_FILENAME}/contigs.fasta

#BWA mapping

${tools_path}/bwa mem -t 32 \
    ${assemblies_path}/${INPUT_FILENAME}/contigs.fasta \
    ${reads_path}/${INPUT_FILENAME}_R1.corrected.fq \
    ${reads_path}/${INPUT_FILENAME}_R2.corrected.fq \
    > ${assemblies_path}/${INPUT_FILENAME}/contigs.sam

    # Convert SAM to BAM using samtools
samtools view -@ 16 -Sb ${assemblies_path}/${INPUT_FILENAME}/contigs.sam -o ${assemblies_path}/${INPUT_FILENAME}/contigs.bam

# Sort and index the BAM file
samtools sort -@ 16 ${assemblies_path}/${INPUT_FILENAME}/contigs.bam -o ${assemblies_path}/${INPUT_FILENAME}/contigs.sorted.bam 
samtools index ${assemblies_path}/${INPUT_FILENAME}/contigs.sorted.bam