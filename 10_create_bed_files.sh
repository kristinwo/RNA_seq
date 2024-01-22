#!/usr/bin/env bash
#SBATCH --job-name=10_integrative_analysis
#SBATCH --output=../out/10_integrative_analysis.out
#SBATCH --error=../err/10_integrative_analysis.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=8G
#SBATCH --time=4:00:0
#SBATCH --partition=pall

# List directories
GTF_DIR=/data/users/kolsen/rna_seq/gtf_files/merged
BED_DIR=/data/users/kolsen/rna_seq/bed_files

# Create bed file - all transcripts
awk '$3 == "transcript" && $1 ~ /chr/ {gsub(/;/,"",$12) ; print $1"\t"$4"\t"$5"\t"$12"\t"$6"\t"$7}' $GTF_DIR/merged.gtf > $BED_DIR/all_transcripts.bed 

# Create bed file - novel transcripts
grep 'ENST' $BED_DIR/all_transcripts.bed > $BED_DIR/annotated_transcripts.bed  

# Create bed file - annotated transcripts
grep 'MSTR' $BED_DIR/all_transcripts.bed > $BED_DIR/novel_transcripts.bed  

# Create bed files for 3' and 5' ends annotations
awk '{if($6=="+") print $1"\t"($2-50)"\t"($2+50)"\t"$4"\t"$5"\t"$6 ; else print $1"\t"($3-50)"\t"($3+50)"\t"$4"\t"$5"\t"$6}' $BED_DIR/novel_transcripts.bed > $BED_DIR/novel_transcripts_5.bed
awk '{if($6=="+") print $1"\t"($3-50)"\t"($3+50)"\t"$4"\t"$5"\t"$6 ; else print $1"\t"($2-50)"\t"($2+50)"\t"$4"\t"$5"\t"$6}' $BED_DIR/novel_transcripts.bed > $BED_DIR/novel_transcripts_3.bed