#!/usr/bin/env bash
#SBATCH --job-name=07_find_exons_transcripts_genes
#SBATCH --output=../out/07_find_exons_transcripts_genes.out
#SBATCH --error=../err/07_find_exons_transcripts_genes.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=8G
#SBATCH --time=4:00:0
#SBATCH --partition=pall

MERGED_GTF_FILE=/data/users/kolsen/rna_seq/gtf_files/merged/merged.gtf

# Parse gtf file?

# Count exons
echo "Number of exons: $(awk '$3 == "exon"' $MERGED_GTF_FILE | wc -l)"

# Count transcripts
echo "Numer of transcripts: $(awk '$3 == "transcript" {print $12}' $MERGED_GTF_FILE | sort | uniq | wc -l)" # maybe not uniq and sort here?

# Count genes
echo "Number of genes: $(awk '$3 == "exon" {print $10}' $MERGED_GTF_FILE | sort | uniq | wc -l)" # maybe not uniq and sort here?

# Count novel transcripts
echo "Numer of novel transcripts: $(awk '$3 == "transcript" {print $12}' $MERGED_GTF_FILE | sort | uniq | grep -v 'ENST' | wc -l)"

# Count novel genes (does not have a GENCODE identifier)
echo "Number of novel genes: $(awk '$3 == "exon" {print $10}' $MERGED_GTF_FILE | sort | uniq | grep -v 'ENSG' | wc -l)"

# Count single exon transcripts
echo "Numer of single exon transcripts: $(awk '$3 == "exon" {print $12}' $MERGED_GTF_FILE | sort | uniq -c | awk '$1 == 1' | wc -l)"

# Count single exon genes
echo "Number of single exon genes: $(awk '$3 == "exon" {print $10}' $MERGED_GTF_FILE | sort | uniq -c | awk '$1 == 1' | wc -l)"
