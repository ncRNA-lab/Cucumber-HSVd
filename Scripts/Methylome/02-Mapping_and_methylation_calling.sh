#!/bin/bash

#SBATCH --job-name=bismark						# Job name.
#SBATCH --output=bismark.log						# Standard output and error log.
#SBATCH --partition=short						# Partition (queue)
#SBATCH --ntasks=1							# Run on one mode. 
#SBATCH --cpus-per-task=8						# Number of tasks. 
#SBATCH --time=1-00:00:00						# Time limit days-hrs:min:sec.
#SBATCH --mem=25gb							# Job memory request.


###### MODULES
module load python/3.8
module load anaconda/anaconda3

###### VARIABLES
WD_met="/storage/ncRNA/Projects/CUCUMBER_HSVd/Methylome"
WD_bis="/storage/ncRNA/Softwares/Bismark-0.23.0"

###### CREATE DIRECTORY
mkdir -p $WD_met"/Results/01-Bismark"
mkdir -p $WD_met"/Results/01-Bismark/01-Genome_preparation"
mkdir -p $WD_met"/Results/01-Bismark/02-Alignment"
mkdir -p $WD_met"/Results/01-Bismark/03-Deduplicate"
mkdir -p $WD_met"/Results/01-Bismark/04-Methylation_extractor"

###### PIPELINE

#### BISMARK: GENOME PREPARATION (INDEXING)

echo -e "\n\n--------------------------------------------------"
echo -e "--------------- GENOME PREPARATION ---------------"
echo -e "--------------------------------------------------\n\n"

cp $WD_met"/Additional_info/Genome/ChineseLong_genome_v3.fa" $WD_met"/Results/01-Bismark/01-Genome_preparation/"
bismark_genome_preparation --verbose $WD_met"/Results/01-Bismark/01-Genome_preparation/"

#### BISMARK: ALIGNMENT

echo -e "\n\n--------------------------------------------------"
echo -e "------------------- ALIGNMENT --------------------"
echo -e "--------------------------------------------------\n\n"

cd $WD_met"/Libraries/02-clean_data"

cp $WD_bis"/bismark" ./
list_of_files="$(find . | grep "fq.gz" | grep -v ".txt" | sort)"
length=$(echo $list_of_files | tr " " "\n" | wc -l)
COUNTER=1

while [ $COUNTER -lt $(($length)) ]; do
        R1="$(echo $list_of_files | cut -d" " -f$COUNTER)"
        R2="$(echo $list_of_files | cut -d" " -f$(($COUNTER+1)))"
	./bismark $WD_met"/Results/01-Bismark/01-Genome_preparation/" -1 $R1 -2 $R2 -N 1 -L 25 --output_dir $WD_met"/Results/01-Bismark/02-Alignment/" --multicore 8
	let "COUNTER=COUNTER+2"
done

rm bismark

#### BISMARK: DEDUPLICATE

echo -e "\n\n--------------------------------------------------"
echo -e "------------------ DEDUPLICATE -------------------"
echo -e "--------------------------------------------------\n\n"

cd $WD_met"/Results/01-Bismark/02-Alignment"

cp $WD_bis"/deduplicate_bismark" ./
lista="$(ls *.bam)"

for bam in $lista;
do
	./deduplicate_bismark --bam $bam --output_dir $WD_met"/Results/01-Bismark/03-Deduplicate/"
done

rm deduplicate_bismark

#### BISMARK: METHYLATION EXTRACTOR

echo -e "\n\n--------------------------------------------------"
echo -e "------------- METHYLATION EXTRACTOR --------------"
echo -e "--------------------------------------------------\n\n"

cd $WD_met"/Results/01-Bismark/03-Deduplicate"

lista="$(ls *.bam)"
cp $WD_bis"/bismark_methylation_extractor" ./
cp $WD_bis"/bismark2bedGraph" ./
cp $WD_bis"/coverage2cytosine" ./

for bam in $lista;
do
	./bismark_methylation_extractor --multicore 8 --comprehensive --no_overlap --cytosine_report --bedGraph --CX $bam --genome_folder $WD_met"/Results/01-Bismark/01-Genome_preparation/" --output $WD_met"/Results/01-Bismark/04-Methylation_extractor/"
done

rm bismark_methylation_extractor
rm bismark2bedGraph
rm coverage2cytosine


