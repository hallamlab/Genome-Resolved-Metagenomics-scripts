#!/bin/bash
#SBATCH --time=76:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=376GB
#SBATCH --job-name=operams
#SBATCH --account=st-shallam-1
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=jcsm2010@mail.ubc.ca
#SBATCH --output=log_operams_%A_%a.txt
#SBATCH --error=error_operams_%A_%a.txt
#SBATCH --array=1

# Load conda environment 
source /home/jcsm2010/mambaforge/bin/activate operams

# Define paths
project_path="/home/jcsm2010/scratch/jcsm2010/AG_AD_metaG_analysis"
reads_path="${project_path}/corrected_reads"
assemblies_path="${project_path}/assemblies/operams_assemblies"
pacbio_reads_path="${project_path}/Pac_Bio_reads"
spades_assemblies_path="${project_path}/assemblies/temporary_spades_assemblies"

# Define input filename based on SLURM_ARRAY_TASK_ID
INPUT_FILENAME=$(sed -n "${SLURM_ARRAY_TASK_ID}p" /home/jcsm2010/jcsm2010/Ag_AD_metagenomics/executables/to_run_inopera.txt)

# Move to local scratch directory
cd $TMPDIR

# Copy necessary input files to local scratch
cp ${reads_path}/${INPUT_FILENAME}_R1.corrected.fq .
cp ${reads_path}/${INPUT_FILENAME}_R2.corrected.fq .
cp ${pacbio_reads_path}/${INPUT_FILENAME}_PB.fastq .
cp ${spades_assemblies_path}/${INPUT_FILENAME}/scaffolds.fasta .

# Run OPERA-MS
perl /home/jcsm2010/scratch/jcsm2010/operams/OPERA-MS/OPERA-MS.pl \
    --short-read1 ${INPUT_FILENAME}_R1.corrected.fq \
    --short-read2 ${INPUT_FILENAME}_R2.corrected.fq \
    --long-read ${INPUT_FILENAME}_PB.fastq \
    --out-dir ${INPUT_FILENAME}_output \
    --short-read-assembler spades --genome-db /home/jcsm2010/jcsm2010/gtdb/OPERA-MS-DB/ --num-processors 32 \
    --no-polishing \
    --contig-file scaffolds.fasta

# Move only required output files back to scratch
mkdir -p ${assemblies_path}/${INPUT_FILENAME}
cp -r ${INPUT_FILENAME}_output/opera_ms_clusters ${assemblies_path}/${INPUT_FILENAME}/
cp ${INPUT_FILENAME}_output/assembly.stats ${assemblies_path}/${INPUT_FILENAME}/
cp ${INPUT_FILENAME}_output/cluster_info.txt ${assemblies_path}/${INPUT_FILENAME}/
cp ${INPUT_FILENAME}_output/contig_info.txt ${assemblies_path}/${INPUT_FILENAME}/
cp ${INPUT_FILENAME}_output/contigs.fasta ${assemblies_path}/${INPUT_FILENAME}/
cp ${INPUT_FILENAME}_output/opera-ms-utils.config ${assemblies_path}/${INPUT_FILENAME}/

# Clean up TMPDIR
rm -rf ${INPUT_FILENAME}_output