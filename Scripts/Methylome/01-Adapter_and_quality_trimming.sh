#!/bin/bash

#SBATCH --job-name=trimgal								# Job name.
#SBATCH --output=trimgalore.log							# Standard output and error log.
#SBATCH --partition=short								# Partition (queue)
#SBATCH --ntasks=1									# Run on one mode.
#SBATCH --cpus-per-task=1								# Number of tasks.
#SBATCH --time=1-00:00:00								# Time limit days-hrs:min:sec.
#SBATCH --mem=10gb									# Job memory request.


###### MODULES
module load python/3.8

###### VARIABLES
WD_lib="/storage/ncRNA/Projects/CUCUMBER_HSVd/Methylome/Libraries"

###### PIPELINE
mkdir -p $WD_lib/02-clean_data
list_of_files="$(find $WD_lib | grep "raw_data" | grep "fq.gz" | sort)"
length=$(echo $list_of_files | tr " " "\n" | wc -l)

COUNTER=1
while [ $COUNTER -lt $(($length)) ]; do
	R1="$(echo $list_of_files | cut -d" " -f$COUNTER)"
	R2="$(echo $list_of_files | cut -d" " -f$(($COUNTER+1)))"
	prefix="$(echo $R1 | cut -d"/" -f9)"
	echo -e "\n\n"$prefix
	trim_galore \
		--paired \
		--phred33 \
		--quality 20 \
		--length 20 \
		--clip_R1 10 \
		--clip_R2 10 \
		-a GATCGGAAGAGCACACGTCTGAACTCCAGTCACATCACGATCTCGTATGCCGTCTTCTGCTTG \
		-a2 AATGATACGGCGACCACCGAGATCTACACTCTTTCCCTACACGACGCTCTTCCGATCT \
		-o $WD_lib/02-clean_data/$prefix $R1 $R2
	let "COUNTER=COUNTER+2"
done

