#!/bin/bash
#SBATCH --account=st-shallam-1
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=186GB
#SBATCH --job-name=bowtie2-build-index-derep_hybrid-AG_AD
#SBATCH --output=build-index-contigs_%A_%a.out
#SBATCH --error=build_index_error_%A_%a.txt
#SBATCH --mail-user=jcsm2010@mail.ubc.ca
#SBATCH --mail-type=ALL


# array job
contig_file=$(sed -n "${SLURM_ARRAY_TASK_ID}p" /home/jcsm2010/jcsm2010/Ag_AD_metagenomics/executables/sample_hybrid.txt)

# paths
project_path="/home/jcsm2010/scratch/jcsm2010/AG_AD_metaG_analysis"
bins_path="${project_path}/hybrid_read_bins/derep_bins/Dereplicated_Representative_Genomes"
out_path="${contigs_path}/bt2/5000"

# load module
module load CVMFS_CC
module load bowtie2 minimap2


# index
#bowtie2-build ${contigs_path}/${contig_file}_5000_operams_contigs.fasta ${out_path}/${contig_file}
bowtie2-build ${bins_path}/all_bins_renamed.fasta ${bins_path}/bt2/all_bins_renamed.fasta

#minimap index not necessary, index created on the fly
#minimap2 -d  ${out_path}/${contig_file}.mmi ${contigs_path}/${contig_file}_renamed_flye_contigs.fa