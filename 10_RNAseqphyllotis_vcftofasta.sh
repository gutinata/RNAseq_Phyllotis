#!/bin/sh
##SBATCH --job-name=vcftofasta 		##%x; %j is the job number
##SBATCH --output=/work/storzlab/gutinata88/Phyllotis/OXPHOS_genome/trytry/%x-%j.out
##SBATCH --error=/work/storzlab/gutinata88/Phyllotis/OXPHOS_genome/trytry/%x-%j.err
##SBATCH --nodes=1
##SBATCH --ntasks-per-node=1
##SBATCH --mem=170gb
##SBATCH --time=168:00:00 
##SBATCH --partition=guest,tmp_anvil,batch

## Load Necessary modules
module purge
module load bcftools

## Set-up the work directory
cd '/work/storzlab/gutinata88/Phyllotis/OXPHOS_genome/VAP/'

## create a file with the paths to all the final vcf files from VAP
ls -R ./*/*/MERGE_FILTER/*-final-pass.vcf > final_vcf_paths.txt #lists recursively all the final vcf files from VAP

## create a new directory to store results
mkdir ./finalVCF


while read line;
do
	path=$(echo "${line}")
	name=$(echo "${line}" | cut -d "/" -f 5 | cut -d "_" -f 1) 			##cuts the path by every "/" and keeps the 5th element (filename)
																		##then cuts the filename by the "_" and keeps the 1st element (samplename)
	
	bgzip -c "${path}" > ./finalVCF/"${name}"-final-pass.vcf.gz
	tabix ./finalVCF/"${name}"-final-pass.vcf.gz
	
	bcftools consensus -f ../reference/oxphos_genome_162.fasta ./finalVCF/"${name}"-final-pass.vcf.gz -o ./finalVCF/"${name}".fa

	echo "${name}" 
	
done < final_vcf_paths.txt

echo "Done!"