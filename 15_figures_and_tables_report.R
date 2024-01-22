# Kristin Watnedal Olsen

library(ggplot2)

# Plot count of reads for step 4: quantification
counts <- data.frame(counts = c(22774, 36364, 18083, 2737,
                                22186, 35260, 17754, 2692,
                                22105, 34370, 17744, 2693,
                                22379, 36924, 17924, 2699,
                                22249, 36810, 17802, 2686,
                                22515, 38120, 17951, 2757), 
                     clone = c(rep("Paraclonal 1", 4), 
                               rep("Paraclonal 2", 4), 
                               rep("Paraclonal 3", 4),
                               rep("Parental 1", 4), 
                               rep("Parental 2", 4),  
                               rep("Parental 3", 4)),
                     type = rep(c("Genes", "Transcripts"), 12),
                     novel = rep(c("All", "All", "Novel", "Novel"), 6))
                    
p1 <- ggplot(counts, aes(x = factor(clone), y = counts, fill = novel)) +
  geom_bar(stat = "identity", position = "stack") +
  facet_wrap(~ type, ncol = 2) +
  scale_fill_manual(values = c("All" = "#CAD6DC", "Novel" = "#618395")) +
  labs(title = "", x = "", y = "Count of reads", fill = "") +
  scale_x_discrete(labels = c("Paraclonal 1" = "1", 
                              "Paraclonal 2" = "2",
                              "Paraclonal 3" = "3",
                              "Parental 1" = "1",
                              "Parental 2" = "2",
                              "Parental 3" = "3")) +
  theme_minimal() +
  theme(strip.text = element_text(size = 14, face = "bold"))
ggsave("4_quantification.png", height = 3, width = 8)

# Plot quality check: FPM (fragments per kilobasemillion)
fpm <- data.frame(fpm = c(1018482, 1019294, 1018611, 1009016, 1006333, 1065852,
                             974379.4, 913603.4, 970298.3, 923842.3, 965285.7, 931990.5),
                  clone = c(rep("Paraclonal 1", 2), 
                            rep("Paraclonal 2", 2), 
                            rep("Paraclonal 3", 2),
                            rep("Parental 1", 2), 
                            rep("Parental 2", 2),  
                            rep("Parental 3", 2)),
                  type = rep(c("Genes", "Transcripts"), 6),
                  culture = c(rep("Paraclonal", 6), rep("Parental", 6)))

p2 <- ggplot(fpm, aes(x = factor(clone), y = fpm, fill = culture)) +
  geom_bar(stat = "identity", position = "stack") +
  facet_wrap(~ type, ncol = 2) +
  scale_fill_manual(values = c("Paraclonal" = "#CAD6DC", "Parental" = "#618395")) +
  labs(title = "", x = "Replicate", y = "FPM (fragment per kilobasemillion)", fill = "") +
  scale_x_discrete(labels = c("Paraclonal 1" = "1", 
                              "Paraclonal 2" = "2",
                              "Paraclonal 3" = "3",
                              "Parental 1" = "1",
                              "Parental 2" = "2",
                              "Parental 3" = "3")) +
  scale_y_continuous(breaks = seq(0, 1200000, by = 250000)) +
  theme_minimal() +
  theme(strip.text = element_text(size = 14, face = "bold"))
p2
ggsave("fpm_quality_check.png", height = 3, width = 8)

