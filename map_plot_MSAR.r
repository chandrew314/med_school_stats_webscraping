#######################################################
## figure for RF ML prediction of which schools are OOS friendly
#######################################################
library(ggplot2)
library(cowplot)
library(usmap)
library(sf)

predict_df <- read.csv('OOS_friendly_RF_model_prediction_MSAR.csv', header = TRUE)

# Fix Geisel longitude
predict_df[predict_df$School == 'Geisel', 'longitude'] <- -72.28507631692145

## missing AK bc no schools are in Alaska
west_list <- c('CA', 'OR', 'WA', 'NV', 'AZ', 'UT', 'NM', 'CO', 'WY', 'ID', 'MT', 'HI')
# northeast_list <- c('ME', 'VT', 'NH', 'MA', 'RI', 'CT', 'NY', 'NJ', 'PA')
midwest_list <- c('ND', 'SD', 'NE', 'KS', 'MO', 'IA', 'MN', 'WI', 'IL', 'MI', 'IN', 'OH')
south_list <- c('OK', 'TX', 'AR', 'LA', 'MS', 'TN', 'KY', 'AL', 'GA', 'FL')
midatlantic_list <- c('NY', 'PA', 'NJ')
newengland_list <- c('ME', 'NH', 'VT', 'MA', 'CT', 'RI')
southatlantic_list <- c('MD', 'DE', 'DC', 'VA', 'WV', 'NC', 'SC')

# not_east_list <- c(west_list, midwest_list, south_list)
# east_coast_list <- c(midatlantic_list, newengland_list, southatlantic_list)

## assign regions to states
# predict_df$region <- NA
# predict_df$region[predict_df$State %in% west_list] <- 'west'
# predict_df$region[predict_df$State %in% midwest_list] <- 'midwest'
# predict_df$region[predict_df$State %in% south_list] <- 'south'
# predict_df$region[predict_df$State %in% midatlantic_list] <- 'midatlantic'
# predict_df$region[predict_df$State %in% newengland_list] <- 'new england'
# predict_df$region[predict_df$State %in% southatlantic_list] <- 'south atlantic'

predict_df <- sf::st_as_sf(predict_df, 
                        coords = c("longitude", "latitude"),
                        crs = 4269)

transformed_df <- usmap_transform(predict_df)

### Plot US map

plot_map <- function(df, region_list) {
    map <- plot_usmap(regions = 'states',
        fill = "yellow", alpha = 0.25,
        include = region_list,
        labels = TRUE) +
        geom_sf(data = transformed_df[which(transformed_df$State %in% region_list), ], aes(color = .pred_class)) +
        ggrepel::geom_label_repel(data = transformed_df[which(transformed_df$State %in% region_list), ],
            aes(label = School, geometry = geometry, color = .pred_class),
            size = 3, alpha = 0.8,
            label.r = unit(0.5, "lines"), label.size = 0.3,
            segment.color = "black", segment.size = 0.5,
            stat = "sf_coordinates", seed = 1002,
            max.overlaps = 30,
            force = 30) +
            scale_color_manual(values=c("#F8766D", "#00BA38"), name = 'OOS friendly?')
    return(map)
}

### Plot regions
west <- plot_map(transformed_df, west_list)
midwest <- plot_map(transformed_df, midwest_list)
south <- plot_map(transformed_df, south_list)
midatlantic <- plot_map(transformed_df, midatlantic_list)
newengland <- plot_map(transformed_df, newengland_list)
southatlantic <- plot_map(transformed_df, southatlantic_list)

get_legend_35 <- function(plot) {
    # return all legend candidates
    legends <- get_plot_component(plot, "guide-box", return_all = TRUE)
    # find non-zero legends
    nonzero <- vapply(legends, \(x) !inherits(x, "zeroGrob"), TRUE)
    idx <- which(nonzero)
    # return first non-zero legend if exists, and otherwise first element (which will be a zeroGrob) 
    if (length(idx) > 0) {
        return(legends[[idx[1]]])
    } else {
        return(legends[[1]])
    }
}

empty_plot <- ggplot() + theme_void()
legend <- get_legend_35(west + theme(legend.position = "right"))

left_col <- plot_grid(empty_plot,
                        west + theme(legend.position="none"), 
                        legend, 
                        ncol = 1, rel_heights = c(0.2, 0.5, 0.2), scale = c(1, 1.9, 1))
middle_col <- plot_grid(empty_plot,
                        midwest + theme(legend.position="none"), 
                        empty_plot,
                        south + theme(legend.position="none"),
                        empty_plot,
                        ncol = 1, rel_heights = c(0.2, 1.5, 0.1, 2.2, 0.1), scale = c(1, 2.3, 1, 2.7, 0.7))
right_col <- plot_grid(newengland + theme(legend.position="none"), 
                        midatlantic + theme(legend.position="none"), 
                        southatlantic + theme(legend.position="none"), 
                        ncol = 1, rel_heights = c(1.6, 1.5, 1.7), scale = c(1.2, 1.1, 0.8))

map_plot <- plot_grid(empty_plot, left_col, empty_plot, middle_col, empty_plot, right_col, nrow = 1, rel_widths = c(0.9, 2.3, 1.8, 2.7, 0.7, 4.9))
ggsave('map_MSAR.jpeg', map_plot, width = 15, height = 15, dpi = 300)
