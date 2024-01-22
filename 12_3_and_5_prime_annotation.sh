#!/usr/bin/env bash
#SBATCH --job-name=12_3_and_5_prime_annotation
#SBATCH --output=../out/12_3_and_5_prime_annotation.out
#SBATCH --error=../err/12_3_and_5_prime_annotation.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=8G
#SBATCH --time=4:00:0
#SBATCH --partition=pall

# Load modules
module load UHTS/Analysis/BEDTools/2.29.2

# List directories
BED_DIR=/data/users/kolsen/rna_seq/bed_files
REF_DIR=/data/courses/rnaseq_course/lncRNAs/Project1/references

# Validate correct 3' annotation
bedtools intersect -s -wa -a $BED_DIR/novel_transcripts_3.bed -b $REF_DIR/atlas.clusters.2.0.GRCh38.96.bed > $BED_DIR/3_prime_correct_annotation.bed
all_novel_3=$(wc -l < $BED_DIR/novel_transcripts_3.bed)
correct_novel_3=$(wc -l < $BED_DIR/3_prime_correct_annotation.bed)
percentage=$(echo "scale=2; ($correct_novel_3/$all_novel_3) * 100" | bc)
echo "Number of novel trancripts in 3' direction: $all_novel_3"
echo "Number of correctly annotated novel transcripts in 3' direction : $correct_novel_3"
echo "Percentage of correctly annotated novel transcripts in 3' direction : $percentage %"

# Validate correct 5' annotation
bedtools intersect -s -wa -a $BED_DIR/novel_transcripts_5.bed -b $REF_DIR/refTSS_v4.1_human_coordinate.hg38.bed > $BED_DIR/5_prime_correct_annotation.bed
all_novel_5=$(wc -l < $BED_DIR/novel_transcripts_5.bed)
correct_novel_5=$(wc -l < $BED_DIR/5_prime_correct_annotation.bed)
percentage=$(echo "scale=2; ($correct_novel_5/$all_novel_5) * 100" | bc)
echo "Number of novel trancripts in 5' direction: $all_novel_5"
echo "Number of correctly annotated novel transcripts in 5' direction : $correct_novel_5"
echo "Percentage of correctly annotated novel transcripts in 5' direction : $percentage %"
