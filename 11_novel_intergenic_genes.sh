#!/usr/bin/env bash
#SBATCH --job-name=11_novel_intergenic_genes
#SBATCH --output=../out/11_novel_intergenic_genes.out
#SBATCH --error=../err/11_novel_intergenic_genes.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=8G
#SBATCH --time=4:00:0
#SBATCH --partition=pall

# Load modules
module load UHTS/Analysis/BEDTools/2.29.2

# List directories
BED_DIR=/data/users/kolsen/rna_seq/bed_files

# Create bed file with only novel intergenic genes using bedtools intersect
bedtools intersect -a $BED_DIR/novel_transcripts.bed -b $BED_DIR/annotated_transcripts.bed -v > $BED_DIR/novel_intergenic_transcripts.bed 

# Count number of novel intergenic transcripts
novel_transcripts=$(wc -l < $BED_DIR/novel_transcripts.bed)
novel_intergenic_transcripts=$(wc -l < $BED_DIR/novel_intergenic_transcripts.bed)
percentage=$(echo "scale=2; ($novel_intergenic_transcripts/$novel_transcripts) * 100" | bc)
echo "Number of all novel transcripts: $novel_transcripts"
echo "Number of novel intergenic transcripts : $novel_intergenic_transcripts"
echo "Percentage of novel intergeneic transcripts: $percentage %"



