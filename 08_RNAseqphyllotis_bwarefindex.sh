#!/bin/bash
#SBATCH --job-name=bwa_index ##%x; %j is the job number
#SBATCH --output=/work/storzlab/gutinata88/Phyllotis/reference/%x-%j.out
#SBATCH --error=/work/storzlab/gutinata88/Phyllotis/reference/%x-%j.err
#SBATCH --mail-user=nguti@huskers.unl.edu
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --mem=250gb
#SBATCH --time=5:00:00 

##bwa
module load bwa/0.7

cd /work/storzlab/gutinata88/Phyllotis/reference

bwa index 'tom-uni1803-mb-hirise-6427t_01-19-2021__final_assembly.fasta'

echo "Done!"
