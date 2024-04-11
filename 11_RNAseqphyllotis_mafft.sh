#!/bin/sh
#SBATCH --job-name=mafft 		##%x; %j is the job number
#SBATCH --output=/work/storzlab/gutinata88/Phyllotis/OXPHOS_genome/FASTA/R/R_by_gene/%x-%j.out
#SBATCH --error=/work/storzlab/gutinata88/Phyllotis/OXPHOS_genome/FASTA/R/R_by_gene/%x-%j.err
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=170gb
#SBATCH --time=168:00:00 
#SBATCH --partition=guest,tmp_anvil,batch

## Load Necessary modules
module purge
module load mafft/7.407

## Set-up the work directory
cd '/work/storzlab/gutinata88/Phyllotis/OXPHOS_genome/FASTA/R/R_by_gene/'

## create a file with the names of the files
ls * > genelist.txt #lists files in folder

## create a new directory to store results
mkdir ./MAFFT

while read line;
do
	name=$(echo "${line}" | cut -d "." -f 1) 			##cuts the path by every "." and keeps the 1st element (filename)
						
	mafft "${name}".fasta > ./MAFF/"${name}"_MAFFT.fasta

	echo "${name}" 
	
done < genelist.txt

echo "Done!"