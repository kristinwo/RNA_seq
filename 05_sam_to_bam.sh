#!/usr/bin/env bash
#SBATCH --job-name=05_sam_to_bam
#SBATCH --output=../out/05_sam_to_bam.out
#SBATCH --error=../err/05_sam_to_bam.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=8G
#SBATCH --time=4:00:0
#SBATCH --partition=pall
#SBATCH --array=0-5

# Load modules
module load UHTS/Analysis/samtools/1.10

# Directories
SAM_FILE_DIR=/data/users/kolsen/rna_seq/sam_files
BAM_FILE_DIR=/data/users/kolsen/rna_seq/bam_files

# List all sam files should be converted
FILES=($SAM_FILE_DIR/*.sam)

# Get the filename of the sam-files
FILENAME=$(basename "${FILES[$SLURM_ARRAY_TASK_ID]}" .sam)

# Convert sam-file to bam-file
samtools view -b -o $BAM_FILE_DIR/$FILENAME.bam ${FILES[$SLURM_ARRAY_TASK_ID]}
# Sort bam-files
samtools sort -O bam $BAM_FILE_DIR/$FILENAME.bam -o $BAM_FILE_DIR/sorted_$FILENAME.bam
# Index bam-files
samtools index $BAM_FILE_DIR/sorted_$FILENAME.bam