# stats_df <- read.csv('admit_org_stats.csv', header = TRUE)
# curriculum_df <- read.csv('admit_org_curriculum.csv', header = TRUE)

# stats_curriculum_df <- merge(stats_df, curriculum_df, by = 'School')
# print(stats_curriculum_df)
# write.csv(stats_curriculum_df, 'admit_org_stats_curriculum.csv')
library(scales)
library(ggplot2)
library(httpgd)
library(data.table)
library(ggrepel)
library(NatParksPalettes)

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
# print(school_list_df)

school_list_df <- df[which((df$PC_grades == 'P/F' | df$PC_grades == 'H/P/F') & (df$Internal_rank == 'No' | df$Internal_rank == '') ), ]
# print(school_list_df)

school_list_df <- df[which((df$PC_grades == 'P/F' | df$PC_grades == 'H/P/F') & (df$Internal_rank == 'No' | df$Internal_rank == '') ), ]
# print(school_list_df)


## Using IS vs OOS acceptance data
merge_df <- read.csv('admit_docs_merged.csv', header = TRUE)
merge_df$Applications <- gsub("\\D+", "", merge_df$Applications)
merge_df$Public.Private <- factor(merge_df$Public.Private)

# merge_df <- merge_df[which(merge_df$Public.Private == 'Public'), ]
merge_df$Acceptance_rate <- as.numeric(as.numeric(merge_df$Admits) / as.numeric(merge_df$Applications))
merge_df <- merge_df[!is.na(merge_df$IS_A.OOS_A),]


p1 <- ggplot(merge_df, aes(x = IS_A.OOS_A, y = Acceptance_rate, colour = Public.Private)) + 
        geom_point(alpha = 0.8, size = 1.5) + 
        geom_text_repel(
            data = merge_df,
            aes(label = School),
            min.segment.length = 0,
            force = 30,
            max.iter = 5000,
            max.overlaps = Inf
        ) +
        scale_x_log10(breaks = trans_breaks("log10", function(x) 10^x),
            labels = trans_format("log10", math_format(10^.x))) +
        scale_y_log10(breaks = trans_breaks("log10", function(x) 10^x),
            labels = trans_format("log10", math_format(10^.x))) +
        scale_color_manual(values = natparks.pals("Saguaro", 2), name = 'Public/Private') + 
        labs(x = 'log10(in-state acceptance rate / out-of-state acceptance rate)', y = 'log10(Acceptance rate)') 

# ggsave('myplot.jpeg', p1, width = 15, height = 10, dpi = 300)
