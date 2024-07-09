#######################################################
## RF to predict which schools are OOS-friendly
#######################################################
library(tidymodels)
library(vip)
library(dplyr)
library(faraway)
library(randomForest)
library(tibble)
library(missForest)

## read in data 
merge_df <- read.csv('admit_docs_merged_ML.csv', header = TRUE)
# merge_df[merge_df$School == 'USF (Morsani)', 'class.size'] <- 180
# merge_df[merge_df$School == 'USF (Morsani)', 'X..of.students.OOS'] <- 53.0
# merge_df[merge_df$School == 'SUNY Upstate', 'class.size'] <- 170
# merge_df[merge_df$School == 'SUNY Upstate', 'X..of.students.OOS'] <- 25.0
# merge_df[merge_df$School == 'UC Riverside', 'OOS...post.II.A'] <- 75
# merge_df[merge_df$School == 'LSU (Shreveport)', 'class.size'] <- 150
# merge_df[merge_df$School == 'George Washington', 'apply.OOS.to.public.state.school.'] <- 'Yes'
# merge_df[merge_df$School == 'LSU (Shreveport)', 'apply.OOS.to.public.state.school.'] <- 'No'
# merge_df[merge_df$School == 'UC Riverside', 'apply.OOS.to.public.state.school.'] <- 'No'
# merge_df[merge_df$School == 'SUNY Upstate', 'apply.OOS.to.public.state.school.'] <- 'No'
# write.csv(merge_df, 'admit_docs_merged_ML.csv')

## clean up data
merge_df$apply.OOS.to.public.state.school.[merge_df$apply.OOS.to.public.state.school. == ''] <- NA
merge_df$Applications <- gsub("\\D+", "", merge_df$Applications)
merge_df$A...rate <- as.numeric(gsub("%", "", merge_df$A...rate))
merge_df$OOS.IS.matriculants <- as.numeric(gsub("%", "", merge_df$OOS.IS.matriculants))
merge_df$X..of.students.OOS <- as.numeric(gsub("%", "", merge_df$X..of.students.OOS))
merge_df$Public.Private <- factor(merge_df$Public.Private)
# merge_df$State <- factor(merge_df$State)
merge_df$apply.OOS.to.public.state.school. <- factor(merge_df$apply.OOS.to.public.state.school.)

## remove unnecessary columns
merge_df$Step.1 <- NULL
merge_df$Step.1...pass <- NULL
merge_df$step.2 <- NULL
merge_df$step.2.pass <- NULL
# merge_df$State <- NULL
merge_df <- merge_df[, -(seq(4, 23))]
merge_df <- merge_df[, -c(1, 2)]

## remove schools w/ no data or classification
merge_df <- merge_df[!is.na(merge_df$Total.apps), ]
## remove rows with no value for apply.OOS.to.public.state.school.
merge_df <- merge_df[!is.na(merge_df$apply.OOS.to.public.state.school.), ]

# merge_df <- merge_df[!is.na(merge_df$Apps.IS),]
# merge_df <- merge_df[!is.na(merge_df$apply.OOS.to.public.state.school.),]
# merge_df <- merge_df[!is.na(merge_df$OOS...post.II.A),]
# merge_df <- merge_df[!is.na(merge_df$OOS.II.OOS.applicants),]
# merge_df <- merge_df[!is.na(merge_df$class.size),]
# merge_df <- merge_df[!is.na(merge_df$X..of.students.OOS),]
# merge_df <- merge_df[!is.na(merge_df$IS_A),]
# merge_df <- merge_df[!is.na(merge_df$OOS_A),]
# merge_df <- merge_df[!is.na(merge_df$IS_A.OOS_A),]
# merge_df <- merge_df[complete.cases(merge_df), ]

## impute missing values using RF
## find rows with missing values that aren't in apply.OOS.to.public.state.school. column
## put in information, if available -> if not, proceed to RF and assign apply.OOS.to.public.state.school. column value
# lost_schools_df <- lost_schools_df[!is.na(lost_schools_df$Total.apps), ]
# lost_schools_df$apply.OOS.to.public.state.school. <- NULL
# lost_schools_2_df <- lost_schools_df[!complete.cases(lost_schools_df), ]
# merge_df[merge_df$School == 'USF (Morsani)', 'class.size'] <- 180
# merge_df[merge_df$School == 'USF (Morsani)', 'X..of.students.OOS'] <- 53.0
# merge_df[merge_df$School == 'SUNY Upstate', 'class.size'] <- 170
# merge_df[merge_df$School == 'SUNY Upstate', 'X..of.students.OOS'] <- 25.0
# merge_df[merge_df$School == 'UC Riverside', 'OOS...post.II.A'] <- 75
# merge_df[merge_df$School == 'LSU (Shreveport)', 'class.size'] <- 150

#######################################################
## give value for George Washington, SUNY Upstate, UC Riverside, LSU (Shreveport)
merge_df$State <- as.factor(merge_df$State)
#######################################################

# merge_imputed <- tibble::as_tibble(
#                 randomForest::rfImpute(apply.OOS.to.public.state.school. ~ ., ntree = 200, iter = 5, data = merge_df)
#                 ) %>% select(Apps.IS, IS.II, IS.Accepted, 
#                              IS.enrolled, Apps.OOS, OOS.II, OOS.Accepted, OOS.enrolled, Total.apps, TOTAL.II, total.accepted, Total.enrolled, 
#                              post.II...A, IS...post.II.A, OOS...post.II.A, A...rate, OOS.II.OOS.applicants, Public.Private, OOS.IS.matriculants, 
#                              Median.MCAT, Median.GPA, class.size, X..of.students.OOS, apply.OOS.to.public.state.school., IS_A, OOS_A, IS_A.OOS_A)

# merge_imputed <- rfImpute(apply.OOS.to.public.state.school. ~ ., merge_df)
## impute missing values; have to take out school column because it's type chr; missForest() doesn't change row order, so we'll just cbind back after
School <- as.vector(merge_df['School'])
merge_df <- merge_df[, -1]
merge_imputed <- missForest(merge_df)$ximp
merge_df <- cbind(merge_imputed, data.frame(School))

write.csv(merge_df, 'admit_docs_merged_ML_imputed.csv')


#######################################################
## update imputed.csv by adding other rows to it
old_df <- read.csv('admit_docs_merged_ML.csv', header = TRUE)
## clean up data
old_df$apply.OOS.to.public.state.school.[old_df$apply.OOS.to.public.state.school. == ''] <- NA
old_df$Applications <- gsub("\\D+", "", old_df$Applications)
old_df$A...rate <- as.numeric(gsub("%", "", old_df$A...rate))
old_df$OOS.IS.matriculants <- as.numeric(gsub("%", "", old_df$OOS.IS.matriculants))
old_df$X..of.students.OOS <- as.numeric(gsub("%", "", old_df$X..of.students.OOS))
old_df$Public.Private <- factor(old_df$Public.Private)
# merge_df$State <- factor(merge_df$State)
old_df$apply.OOS.to.public.state.school. <- factor(old_df$apply.OOS.to.public.state.school.)

## remove unnecessary columns
old_df$Step.1 <- NULL
old_df$Step.1...pass <- NULL
old_df$step.2 <- NULL
old_df$step.2.pass <- NULL
# merge_df$State <- NULL
old_df <- old_df[, -(seq(4, 23))]
old_df <- old_df[, -c(1, 2)]


old_df <- rows_upsert(old_df, merge_df, by = 'School')
## write imputed full csv
write.csv(old_df, 'full_imputed_admit_docs_merged_ML.csv')
#######################################################


## split data
df_split <- initial_split(merge_df, prop = 0.65)

## extract the data in each split
df_train <- training(df_split)
df_test <- testing(df_split)


OOS_classifier_recipe <- recipe(apply.OOS.to.public.state.school. ~ ., data = df_train) %>% 
    update_role(School, new_role = 'ID') %>%
    update_role(State, new_role = 'ID') %>%
    step_mutate(Public.Private = factor(Public.Private)) %>% 
    step_normalize(all_numeric_predictors()) %>% 
    step_dummy(Public.Private)

## Build a random forest model specification
rf_spec <- rand_forest() %>% 
  set_engine("ranger", importance = "impurity") %>% 
  set_mode("classification")

## Bundle recipe and model spec into a workflow
rf_wf <- workflow() %>% 
  add_recipe(OOS_classifier_recipe) %>% 
  add_model(rf_spec)

## Fit a model
rf_wf_fit <- rf_wf %>% 
  fit(data = df_train)

## Make predictions on test data
results <- df_test %>% select(apply.OOS.to.public.state.school.) %>% 
    bind_cols(rf_wf_fit %>% 
        predict(new_data = df_test)) %>% 
    bind_cols(rf_wf_fit %>% 
        predict(new_data = df_test, type = "prob"))

## Print out predictions
results %>% 
    slice_head(n = 10)

results %>% 
    conf_mat(truth = apply.OOS.to.public.state.school., estimate = .pred_class) %>%
    autoplot()

## ROC curve
results %>% 
    roc_curve(truth = apply.OOS.to.public.state.school., .pred_No) %>% 
    autoplot()

ROC_curve_plot <- autoplot(roc_curve(data = results, truth = apply.OOS.to.public.state.school., .pred_No))
# ggsave('ROC_curve.jpeg', ROC_curve_plot, width = 5, height = 5, dpi = 300)

## compute AUC
results %>% 
    roc_auc(apply.OOS.to.public.state.school., .pred_No)

# Extract the fitted model from the workflow
rf_wf_fit %>% 
    extract_fit_parsnip() %>% 
# Make VIP plot
    vip()

# ggsave('VIP.jpeg', vip(extract_fit_parsnip(rf_wf_fit)), width = 5, height = 5, dpi = 300)

# Save trained workflow
saveRDS(rf_wf_fit, "rf_OOS_classifier_model.rds")


# Make predictions
## read in imputed data 
merge_df <- read.csv('full_imputed_admit_docs_merged_ML.csv', header = TRUE)

## clean up data
merge_df[which(merge_df$apply.OOS.to.public.state.school. == ''), 'apply.OOS.to.public.state.school.'] <- NA
# merge_df$Applications <- gsub("\\D+", "", merge_df$Applications)
merge_df$A...rate <- as.numeric(gsub("%", "", merge_df$A...rate))
merge_df$OOS.IS.matriculants <- as.numeric(gsub("%", "", merge_df$OOS.IS.matriculants))
merge_df$X..of.students.OOS <- as.numeric(gsub("%", "", merge_df$X..of.students.OOS))
merge_df$Public.Private <- factor(merge_df$Public.Private)
# merge_df$State <- factor(merge_df$State)
merge_df$apply.OOS.to.public.state.school. <- factor(merge_df$apply.OOS.to.public.state.school.)

## remove unnecessary columns
merge_df$Step.1 <- NULL
merge_df$Step.1...pass <- NULL
merge_df$step.2 <- NULL
merge_df$step.2.pass <- NULL
# merge_df$State <- NULL
merge_df <- merge_df[, -1]


## remove rows with any NA values (will fix later to come up with better solution)
predict_df <- select(merge_df, -apply.OOS.to.public.state.school., everything())
predict_df <- predict_df[complete.cases(predict_df[, 1:(ncol(predict_df) - 1)]), ]
# print(head(predict_df, 10))

# Load the model into the current R session
loaded_model <- readRDS("rf_OOS_classifier_model.rds")

predictions <- predict_df %>% 
    bind_cols(loaded_model %>% predict(predict_df))

predictions <- select(predictions, c(apply.OOS.to.public.state.school., .pred_class), everything())

write.csv(predictions, 'OOS_friendly_RF_model_prediction.csv')


