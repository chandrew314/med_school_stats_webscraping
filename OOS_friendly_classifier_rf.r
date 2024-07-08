#######################################################
## RF to predict which schools are OOS-friendly
#######################################################
library(tidymodels)
library(vip)

## read in data 
merge_df <- read.csv('admit_docs_merged_ML.csv', header = TRUE)

## clean up data
merge_df[which(merge_df$apply.OOS.to.public.state.school. == ''), ] <- NA
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
merge_df <- merge_df[, -(seq(2, 21))]

## remove schools w/ no data or classification
# merge_df <- merge_df[!is.na(merge_df$Apps.IS),]
# merge_df <- merge_df[!is.na(merge_df$apply.OOS.to.public.state.school.),]
# merge_df <- merge_df[!is.na(merge_df$OOS...post.II.A),]
# merge_df <- merge_df[!is.na(merge_df$OOS.II.OOS.applicants),]
# merge_df <- merge_df[!is.na(merge_df$class.size),]
# merge_df <- merge_df[!is.na(merge_df$X..of.students.OOS),]
# merge_df <- merge_df[!is.na(merge_df$IS_A),]
# merge_df <- merge_df[!is.na(merge_df$OOS_A),]
# merge_df <- merge_df[!is.na(merge_df$IS_A.OOS_A),]
merge_df <- merge_df[complete.cases(merge_df), ]

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
    roc_curve(truth = apply.OOS.to.public.state.school., .pred_no) %>% 
    autoplot()

ROC_curve_plot <- autoplot(roc_curve(data = results, truth = apply.OOS.to.public.state.school., .pred_no))
# ggsave('ROC_curve.jpeg', ROC_curve_plot, width = 5, height = 5, dpi = 300)

## compute AUC
results %>% 
    roc_auc(apply.OOS.to.public.state.school., .pred_no)

# Extract the fitted model from the workflow
rf_wf_fit %>% 
    extract_fit_parsnip() %>% 
# Make VIP plot
    vip()

# ggsave('VIP.jpeg', vip(extract_fit_parsnip(rf_wf_fit)), width = 5, height = 5, dpi = 300)

# Save trained workflow
saveRDS(rf_wf_fit, "rf_OOS_classifier_model.rds")


# Make predictions
## read in data 
merge_df <- read.csv('admit_docs_merged_ML.csv', header = TRUE)

## clean up data
merge_df[which(merge_df$apply.OOS.to.public.state.school. == ''), 'apply.OOS.to.public.state.school.'] <- NA
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
merge_df <- merge_df[, -(seq(2, 21))]

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


