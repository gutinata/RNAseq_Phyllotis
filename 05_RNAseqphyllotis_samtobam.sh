#!/bin/bash
#SBATCH --job-name=sam_merge ##%x; %j is the job number
#SBATCH --output=/work/storzlab/gutinata88/Phyllotis/Outputs1/hisat/%x-%j.out
#SBATCH --error=/work/storzlab/gutinata88/Phyllotis/Outputs1/hisat/%x-%j.err
#SBATCH --mail-user=nguti@huskers.unl.edu
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --mem=250gb
#SBATCH --time=100:00:00 


module load samtools/1.9

cd /work/storzlab/gutinata88/Phyllotis/Outputs1/hisat

ls *.sam | while read file; do #Loop through all forward (read 1) raw data fastqs
        name=$(echo "${file}" | cut -d "." -f 1)                #Splits the filename at every dot (".") and takes
                                                                                                        #the only the first 4 parts of the filename; this will be important
                                                                                                        #for naming output files according to which sample they came from;
                                                                                                        #modify this based on this format of your filenames
        echo "${name}"                                                                  #Print out the parts of the filename you copied in the previous line
        if [ -f "${name}_Halign.bam" ]; then            #Make sure mapping (.bam) output files don't exist already
                echo "exists; skipping..."                              #If they do exist, skip this particular sample so you don't overwrite
                                                                                                #your old output
        else
            	samtools view -S -b -o "${name}_Halign.bam" "${name}.sam" 
        fi
done
echo "Done!"
