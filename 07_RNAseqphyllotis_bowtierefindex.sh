#!/bin/bash
#SBATCH --job-name=bowtie_index ##%x; %j is the job number
#SBATCH --output=/work/storzlab/gutinata88/Phyllotis/reference/%x-%j.out
#SBATCH --error=/work/storzlab/gutinata88/Phyllotis/reference/%x-%j.err
#SBATCH --mail-user=nguti@huskers.unl.edu
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --mem=250gb
#SBATCH --time=5:00:00 

##bowtie
module load bowtie/2.3
##tophat
module load tophat/2.1

cd /work/storzlab/gutinata88/Phyllotis/reference

bowtie2-build 'tom-uni1803-mb-hirise-6427t_01-19-2021__final_assembly.fasta' 'tom-uni1803-mb-hirise-6427t_01-19-2021__final_assembly'

echo "Done!"
