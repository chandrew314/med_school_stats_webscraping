docs_df <- read.csv('2021_med_school_post_ii_stats.csv', header = TRUE)

merge_df <- read.csv('admit_docs_merged.csv', header = TRUE)

merge_df[which(merge_df$USNWR.Ranking.Research == ''), ] <- NA
nrow(merge_df[!is.na(merge_df$Total.apps), ])
