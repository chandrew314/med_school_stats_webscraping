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

#######################################################
## figure for which state's public schools have the most in-state bias
#######################################################
merge_df <- read.csv('admit_docs_merged.csv', header = TRUE)
merge_df$Applications <- gsub("\\D+", "", merge_df$Applications)
merge_df$Public.Private <- factor(merge_df$Public.Private)
merge_df$Acceptance_rate <- as.numeric(as.numeric(merge_df$Admits) / as.numeric(merge_df$Applications))

## filter by only public schools
public_df <- merge_df[which(merge_df$Public.Private == 'Public'), ]

## metric for in-state bias = school-specific in-state acceptance rate / average in-state acceptance rate for all public schools
avg_accep_instate_public <- (sum(public_df$IS.Accepted) / sum(public_df$Apps.IS)) * 100
public_df$IS_bias_public <- public_df$IS_A / avg_accep_instate_public
public_df$State <- factor(public_df$State)

## plot In-state acceptance rate / Avg. in-state acceptance rate among public schools and acceptance rate
p2 <- ggplot(public_df, aes(x = IS_bias_public, y = State, colour = Acceptance_rate)) + 
        geom_point(alpha = 0.8, size = 1.5) + 
        geom_text_repel(
            data = public_df,
            aes(label = School),
            min.segment.length = 0,
            force = 30,
            max.iter = 5000,
            max.overlaps = Inf
        ) +
        # scale_x_log10(breaks = trans_breaks("log10", function(x) 10^x),
        #     labels = trans_format("log10", math_format(10^.x))) +
        # scale_y_log10(breaks = trans_breaks("log10", function(x) 10^x),
        #     labels = trans_format("log10", math_format(10^.x))) +
        scale_color_gradientn(colors = natparks.pals("Denali"), name = 'Acceptance Rate') + 
        scale_y_discrete(limits = rev(levels(public_df$State))) +
        labs(x = 'In-state acceptance rate / Avg. in-state acceptance rate among public schools') 

# ggsave('myplot2.jpeg', p2, width = 13, height = 10, dpi = 300)

## plot
p3 <- ggplot(public_df, aes(x = IS_bias_public, y = State, colour = log10(IS_A.OOS_A))) + 
        geom_point(alpha = 0.8, size = 1.5) + 
        geom_text_repel(
            data = public_df,
            aes(label = School),
            min.segment.length = 0,
            force = 30,
            max.iter = 5000,
            max.overlaps = Inf
        ) +
        # scale_x_log10(breaks = trans_breaks("log10", function(x) 10^x),
        #     labels = trans_format("log10", math_format(10^.x))) +
        # scale_y_log10(breaks = trans_breaks("log10", function(x) 10^x),
        #     labels = trans_format("log10", math_format(10^.x))) +
        scale_color_gradientn(colors = natparks.pals("SmokyMtns"), name = 'log10(In-state bias)', labels = scales::label_math()) +
        scale_y_discrete(limits = rev(levels(public_df$State))) +
        labs(x = 'In-state acceptance rate / Avg. in-state acceptance rate among public schools') 

# ggsave('myplot3.jpeg', p3, width = 13, height = 10, dpi = 300)


#######################################################
## figure for which state's private schools have the most in-state bias
#######################################################
merge_df <- read.csv('admit_docs_merged.csv', header = TRUE)
merge_df$Applications <- gsub("\\D+", "", merge_df$Applications)
merge_df$Public.Private <- factor(merge_df$Public.Private)
merge_df$Acceptance_rate <- as.numeric(as.numeric(merge_df$Admits) / as.numeric(merge_df$Applications))

## filter by only public schools
private_df <- merge_df[which(merge_df$Public.Private == 'Private'), ]

## metric for in-state bias = school-specific in-state acceptance rate / average in-state acceptance rate for all public schools
avg_accep_instate_private <- (sum(private_df$IS.Accepted) / sum(private_df$Apps.IS)) * 100
private_df$IS_bias_private <- private_df$IS_A / avg_accep_instate_private
private_df$State <- factor(private_df$State)

## plot In-state acceptance rate / Avg. in-state acceptance rate among public schools and acceptance rate
p2 <- ggplot(private_df, aes(x = IS_bias_private, y = State, colour = Acceptance_rate)) + 
        geom_point(alpha = 0.8, size = 1.5) + 
        geom_text_repel(
            data = private_df,
            aes(label = School),
            min.segment.length = 0,
            force = 30,
            max.iter = 5000,
            max.overlaps = Inf
        ) +
        # scale_x_log10(breaks = trans_breaks("log10", function(x) 10^x),
        #     labels = trans_format("log10", math_format(10^.x))) +
        # scale_y_log10(breaks = trans_breaks("log10", function(x) 10^x),
        #     labels = trans_format("log10", math_format(10^.x))) +
        scale_color_gradientn(colors = natparks.pals("Denali"), name = 'Acceptance Rate') + 
        scale_y_discrete(limits = rev(levels(private_df$State))) +
        labs(x = 'In-state acceptance rate / Avg. in-state acceptance rate among private schools') 

# ggsave('myplot2.jpeg', p2, width = 13, height = 10, dpi = 300)

## plot
p3 <- ggplot(private_df, aes(x = IS_bias_private, y = State, colour = log10(IS_A.OOS_A))) + 
        geom_point(alpha = 0.8, size = 1.5) + 
        geom_text_repel(
            data = private_df,
            aes(label = School),
            min.segment.length = 0,
            force = 30,
            max.iter = 5000,
            max.overlaps = Inf
        ) +
        # scale_x_log10(breaks = trans_breaks("log10", function(x) 10^x),
        #     labels = trans_format("log10", math_format(10^.x))) +
        # scale_y_log10(breaks = trans_breaks("log10", function(x) 10^x),
        #     labels = trans_format("log10", math_format(10^.x))) +
        scale_color_gradientn(colors = natparks.pals("SmokyMtns"), name = 'log10(In-state bias)', labels = scales::label_math()) +
        scale_y_discrete(limits = rev(levels(private_df$State))) +
        labs(x = 'In-state acceptance rate / Avg. in-state acceptance rate among private schools') 

# ggsave('myplot3.jpeg', p3, width = 13, height = 10, dpi = 300)