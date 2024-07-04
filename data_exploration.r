# stats_df <- read.csv('admit_org_stats.csv', header = TRUE)
# curriculum_df <- read.csv('admit_org_curriculum.csv', header = TRUE)

# stats_curriculum_df <- merge(stats_df, curriculum_df, by = 'School')
# print(stats_curriculum_df)
# write.csv(stats_curriculum_df, 'admit_org_stats_curriculum.csv')
library(scales)
library(ggplot2)
library(httpgd)

df <- read.csv('admit_org_stats_curriculum.csv', header = TRUE)
df$Applications <- gsub("\\D+", "", df$Applications)
df$Rank <- gsub("\\D+", "", df$Rank)

df$Acceptance_rate <- as.numeric(as.numeric(df$Admits) / as.numeric(df$Applications))
print(df$Acceptance_rate)
df <- df[!is.na(df$Acceptance_rate),]

ggplot(df[which(df$PC_grades == 'P/F' | df$PC_grades == 'H/P/F'), ], aes(x = Acceptance_rate, y = PC_grades)) + 
    geom_text(aes(label = School), size = 3, position = position_jitter(seed = 2)) +
    geom_jitter(position = position_jitter(seed = 2))

## specifics
school_list_df <- df[which(df$Acceptance_rate > 0.07 & (df$PC_grades == 'P/F' | df$PC_grades == 'H/P/F') & (df$Internal_rank == 'No')), ]
print(school_list_df)

school_list_df <- df[which((df$PC_grades == 'P/F' | df$PC_grades == 'H/P/F') & (df$Internal_rank == 'No' | df$Internal_rank == '') ), ]
print(school_list_df)

school_list_df <- df[which((df$PC_grades == 'P/F' | df$PC_grades == 'H/P/F') & (df$Internal_rank == 'No' | df$Internal_rank == '') ), ]
print(school_list_df)
