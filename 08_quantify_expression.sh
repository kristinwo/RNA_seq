#!/usr/bin/env bash
#SBATCH --job-name=08_quantify_expression
#SBATCH --output=../out/08_quantify_expression.out
#SBATCH --error=../err/08_quantify_expression.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=8G
#SBATCH --time=4:00:0
#SBATCH --partition=pall
#SBATCH --array=0-5

# Load modules
module load UHTS/Analysis/HTSeq/0.9.1

# Directories and files
MERGED_GTF_FILE=/data/users/kolsen/rna_seq/gtf_files/merged/merged.gtf
BAM_FILES_DIR=/data/users/kolsen/rna_seq/bam_files
TSV_DIR=/data/users/kolsen/rna_seq/out/08_tsv

# List files
GTF_FILES=($GTF_FILES_DIR/*.gtf)
BAM_FILES=($BAM_FILES_DIR/sorted_*.bam)
GENE_TSV_FILES=($TSV_DIR/*gene.tsv)
TRANSCRIPT_TSV_FILES=($TSV_DIR/*transcript.tsv)

FILENAME=$(basename "${BAM_FILES[$SLURM_ARRAY_TASK_ID]}" .bam | sed 's/sorted_//')

# Quantify gene and transcriptome expression
htseq-count -f bam -s reverse ${BAM_FILES[$SLURM_ARRAY_TASK_ID]} $MERGED_GTF_FILE > $TSV_DIR/${FILENAME}_gene.tsv
htseq-count -f bam -s reverse -i transcript_id ${BAM_FILES[$SLURM_ARRAY_TASK_ID]} $MERGED_GTF_FILE > $TSV_DIR/${FILENAME}_transcript.tsv

# Count number of genes and transcripts in total
echo "Genes in $FILENAME:" $(awk '$2 > 0 {print $1}' ${GENE_TSV_FILES[$SLURM_ARRAY_TASK_ID]} | sort | uniq | wc -l)
echo "Transcripts in $FILENAME:" $(awk '$2 > 0 {print $1}' ${TRANSCRIPT_TSV_FILES[$SLURM_ARRAY_TASK_ID]} | sort | uniq | wc -l)

# Count number of novel genes and transcripts
echo "Novel genes  in $FILENAME:" $(awk '$2 > 0 {print $1}' ${GENE_TSV_FILES[$SLURM_ARRAY_TASK_ID]} | sort | uniq | grep -v 'ENS' | wc -l)
echo "Novel transcripts  in $FILENAME:" $(awk '$2 > 0 {print $1}' ${TRANSCRIPT_TSV_FILES[$SLURM_ARRAY_TASK_ID]} | sort | uniq | grep -v 'ENS' | wc -l)
