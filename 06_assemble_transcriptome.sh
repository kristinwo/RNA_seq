#!/usr/bin/env bash
#SBATCH --job-name=06_assemble_transcriptome
#SBATCH --output=06_assemble_transcriptome.out
#SBATCH --error=06_assemble_transcriptome.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=8G
#SBATCH --time=4:00:0
#SBATCH --partition=pall
#SBATCH --array=0-5

# Load modules
module load UHTS/Aligner/stringtie/1.3.3b

# Directories
BAM_FILE_DIR=/data/users/kolsen/rna_seq/bam_files
REFERENCE_FILE_DIR=/data/users/kolsen/rna_seq/reference_files
GTF_FILES_DIR=/data/users/kolsen/rna_seq/gtf_files

# List all bam files should be assambled
FILES=($BAM_FILE_DIR/sorted_*.bam)

# Get the filename of the sam-files
FILENAME=$(basename "${FILES[$SLURM_ARRAY_TASK_ID]}" .bam | sed 's/sorted_//')

stringtie -o $GTF_FILES_DIR/$FILENAME.gtf -p 6 --rf -G $REFERENCE_FILE_DIR/gencode.v44.annotation.gff3 ${FILES[$SLURM_ARRAY_TASK_ID]}