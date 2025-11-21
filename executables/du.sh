#!/bin/bash
#SBATCH --time=12:00:00           # Maximum walltime
#SBATCH --nodes=1                # Number of nodes
#SBATCH --ntasks-per-node=1     # Number of tasks (CPUs) per node
#SBATCH --cpus-per-task=8      # Number of CPUs per task
#SBATCH --mem=128G                # Total memory
#SBATCH --job-name=folder_size # Job name
#SBATCH --account=st-shallam-1    # Account name
#SBATCH --mail-type=ALL           # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=jcsm2010@mail.ubc.ca   # Where to send the mail
#SBATCH --output=log_out_folder_size.txt   # Standard output log file
#SBATCH --error=error_folder_size.txt   # Standard error log file



# Go to the target directory
cd /scratch/st-shallam-1/jcsm2010/

# Run the disk usage command
du -sh * | sort -h > disk_usage_juan.txt

# Go to the target directory
cd /scratch/st-shallam-1/

# Run the disk usage command
du -sh * | sort -h > disk_usage_everybody.txt