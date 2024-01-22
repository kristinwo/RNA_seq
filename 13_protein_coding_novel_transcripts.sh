#!/usr/bin/env bash
#SBATCH --job-name=13_protein_coding_novel_transcripts
#SBATCH --output=../out/13_protein_coding_novel_transcripts.out
#SBATCH --error=../err/13_protein_coding_novel_transcripts.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=8G
#SBATCH --time=4:00:0
#SBATCH --partition=pall

# Load modules
module load UHTS/Analysis/BEDTools/2.29.2
module load SequenceAnalysis/GenePrediction/cpat/1.2.4

# List directories
BED_DIR=/data/users/kolsen/rna_seq/bed_files
REF_DIR=/data/courses/rnaseq_course/lncRNAs/Project1/references
FASTA_DIR=/data/users/kolsen/rna_seq/fasta_files
OUT_DIR=/data/users/kolsen/rna_seq/out

# Make fasta file from novel transcripts
bedtools getfasta -s -fi $REF_DIR/GRCh38.genome.fa -bed $BED_DIR/novel_transcripts.bed -fo $FASTA_DIR/novel_transcripts.fa -name

# Use CPAT to evaluate protein coding potential
cpat.py -x $REF_DIR/Human_Hexamer.tsv -d $REF_DIR/Human_logitModel.RData -g $FASTA_DIR/novel_transcripts.fa -o $OUT_DIR/protein_coding_potential

# Run resulting R script to create protein coding potential table
Rscript $OUT_DIR/protein_coding_potential.r

# Calculate percentage of protein coding novel transcripts (cutoff = 0.364)
protein_coding=$(awk '$5 >= 0.364' $OUT_DIR/protein_coding_potential | wc -l)
all_transcripts=$(wc -l < $OUT_DIR/protein_coding_potential)
percentage=$(echo "scale=2; ($protein_coding/$all_transcripts) * 100" | bc)
echo "Number of protein coding novel transcripts: $protein_coding"
echo "Number of all novel transcripts: $all_transcripts"
echo "Percentage of protein coding novel transcripts: $percentage"