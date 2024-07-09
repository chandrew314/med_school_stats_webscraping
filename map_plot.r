#######################################################
## figure for RF ML prediction of which schools are OOS friendly
#######################################################
library(ggplot2)
library(cowplot)
library(usmap)
library(sf)

rf_prediction_df <- read.csv('OOS_friendly_RF_model_prediction.csv', header = TRUE)

## missing AK bc someone labeled Arkansas (AR) as AK in the dataset
west_list <- c('CA', 'OR', 'WA', 'NV', 'AZ', 'UT', 'NM', 'CO', 'WY', 'ID', 'MT', 'HI')
# northeast_list <- c('ME', 'VT', 'NH', 'MA', 'RI', 'CT', 'NY', 'NJ', 'PA')
midwest_list <- c('ND', 'SD', 'NE', 'KS', 'MO', 'IA', 'MN', 'WI', 'IL', 'MI', 'IN', 'OH')
south_list <- c('OK', 'TX', 'AR', 'LA', 'MS', 'TN', 'KY', 'AL', 'GA', 'FL')
midatlantic_list <- c('NY', 'PA', 'NJ')
newengland_list <- c('ME', 'NH', 'VT', 'MA', 'CT', 'RI')
southatlantic_list <- c('MD', 'DE', 'DC', 'VA', 'WV', 'NC', 'SC')

not_east_list <- c(west_list, midwest_list, south_list)
east_coast_list <- c(midatlantic_list, newengland_list, southatlantic_list)

## assign regions to states
rf_prediction_df$region <- NA
rf_prediction_df$region[rf_prediction_df$State %in% west_list] <- 'west'
rf_prediction_df$region[rf_prediction_df$State %in% midwest_list] <- 'midwest'
rf_prediction_df$region[rf_prediction_df$State %in% south_list] <- 'south'
rf_prediction_df$region[rf_prediction_df$State %in% midatlantic_list] <- 'midatlantic'
rf_prediction_df$region[rf_prediction_df$State %in% newengland_list] <- 'new england'
rf_prediction_df$region[rf_prediction_df$State %in% southatlantic_list] <- 'south atlantic'

rf_prediction_df$region2 <- NA
rf_prediction_df$region2[rf_prediction_df$State %in% not_east_list] <- 'not east coast'
rf_prediction_df$region2[rf_prediction_df$State %in% east_coast_list] <- 'east coast'

## combine prediction and apply.OOS.to.public.state.school. columns
rf_prediction_df$apply.OOS.to.public.state.school.final <- rf_prediction_df$apply.OOS.to.public.state.school.
rf_prediction_df$apply.OOS.to.public.state.school.final <- ifelse(is.na(rf_prediction_df$apply.OOS.to.public.state.school.), rf_prediction_df$.pred_class, rf_prediction_df$apply.OOS.to.public.state.school.)


## add coordinates ;((
rf_prediction_df$latitude <- NA
rf_prediction_df$longitude <- NA

rf_prediction_df[rf_prediction_df$School == 'Harvard Medical School', c('latitude', 'longitude')] <- c(42.3356470827217, -71.10420963556751)
rf_prediction_df[rf_prediction_df$School == 'Johns Hopkins', c('latitude', 'longitude')] <- c(39.29924505727417, -76.59329409169402)
rf_prediction_df[rf_prediction_df$School == 'UPenn (Perelman)', c('latitude', 'longitude')] <- c(39.94793631078064, -75.19255508803246)
rf_prediction_df[rf_prediction_df$School == 'Columbia University', c('latitude', 'longitude')] <- c(40.844767137730024, -73.94162805730802)
rf_prediction_df[rf_prediction_df$School == 'Duke University', c('latitude', 'longitude')] <- c(36.00651107579948, -78.93812065290389)
rf_prediction_df[rf_prediction_df$School == 'Stanford University', c('latitude', 'longitude')] <- c(37.43381031111368, -122.17395344632439)
rf_prediction_df[rf_prediction_df$School == 'UCSF', c('latitude', 'longitude')] <- c(37.762917755597606, -122.45964661510965)
rf_prediction_df[rf_prediction_df$School == 'Vanderbilt University', c('latitude', 'longitude')] <- c(36.142398054853636, -86.8025487035374)
rf_prediction_df[rf_prediction_df$School == 'WashU St. Louis', c('latitude', 'longitude')] <- c(38.635290762058396, -90.26290744229888)
rf_prediction_df[rf_prediction_df$School == 'Weill Cornell Medicine', c('latitude', 'longitude')] <- c(40.76505907178383, -73.95479459032126)
rf_prediction_df[rf_prediction_df$School == 'NYU Grossman', c('latitude', 'longitude')] <- c(40.74238902658599, -73.97389401868608)
rf_prediction_df[rf_prediction_df$School == 'Yale School of Medicine', c('latitude', 'longitude')] <- c(41.30338792154819, -72.93387240806501)
rf_prediction_df[rf_prediction_df$School == 'Mayo Clinic', c('latitude', 'longitude')] <- c(44.46648915589723, -92.37155061425509)
rf_prediction_df[rf_prediction_df$School == 'Northwestern University', c('latitude', 'longitude')] <- c(41.89626552054785, -87.61713388979737)
rf_prediction_df[rf_prediction_df$School == 'University of Michigan', c('latitude', 'longitude')] <- c(42.28419950580636, -83.73253130141819)
rf_prediction_df[rf_prediction_df$School == 'University of Pittsburgh', c('latitude', 'longitude')] <- c(40.44325931424113, -79.96136701869949)
rf_prediction_df[rf_prediction_df$School == 'University of Washington', c('latitude', 'longitude')] <- c(47.65066559332469, -122.3093580741712)
rf_prediction_df[rf_prediction_df$School == 'Icahn at Mount Sinai', c('latitude', 'longitude')] <- c(40.79014986050417, -73.95375213217557)
rf_prediction_df[rf_prediction_df$School == 'UCLA', c('latitude', 'longitude')] <- c(34.064460630398685, -118.44233474594617)
rf_prediction_df[rf_prediction_df$School == 'UChicago (Pritzker)', c('latitude', 'longitude')] <- c(41.79167137562372, -87.60271733212994)
rf_prediction_df[rf_prediction_df$School == 'UCSD', c('latitude', 'longitude')] <- c(33.77421492807711, -117.36781672020894)
rf_prediction_df[rf_prediction_df$School == 'Baylor', c('latitude', 'longitude')] <- c(29.80022138731056, -95.40930582736)
rf_prediction_df[rf_prediction_df$School == 'Emory University', c('latitude', 'longitude')] <- c(34.32159067579798, -84.31667617002336)
rf_prediction_df[rf_prediction_df$School == 'UTSW', c('latitude', 'longitude')] <- c(32.81590394049455, -96.8443380001922)
rf_prediction_df[rf_prediction_df$School == 'Case Western Reserve', c('latitude', 'longitude')] <- c(41.50516831075912, -81.62031718981538)
rf_prediction_df[rf_prediction_df$School == 'Colorado', c('latitude', 'longitude')] <- c(39.74572667424326, -104.83594959490391)
rf_prediction_df[rf_prediction_df$School == 'UNC', c('latitude', 'longitude')] <- c(35.90603105586625, -79.052376632383)
rf_prediction_df[rf_prediction_df$School == 'Ohio State University', c('latitude', 'longitude')] <- c(39.99518448115739, -83.01505186104716)
rf_prediction_df[rf_prediction_df$School == 'USC (Keck)', c('latitude', 'longitude')] <- c(34.0887172843416, -118.20285307323385)
rf_prediction_df[rf_prediction_df$School == 'Oregon University', c('latitude', 'longitude')] <- c(45.51967558474168, -122.69032317835757)
rf_prediction_df[rf_prediction_df$School == 'University of Virginia', c('latitude', 'longitude')] <- c(38.031793389134826, -78.5009840322958)
rf_prediction_df[rf_prediction_df$School == 'Boston University', c('latitude', 'longitude')] <- c(42.3365549560523, -71.072446189777)
rf_prediction_df[rf_prediction_df$School == 'University of Maryland', c('latitude', 'longitude')] <- c(39.28905857357468, -76.62573913991424)
rf_prediction_df[rf_prediction_df$School == 'University of Rochester', c('latitude', 'longitude')] <- c(43.1233126037617, -77.62698321857613)
rf_prediction_df[rf_prediction_df$School == 'Brown University', c('latitude', 'longitude')] <- c(41.81894584919687, -71.40846223531275)
rf_prediction_df[rf_prediction_df$School == 'University of Alabama', c('latitude', 'longitude')] <- c(33.502908814462984, -86.80377454229888)
rf_prediction_df[rf_prediction_df$School == 'University of Cincinnati', c('latitude', 'longitude')] <- c(39.13865845135584, -84.5037641610846)
rf_prediction_df[rf_prediction_df$School == 'University of Florida', c('latitude', 'longitude')] <- c(29.639945174856617, -82.34346620377492)
rf_prediction_df[rf_prediction_df$School == 'University of Minnesota', c('latitude', 'longitude')] <- c(44.9727701726422, -93.23351931848688)
rf_prediction_df[rf_prediction_df$School == 'University of Utah', c('latitude', 'longitude')] <- c(40.76992161382454, -111.83575057635704)
rf_prediction_df[rf_prediction_df$School == 'University of Wisconsin', c('latitude', 'longitude')] <- c(43.078013193548585, -89.42967154556156)
rf_prediction_df[rf_prediction_df$School == 'Albert Einstein', c('latitude', 'longitude')] <- c(40.85060157271736, -73.84593438984511)
rf_prediction_df[rf_prediction_df$School == 'Indiana University', c('latitude', 'longitude')] <- c(39.800555152074, -86.17615771343038)
rf_prediction_df[rf_prediction_df$School == 'UC Irvine', c('latitude', 'longitude')] <- c(33.64442624845787, -117.85175894596198)
rf_prediction_df[rf_prediction_df$School == 'University of Iowa', c('latitude', 'longitude')] <- c(41.662939098984246, -91.5452101167914)
rf_prediction_df[rf_prediction_df$School == 'UMass', c('latitude', 'longitude')] <- c(42.27871180418385, -71.7632965744352)
rf_prediction_df[rf_prediction_df$School == 'University of Miami', c('latitude', 'longitude')] <- c(25.790749312313736, -80.2119713462204)
rf_prediction_df[rf_prediction_df$School == 'Dartmouth (Geisel)', c('latitude', 'longitude')] <- c(43.70889113568098, -72.28510850320377)
rf_prediction_df[rf_prediction_df$School == 'Wake Forest', c('latitude', 'longitude')] <- c(36.10021572895614, -80.24021724586683)
rf_prediction_df[rf_prediction_df$School == 'UC Davis', c('latitude', 'longitude')] <- c(38.55313988723398, -121.4525691457653)
rf_prediction_df[rf_prediction_df$School == 'USF (Morsani)', c('latitude', 'longitude')] <- c(27.94411749818683, -82.44935863081214)
rf_prediction_df[rf_prediction_df$School == 'Georgetown University', c('latitude', 'longitude')] <- c(38.9119936988319, -77.07700894574994)
rf_prediction_df[rf_prediction_df$School == 'Tufts University', c('latitude', 'longitude')] <- c(42.35024598486101, -71.06231685564244)
rf_prediction_df[rf_prediction_df$School == 'Medical University of South Carolina', c('latitude', 'longitude')] <- c(32.789822975630216, -79.94614088217146)
rf_prediction_df[rf_prediction_df$School == 'McGovern (Houston)', c('latitude', 'longitude')] <- c(29.71283502630886, -95.39726370377248)
rf_prediction_df[rf_prediction_df$School == 'George Washington', c('latitude', 'longitude')] <- c(38.90037141429332, -77.05098666109495)
rf_prediction_df[rf_prediction_df$School == 'Stony Brook University', c('latitude', 'longitude')] <- c(40.908770330245716, -73.1149835879896)
rf_prediction_df[rf_prediction_df$School == 'Jefferson (Kimmel)', c('latitude', 'longitude')] <- c(39.948846345691564, -75.15786747454081)
rf_prediction_df[rf_prediction_df$School == 'University of Illinois', c('latitude', 'longitude')] <- c(41.8715353679799, -87.6734899321263)
rf_prediction_df[rf_prediction_df$School == 'University of Nebraska', c('latitude', 'longitude')] <- c(41.25430728658878, -95.97577618400578)
rf_prediction_df[rf_prediction_df$School == 'University of Arizona', c('latitude', 'longitude')] <- c(32.242924445327034, -110.94567491078811)
rf_prediction_df[rf_prediction_df$School == 'Texas A&M', c('latitude', 'longitude')] <- c(30.59842923809813, -96.39442157490674)
rf_prediction_df[rf_prediction_df$School == 'University of Kentucky', c('latitude', 'longitude')] <- c(38.03110508740057, -84.5058582188042)
rf_prediction_df[rf_prediction_df$School == 'University of Vermont', c('latitude', 'longitude')] <- c(44.47839436452077, -73.19374270316656)
rf_prediction_df[rf_prediction_df$School == 'Virginia Commonwealth', c('latitude', 'longitude')] <- c(37.53986679478147, -77.43026600348023)
rf_prediction_df[rf_prediction_df$School == 'Hofstra', c('latitude', 'longitude')] <- c(40.71768837461027, -73.59795120148983)
rf_prediction_df[rf_prediction_df$School == 'Rush University', c('latitude', 'longitude')] <- c(41.8741400591876, -87.66920311678165)
rf_prediction_df[rf_prediction_df$School == 'Rutgers (Robert Johnson)', c('latitude', 'longitude')] <- c(40.5251762996634, -74.47012790149844)
rf_prediction_df[rf_prediction_df$School == 'Rutgers New Jersey', c('latitude', 'longitude')] <- c(40.74022669328292, -74.18970964752238)
rf_prediction_df[rf_prediction_df$School == 'Temple University', c('latitude', 'longitude')] <- c(40.0070389659444, -75.15213343221046)
rf_prediction_df[rf_prediction_df$School == 'University of Tennessee', c('latitude', 'longitude')] <- c(36.05344055144944, -83.94057251210515)
rf_prediction_df[rf_prediction_df$School == 'Wayne State University', c('latitude', 'longitude')] <- c(42.45583417542232, -83.02267448590331)
rf_prediction_df[rf_prediction_df$School == 'University of Kansas', c('latitude', 'longitude')] <- c(38.91199645694449, -97.61284280164854)
rf_prediction_df[rf_prediction_df$School == 'Buffalo (Jacobs)', c('latitude', 'longitude')] <- c(42.89985690216158, -78.86921133022548)
rf_prediction_df[rf_prediction_df$School == 'University of Arkansas', c('latitude', 'longitude')] <- c(34.7488430367631, -92.32067372449535)
rf_prediction_df[rf_prediction_df$School == 'University of Oklahoma', c('latitude', 'longitude')] <- c(35.47985299694403, -97.4955497435922)
rf_prediction_df[rf_prediction_df$School == 'Augusta University (MCG)', c('latitude', 'longitude')] <- c(33.47079371674277, -81.98997927665744)
rf_prediction_df[rf_prediction_df$School == 'University of Hawaii', c('latitude', 'longitude')] <- c(21.296672177768176, -157.86352611379354)
rf_prediction_df[rf_prediction_df$School == 'University of Louisville', c('latitude', 'longitude')] <- c(38.250138529576326, -85.74757843413946)
rf_prediction_df[rf_prediction_df$School == 'University of New Mexico', c('latitude', 'longitude')] <- c(35.089609593370554, -106.61683068082307)
rf_prediction_df[rf_prediction_df$School == 'Virginia Tech', c('latitude', 'longitude')] <- c(37.257690583147706, -79.94260923232812)
rf_prediction_df[rf_prediction_df$School == 'Saint Louis University', c('latitude', 'longitude')] <- c(38.62276920288664, -90.23773033041788)
rf_prediction_df[rf_prediction_df$School == 'Missouri-Columbia', c('latitude', 'longitude')] <- c(38.97771131186967, -92.33395805671516)
rf_prediction_df[rf_prediction_df$School == 'West Virginia University', c('latitude', 'longitude')] <- c(39.654870274915055, -79.95770290338997)
rf_prediction_df[rf_prediction_df$School == 'Drexel University', c('latitude', 'longitude')] <- c(40.019664016082636, -75.17992217639058)
rf_prediction_df[rf_prediction_df$School == 'Michigan State University', c('latitude', 'longitude')] <- c(43.03314426417556, -85.65177749414849)
rf_prediction_df[rf_prediction_df$School == 'SUNY Upstate', c('latitude', 'longitude')] <- c(43.04044103378732, -76.13914843207166)
rf_prediction_df[rf_prediction_df$School == 'Missouri-Kansas', c('latitude', 'longitude')] <- c(39.08328483639969, -94.57518014574256)
rf_prediction_df[rf_prediction_df$School == 'University of Nevada (Reno)', c('latitude', 'longitude')] <- c(39.54910540902771, -119.81400758804998)
rf_prediction_df[rf_prediction_df$School == 'University of South Carolina', c('latitude', 'longitude')] <- c(33.97866411648905, -80.9629729189662)
rf_prediction_df[rf_prediction_df$School == 'Texas Tech University', c('latitude', 'longitude')] <- c(33.59031074451625, -101.89117131712784)
rf_prediction_df[rf_prediction_df$School == 'UC Riverside', c('latitude', 'longitude')] <- c(33.973919138486316, -117.32399426440479)
rf_prediction_df[rf_prediction_df$School == 'Florida State University', c('latitude', 'longitude')] <- c(30.447048316080135, -84.30552476908035)
rf_prediction_df[rf_prediction_df$School == 'University of Central Florida', c('latitude', 'longitude')] <- c(28.367480583410316, -81.28018127497957)
rf_prediction_df[rf_prediction_df$School == 'Eastern Virginia', c('latitude', 'longitude')] <- c(36.860553581726016, -76.30357080350832)
rf_prediction_df[rf_prediction_df$School == 'New York Medical College', c('latitude', 'longitude')] <- c(41.08555744753234, -73.81007270332607)
rf_prediction_df[rf_prediction_df$School == 'University of Toledo', c('latitude', 'longitude')] <- c(41.61951462121917, -83.61698903213788)
rf_prediction_df[rf_prediction_df$School == 'East Carolina University', c('latitude', 'longitude')] <- c(35.60993269132835, -77.4028292458864)
rf_prediction_df[rf_prediction_df$School == 'East Tennessee State', c('latitude', 'longitude')] <- c(36.30926923758435, -82.378904430514)
rf_prediction_df[rf_prediction_df$School == 'Howard University', c('latitude', 'longitude')] <- c(38.91909507761877, -77.02004897458575)
rf_prediction_df[rf_prediction_df$School == 'Florida Atlantic University', c('latitude', 'longitude')] <- c(26.373517293107632, -80.10046536154822)
rf_prediction_df[rf_prediction_df$School == 'Florida International University', c('latitude', 'longitude')] <- c(25.758365595555862, -80.37134501923803)
rf_prediction_df[rf_prediction_df$School == 'Marshall University', c('latitude', 'longitude')] <- c(38.40936874080721, -82.42620345741021)
rf_prediction_df[rf_prediction_df$School == 'Cooper (Rowan)', c('latitude', 'longitude')] <- c(39.94074993947175, -75.11971466104953)
rf_prediction_df[rf_prediction_df$School == 'Wright State University', c('latitude', 'longitude')] <- c(39.78030210050844, -84.06140321131737)
rf_prediction_df[rf_prediction_df$School == 'Medical College of Wisconsin', c('latitude', 'longitude')] <- c(43.0436312581639, -88.0217837955632)
rf_prediction_df[rf_prediction_df$School == 'Loyola University (Stritch)', c('latitude', 'longitude')] <- c(41.858787086412164, -87.83612273212684)
rf_prediction_df[rf_prediction_df$School == 'Arknasas COM', c('latitude', 'longitude')] <- c(35.34958064150193, -94.31335262912214)
rf_prediction_df[rf_prediction_df$School == 'University of North Dakota', c('latitude', 'longitude')] <- c(47.93187339835228, -97.06804448764824)
rf_prediction_df[rf_prediction_df$School == 'South Carolina (Greenville)', c('latitude', 'longitude')] <- c(34.82166567253067, -82.41140937475335)
rf_prediction_df[rf_prediction_df$School == 'University of South Dakota', c('latitude', 'longitude')] <- c(42.95418747922167, -96.94129698848559)
rf_prediction_df[rf_prediction_df$School == 'LSU (Shreveport)', c('latitude', 'longitude')] <- c(32.480753045668095, -93.76064319971051)
rf_prediction_df[rf_prediction_df$School == 'Texas Tech (El Paso)', c('latitude', 'longitude')] <- c(31.771963107081906, -106.43098738343596)
rf_prediction_df[rf_prediction_df$School == 'Quinnipiac University', c('latitude', 'longitude')] <- c(41.41476655327027, -72.83459041680277)
rf_prediction_df[rf_prediction_df$School == 'VCOM', c('latitude', 'longitude')] <- c(37.199705179229426, -80.4059144518552)
rf_prediction_df[rf_prediction_df$School == 'LECOM', c('latitude', 'longitude')] <- c(42.08036612052119, -80.10550968978885)
rf_prediction_df[rf_prediction_df$School == 'Texas Christian University', c('latitude', 'longitude')] <- c(32.73341884978053, -97.33733126134008)



## for now:
rf_prediction_df <- rf_prediction_df[complete.cases(rf_prediction_df[, 3:ncol(rf_prediction_df)]), ]

rf_prediction_df <- sf::st_as_sf(rf_prediction_df, 
                        coords = c("longitude", "latitude"),
                        crs = 4269)

transformed_df <- usmap_transform(rf_prediction_df)

## plot west
west <- plot_usmap(regions = 'states',
        fill = "yellow", alpha = 0.25,
        include = c('CA', 'OR', 'WA', 'MT', 'ID', 'WY', 'UT', 'CO', 'NM', 'AZ', 'HI', 'NV'),
        labels = TRUE) +
    geom_sf(data = transformed_df[which(transformed_df$region == 'west'), ], aes(color = .pred_class)) +
    ggrepel::geom_label_repel(data = transformed_df[which(transformed_df$region == 'west'), ],
        aes(label = School, geometry = geometry, color = .pred_class),
        size = 3, alpha = 0.8,
        label.r = unit(0.5, "lines"), label.size = 0.3,
        segment.color = "black", segment.size = 0.5,
        stat = "sf_coordinates", seed = 1002,
        max.overlaps = 30,
        force = 30) +
        scale_color_manual(values=c("#F8766D", "#00BA38"), name = 'OOS friendly?')

midatlantic <- plot_usmap(regions = 'states',
    fill = "yellow", alpha = 0.25,
    include = .mid_atlantic, labels = TRUE) +
    geom_sf(data = transformed_df[which(transformed_df$region == 'midatlantic'), ], aes(color = .pred_class)) +
    ggrepel::geom_label_repel(data = transformed_df[which(transformed_df$region == 'midatlantic'), ],
        aes(label = School, geometry = geometry, color = .pred_class),
        size = 3, alpha = 0.8,
        label.r = unit(0.5, "lines"), label.size = 0.3,
        segment.color = "black", segment.size = 0.5,
        stat = "sf_coordinates", seed = 1002,
        max.overlaps = 30,
        force = 30) +
        scale_color_manual(values=c("#F8766D", "#00BA38"))

newengland <- plot_usmap(regions = 'states',
    fill = "yellow", alpha = 0.25,
    include = .new_england, labels = TRUE) +
    geom_sf(data = transformed_df[which(transformed_df$region == 'new england'), ], aes(color = .pred_class)) +
    ggrepel::geom_label_repel(data = transformed_df[which(transformed_df$region == 'new england'), ],
        aes(label = School, geometry = geometry, color = .pred_class),
        size = 3, alpha = 0.8,
        label.r = unit(0.5, "lines"), label.size = 0.3,
        segment.color = "black", segment.size = 0.5,
        stat = "sf_coordinates", seed = 1002,
        max.overlaps = 30,
        force = 30) + 
        scale_color_manual(values=c("#00BA38"))

midwest <- plot_usmap(regions = 'states',
    fill = "yellow", alpha = 0.25,
    include = .midwest_region, labels = TRUE) +
    geom_sf(data = transformed_df[which(transformed_df$region == 'midwest'), ], aes(color = .pred_class)) +
    ggrepel::geom_label_repel(data = transformed_df[which(transformed_df$region == 'midwest'), ],
        aes(label = School, geometry = geometry, color = .pred_class),
        size = 3, alpha = 0.8,
        label.r = unit(0.5, "lines"), label.size = 0.3,
        segment.color = "black", segment.size = 0.5,
        stat = "sf_coordinates", seed = 1002,
        max.overlaps = 30,
        force = 30) + 
    scale_color_manual(values=c("#F8766D", "#00BA38"))

south <- plot_usmap(regions = 'states',
    fill = "yellow", alpha = 0.25,
    include = c('OK', 'TX', 'AR', 'LA', 'MS', 'TN', 'KY', 'AL', 'GA', 'FL'), labels = TRUE) + 
    geom_sf(data = transformed_df[which(transformed_df$region == 'south'), ], aes(color = .pred_class)) +
    ggrepel::geom_label_repel(data = transformed_df[which(transformed_df$region == 'south'), ],
        aes(label = School, geometry = geometry, color = .pred_class),
        size = 3, alpha = 0.8,
        label.r = unit(0.5, "lines"), label.size = 0.3,
        segment.color = "black", segment.size = 0.5,
        stat = "sf_coordinates", seed = 1002,
        max.overlaps = 30,
        force = 30) + 
    scale_color_manual(values=c("#F8766D", "#00BA38"))

southatlantic <- plot_usmap(regions = 'states',
    fill = "yellow", alpha = 0.25,
    include = southatlantic_list, labels = TRUE) + 
    geom_sf(data = transformed_df[which(transformed_df$region == 'south atlantic'), ], aes(color = .pred_class)) +
    ggrepel::geom_label_repel(data = transformed_df[which(transformed_df$region == 'south atlantic'), ],
        aes(label = School, geometry = geometry, color = .pred_class),
        size = 3, alpha = 0.8,
        label.r = unit(0.5, "lines"), label.size = 0.3,
        segment.color = "black", segment.size = 0.5,
        stat = "sf_coordinates", seed = 1002,
        max.overlaps = 30,
        force = 30) + 
    scale_color_manual(values=c("#F8766D", "#00BA38"))


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
                        ncol = 1, rel_heights = c(3, 10, 1), scale = c(1, 1.9, 1))
middle_col <- plot_grid(empty_plot,
                        midwest + theme(legend.position="none"), 
                        empty_plot,
                        south + theme(legend.position="none"),
                        empty_plot,
                        ncol = 1, rel_heights = c(1, 1.4, 0.9, 1.9, 0.1), scale = c(1, 2.3, 1, 2.3, 0.7))
right_col <- plot_grid(newengland + theme(legend.position="none"), 
                        midatlantic + theme(legend.position="none"), 
                        southatlantic + theme(legend.position="none"), 
                        ncol = 1, rel_heights = c(1.6, 1.5, 1.7), scale = c(1.2, 1.1, 1))

map_plot <- plot_grid(empty_plot, left_col, empty_plot, middle_col, empty_plot, right_col, nrow = 1, rel_widths = c(0.9, 2.3, 1.8, 2.7, 0.7, 4.9))
ggsave('map_help.jpeg', map_plot, width = 15, height = 15, dpi = 300)








## plot not east coast
## removing Alaska from plot
remove_AK <- c('AK')
not_east_list <- not_east_list[!not_east_list %in% remove_AK]
not_east_list <- c(not_east_list, 'AR')

not_east_coast <- plot_usmap(regions = 'states',
        fill = "yellow", alpha = 0.25,
        include = not_east_list,
        labels = TRUE) +
    geom_sf(data = transformed_df[which(transformed_df$region2 == 'not east coast'), ], aes(color = .pred_class)) +
    ggrepel::geom_label_repel(data = transformed_df[which(transformed_df$region2 == 'not east coast'), ],
        aes(label = School, geometry = geometry, color = .pred_class),
        size = 4, alpha = 0.8,
        label.r = unit(0.5, "lines"), label.size = 0.3,
        segment.color = "black", segment.size = 0.5,
        stat = "sf_coordinates", seed = 1002,
        max.overlaps = 20,
        force = 30) +
        scale_color_manual(values=c("#F8766D", "#00BA38"), name = 'OOS friendly?')

east_coast <- plot_usmap(regions = 'states',
        fill = "yellow", alpha = 0.25,
        include = east_coast_list,
        labels = TRUE) +
    geom_sf(data = transformed_df[which(transformed_df$region2 == 'east coast'), ], aes(color = .pred_class)) +
    ggrepel::geom_label_repel(data = transformed_df[which(transformed_df$region2 == 'east coast'), ],
        aes(label = School, geometry = geometry, color = .pred_class),
        size = 4, alpha = 0.8,
        label.r = unit(0.5, "lines"), label.size = 0.3,
        segment.color = "black", segment.size = 0.5,
        stat = "sf_coordinates", seed = 1002,
        max.overlaps = 20,
        force = 30) +
        scale_color_manual(values=c("#F8766D", "#00BA38"), name = 'OOS friendly?')
