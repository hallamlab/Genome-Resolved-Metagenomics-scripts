import os

def rename_contigs(file_path):
    # Extract sample name from file name
    base = os.path.basename(file_path)
    sample_name = base.replace('operams_', '').replace('_contigs.fasta', '')

    # Prepare output file path
    new_file_path = file_path.replace('.fasta', '_renamed.fasta')

    # Read and rename contig headers
    with open(file_path, 'r') as infile, open(new_file_path, 'w') as outfile:
        for line in infile:
            if line.startswith('>'):
                original_id = line[1:].strip()  # remove '>' and newline
                new_id = f">{sample_name}_operams_{original_id}\n"
                outfile.write(new_id)
            else:
                outfile.write(line)

# Directory containing the FASTA files
directory = '/home/jcsm2010/scratch/jcsm2010/AG_AD_metaG_analysis/assemblies/placeholder'

# Process each appropriate FASTA file
for filename in os.listdir(directory):
    if filename.startswith('operams_') and filename.endswith('_contigs.fasta'):
        file_path = os.path.join(directory, filename)
        rename_contigs(file_path)
        print(f'Renamed contigs in {filename}')