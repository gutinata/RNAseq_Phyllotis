#!/bin/bash
#SBATCH --job-name=VAP_run 		##%x; %j is the job number
#SBATCH --output=/work/storzlab/gutinata88/Phyllotis/try_VAP_natasha/%x-%j.out
#SBATCH --error=/work/storzlab/gutinata88/Phyllotis/try_VAP_natasha/%x-%j.err
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=170gb
#SBATCH --time=168:00:00 
#SBATCH --partition=guest,tmp_anvil,batch

module purge
module load anaconda
conda activate vap-env

perl VariantAnalysisPipeline.pl -c config_job.file

echo "Done!"
