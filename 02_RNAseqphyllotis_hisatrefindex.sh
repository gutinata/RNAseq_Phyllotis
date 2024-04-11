#!/bin/bash
#SBATCH --job-name=hisat_build
#SBATCH --output=/work/storzlab/gutinata88/Phyllotis/reference/%x-%j.out
#SBATCH --error=/work/storzlab/gutinata88/Phyllotis/reference/hisat2.%J.err
#SBATCH --mail-user=nguti@huskers.unl.edu
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=250gb
##SBATCH --time=2:30:00 # How long should they run
## Above is all information for SLURM. It should all appear at the top of
## the script before your commands to run. SLURM understands lines
## beginning with ## as a comment.


## Same as previous you need to load HiSat (if you installed at base you don't need to do anything)
module load hisat2/2.2


cd /work/storzlab/gutinata88/Phyllotis/reference ## this is the path to the folder where the reference files are in 

## this command is only building an index for the reference
hisat2-build tom-uni1803-mb-hirise-6427t_01-19-2021__final_assembly.fasta tom-uni1803-mb-hirise-6427t_01-19-2021__final_assembly
echo "Done!"







