#!/bin/bash
#SBATCH --job-name=map-longreads-spadeshybrid_all
#SBATCH --output=bowtie2-mapping-to-contigs%A_%a.out
#SBATCH --error=bowtie2-mapping-to-contigs_error_%A_%a.txt
#SBATCH --account=st-shallam-1
#SBATCH --time=2:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=64GB
#SBATCH --mail-user=jcsm2010@mail.ubc.ca
#SBATCH --mail-type=ALL
#SBATCH --array=1-14

# array jobs
mapping_file=$(sed -n "${SLURM_ARRAY_TASK_ID}p" /home/jcsm2010/jcsm2010/Ag_AD_metagenomics/executables/sample_hybrid.txt)

# paths
project_path="/home/jcsm2010/scratch/jcsm2010/AG_AD_metaG_analysis"
#ref_path="${project_path}/assemblies/operams_assemblies/bt2/all"
ref_path="${project_path}/assemblies/spades_hybrid_assemblies"
reads_path="${project_path}/Pac_Bio_reads/"
out_path="${project_path}/mapping_results/spades_hybrid/all"

# load modules
module load CVMFS_CC
module load bowtie2 samtools minimap2

# bowtie2/minimap2 mapping command
#bowtie2 -x ${ref_path}/${mapping_file} \
 # -1 ${reads_path}/${mapping_file}_R1.corrected.fq \
  #-2 ${reads_path}/${mapping_file}_R2.corrected.fq \
  #-q --very-sensitive -p 32 \
  #-S ${out_path}/${mapping_file}.sam

minimap2 -t 32 -ax map-hifi ${ref_path}/${mapping_file}_hybrid_spades_contigs.fasta ${reads_path}/${mapping_file}_PB.fastq | \

# samtools SAM to BAM short read
#samtools view -@ 32 -b ${out_path}/${mapping_file}.sam | \

#samtools SAM to BAM long read
 samtools view -@ 32 -b - | \
# samtools index
samtools sort -@ 32 -o ${out_path}/${mapping_file}.sorted.bam

# samtools index
samtools index ${out_path}/${mapping_file}.sorted.bam

# (optional) clean up SAM
#rm ${out_path}/${mapping_file}.sam

