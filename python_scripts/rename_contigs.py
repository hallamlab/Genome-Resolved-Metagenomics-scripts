import os

def rename_contigs(file_path):
    # Extract the sample name from the file name
    sample_name = os.path.basename(file_path).replace('_spades_contigs.fa', '')
    
    # Read the original file
    with open(file_path, 'r') as infile:
        lines = infile.readlines()
    
    # Prepare the output file
    new_file_path = file_path.replace('_spades_contigs.fa', '_spades_contigs.fasta')
    with open(new_file_path, 'w') as outfile:
        for line in lines:
            if line.startswith('>'):
                # Add the sample name after the ">"
                new_line = line.replace('>', f'>{sample_name}_spades_')
                outfile.write(new_line)
            else:
                outfile.write(line)

# Path to your directory with the FASTA files
directory = '/home/jcsm2010/scratch/jcsm2010/AG_AD_metaG_analysis/assemblies/spades_assemblies/'

# Loop through all FASTA files in the directory and rename the contigs
for filename in os.listdir(directory):
    if filename.endswith('_contigs.fa'):
        file_path = os.path.join(directory, filename)
        rename_contigs(file_path)
        print(f'Renamed contigs in {filename}')