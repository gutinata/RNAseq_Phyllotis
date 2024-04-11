#!/bin/bash
#SBATCH --job-name=trimmomatic_loop
#SBATCH --output=/work/storzlab/gutinata88/Phyllotis/try_trimmomatic/out/%x-%j.out
#SBATCH --mail-user=nguti@huskers.unl.edu
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=250000
#SBATCH --time=59:30:00 # How long should they run
## Above is all information for SLURM. It should all appear at the top of
## the script before your commands to run. SLURM understands lines
## beginning with ## as a comment.


### lines from 1-14 are all necessary if you are running your script using slurm. If not, just remove them from the file

## ------------------------------------------------
## Set environment
## ------------------------------------------------

DATA_DIR=/work/storzlab/gutinata88/Phyllotis/00_fastq  # this is the directory that you want to run the script (path to the dir that has your fastqfiles)

## Command(s) to run:

#source /work/storzlab/gutinata88/Phyllotis/Programs  ## I saved the trimmonatic program in this biotools package in conda, if you don't know how (or why) to do it just ignore these two lines and install it directly to your base
#conda activate biotools ## to install it directly using conda follow this https://anaconda.org/bioconda/trimmomatic
module load trimmomatic/0.39


##trim the junk off your reads. the input will be the paired end files, and the output is paired R1, pairedR2, and unpaired R1 and R2
##any reads that fully overlap R1 and R2 will ONLY be kept in the R1 file, and R2 is usually junk, so I align paired reads and only unpaired R1 downstream
##loop from EK jan 19 2021
##for multiple files in nested folders use *RAW_DATA/*_1.fq.gz

cd $DATA_DIR

ls *R1_001.fastq.gz | while read file; do #Loop through all forward (read 1) raw data fastqs
        name=$(echo "${file}" | cut -d "_" -f 1)                #Splits the filename at every underscore ("_") and takes
                                                                                                        #the first 4 parts of the filename; this will be important
                                                                                                        #for naming output files according to which sample they came from;
                                                                                                        #modify this based on this format of your filenames
        echo "${name}"                                                                  #Print out the parts of the filename you copied in the previous line
        if [ -f "${name}.fastp.trimmed_1P.fq.gz" ]; then                #Make sure trimmomatic output files don't exist already
                echo "exists; skipping..."                              #If they do exist, skip this particular sample so you don't overwrite
                                                                                                #your old trimmomatic outputs
        else
            	#Below is the actual trimmomatic code
                ###-trimlog "${name}.trimmomatic.log" will make a trimmomatic log file with your sample name in the filename
                ###"${file}" is the forward read raw data fastq you read in at the beginning of the loop
                ###"${name}_2.fq.gz" should be your reverse reads raw data file; may need to edit this slightly depending on how your files are named
                ###-baseout "${name}.trimmed.fq.gz" tells trimmomatic to include <sample_name>.trimmed to all fastq output files
                ## ILLUMINACLIP: refers to the location in my server where the adapters that should be used to trimming the data are (I will try to send it to you)
                trimmomatic PE -threads 8 -phred33 -trimlog \
                        "${name}.trimmomatic.log" "${file}" "${name}_R2_001.fastq.gz" \
                        -baseout "${name}.fastp.trimmed.fq.gz" \
                        ILLUMINACLIP:/work/storzlab/gutinata88/Phyllotis/Illumina_clips/TruSeq3-PE.fa:2:30:10:8:TRUE LEADING:3 TRAILING:3 SLIDINGWINDOW:5:20 MINLEN:36
        fi
done
echo "Done!"    #I like to end all my scripts this way; sometimes there are no obvious error messages
                                #but your program stopped partway through, so this will let you know it got all the way
                                #through and exited the loop if you see it get printed out
