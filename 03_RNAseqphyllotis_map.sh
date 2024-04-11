#!/bin/bash
#SBATCH --job-name=hisat_loop
#SBATCH --output=/mnt/beegfs/aa192610e/phyllotis/slurm_scripts/OUTPUT/%x-%j.out
#SBATCH --mail-user=paulinhaaprigio@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --partition=good_lab_cpu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=250000
##SBATCH --time=2:30:00 # How long should they run
## Above is all information for SLURM. It should all appear at the top of
## the script before your commands to run. SLURM understands lines
## beginning with ## as a comment. Remove these lines if you are not running using slurm




REF=/mnt/beegfs/aa192610e/phyllotis/reference/tom-uni1803-mb-hirise-6427t_01-19-2021__final_assembly  ## directory to the reference genome file

############# Alignment!!!!! ###################

source /home/aa192610e/anaconda3/bin/activate ## I saved HiSat to this environment in conda, if you want to save it directly to your base use https://anaconda.org/bioconda/hisat2
conda activate HiSat ## if you install it directly to base you don't need this line

## you will also need for this script to have samtools installed https://anaconda.org/bioconda/samtools


cd /mnt/beegfs/aa192610e/phyllotis/Batch_2/Batch_2  ## directory where you will run the analysis, where your trimmed files outputed from the first script are

##part 2: create your bam, note, HiSat2 makes a large SAM file by default, so we pipe through samtools to save a smaller binary version (BAM)
        ## flags I included here: -q means my input files were fastq rather than fasta
        ##                        -x specifies the reference genome file base, will allow the program to find both the genome and the index
        ##                        -1 R1 trimmomatic file
        ##                        -2 R2 trimmomatic file
        ##                        -U unpaired R1 trimmomatic file

ls *.trimmed_1P.fq.gz | while read file; do #Loop through all forward (read 1) raw data fastqs
        name=$(echo "${file}" | cut -d "." -f 1)                #Splits the filename at every underscore ("_") and takes
                                                                                                        #the only the first 4 parts of the filename; this will be important
                                                                                                        #for naming output files according to which sample they came from;
                                                                                                        #modify this based on this format of your filenames
        echo "${name}"                                                                  #Print out the parts of the filename you copied in the previous line
        if [ -f "${name}_Halign.bam" ]; then            #Make sure mapping (.bam) output files don't exist already
                echo "exists; skipping..."                              #If they do exist, skip this particular sample so you don't overwrite
                                                                                                #your old output
        else
            	hisat2 -p 24 -q -x $REF -S "${name}.sam" -1 "${name}.fastp.trimmed_1P.fq.gz" -2 "${name}.fastp.trimmed_2P.fq.gz" -U "${name}.fastp.trimmed_1U.fq.gz" | samtools view -Sbo "${name}_Halign.bam" 
        fi
done
echo "Done!"


