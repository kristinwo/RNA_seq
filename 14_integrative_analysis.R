# Kristin Watnedal Olsen

library(tidyverse)

# Load data frame of transcripts from DESeq2 analysis
transcripts <- readRDS("transcripts.rds")

# Load bed files of transcripts that are correclty annotated for 3' and 5'
three_prime <- read.table("./table_data/3_prime_correct_annotation.bed")
five_prime <- read.table("./table_data/5_prime_correct_annotation.bed")

# Add colnames
colnames_bed <- c("chromosome", "start_pos", "stop_pos", "transcript_id", "something", "strand_direction")
colnames(three_prime) <- colnames_bed
colnames(five_prime) <- colnames_bed

# Add 5' and 3' columns (TRUE if overlap)
transcripts$three_prime <- NA
transcripts$five_prime <- NA
for (transcript in transcripts$transcript_id) {
  if (grepl("MSTRG", transcript)) {
    if (transcript %in% three_prime$transcript_id) {
      transcripts$three_prime[transcripts$transcript_id == transcript] <- TRUE
    } else {
      transcripts$three_prime[transcripts$transcript_id == transcript] <- FALSE
    }
  }
  if (grepl("MSTRG", transcript)) {
    if (transcript %in% five_prime$transcript_id) {
      transcripts$five_prime[transcripts$transcript_id == transcript] <- TRUE
    } else {
      transcripts$five_prime[transcripts$transcript_id == transcript] <- FALSE
    }
  }
}


# Load bed file of novel transcripts that are integenic
intergenic_transcripts <- read.table("./table_data/novel_intergenic_transcripts.bed")
colnames_bed <- c("chromosome", "start_pos", "stop_pos", "transcript_id", "something", "strand_direction")
colnames(intergenic_transcripts) <- colnames_bed #Add colnames

# Add intergenic region column
transcripts$intergenic <- NA
for (transcript in transcripts$transcript_id) {
  if (grepl("MSTRG", transcript)) {
    if (transcript %in% intergenic_transcripts$transcript_id) {
      transcripts$intergenic[transcripts$transcript_id == transcript] <- TRUE
    } else {
      transcripts$intergenic[transcripts$transcript_id == transcript] <- FALSE
    }
  }
}

# Load file for protein coding potentials
protein_coding_potential <- read.table("./table_data/protein_coding_potential")

# Add column for transcript_id to protein coding potential data frame
protein_coding_potential$transcript_id <- sub("::.*", "", rownames(protein_coding_potential))

# Add protein coding potential, PC potential >= 0.346 indicates protein coding
transcripts$protein_coding <- NA
for (transcript in transcripts$transcript_id) {
  if (grepl("MSTRG", transcript)) {
    if (transcript %in% protein_coding_potential$transcript_id) {
      transcripts$protein_coding[transcripts$transcript_id == transcript] <- protein_coding_potential$coding_prob[protein_coding_potential$transcript_id == transcript]
    }
  }
}

# Save table of transcripts
write.csv(transcripts, file = "all_transcripts.csv", row.names = FALSE)

# Filter out the novel transcripts
novel_transcripts <- transcripts %>% 
  filter(biotype == "novel")

# Count 3' and 5' annotations, intergenic transcripts and protein coding
three_prime_annotations <- sum(novel_transcripts$three_prime, na.rm = TRUE)
five_prime_annotations <- sum(novel_transcripts$five_prime, na.rm = TRUE)
intergenic <- sum(novel_transcripts$intergenic, na.rm = TRUE)
protein_coding <- sum(novel_transcripts$protein_coding > 0.364, na.rm = TRUE)

integrative_analysis <- data.frame(category = c("3' annotations", "5' annotations",
                                                "Intergenic", "Protein coding"),
                                   number = c(three_prime_annotations, five_prime_annotations,
                                              intergenic, protein_coding))

integrative_analysis$percentage <- (integrative_analysis$number/11656) *100

#Plot percentage of 3' and 5' annotations, intergenic transcripts and protein coding transcripts
p1 <- ggplot(integrative_analysis, aes(x=category, y=percentage)) +
  geom_bar(stat = "identity", position = "stack", fill = "#618395") +
  labs(title = "", x="", y = "Percentage [%]") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  scale_y_continuous(limits = c(0,100))
ggsave("percentage.png", width = 2, height = 3)
p1  
  
# Filter novel transcript table to be included in report
novel_transcripts <- novel_transcripts %>% 
  filter(intergenic == TRUE,
         qval < 0.1,
         log2FC > 1 | log2FC < -1) %>% 
  arrange(qval)

         #& three_prime == TRUE 
         #& five_prime == TRUE 
         #& intergenic == TRUE
         #& protein_coding < 0.364
         #& qval < 0.1)


