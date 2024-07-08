#######################################################
## GLM to predict which schools are OOS-friendly
#######################################################
library(tidymodels)

## read in data 
merge_df <- read.csv('admit_docs_merged_ML.csv', header = TRUE)

## clean up data
merge_df[which(merge_df$apply.OOS.to.public.state.school. == ''), ] <- NA
merge_df$Applications <- gsub("\\D+", "", merge_df$Applications)
merge_df$A...rate <- as.numeric(gsub("%", "", merge_df$A...rate))
merge_df$OOS.IS.matriculants <- as.numeric(gsub("%", "", merge_df$OOS.IS.matriculants))
merge_df$X..of.students.OOS <- as.numeric(gsub("%", "", merge_df$X..of.students.OOS))
merge_df$Public.Private <- factor(merge_df$Public.Private)
merge_df$State <- factor(merge_df$State)
merge_df$apply.OOS.to.public.state.school. <- factor(merge_df$apply.OOS.to.public.state.school.)

## remove unnecessary columns
merge_df$Step.1 <- NULL
merge_df$Step.1...pass <- NULL
merge_df$step.2 <- NULL
merge_df$step.2.pass <- NULL
merge_df$State <- NULL
merge_df <- merge_df[, -(seq(1, 21))]


## remove schools w/ no data or classification
merge_df <- merge_df[!is.na(merge_df$Apps.IS),]
merge_df <- merge_df[!is.na(merge_df$apply.OOS.to.public.state.school.),]

## save data for schools without classification for prediction
predict_df <- merge_df[is.na(merge_df$Apps.IS),]

## split data
df_split <- initial_split(merge_df, prop = 0.65)

## extract the data in each split
df_train <- training(df_split)
df_test <- testing(df_split)

## build model
logreg_spec <- logistic_reg() %>% 
    set_engine("glm") %>% 
    set_mode("classification")

## train model
logreg_fit <- logreg_spec %>% 
    fit(apply.OOS.to.public.state.school. ~ ., data = df_train)

## Make predictions then bind them to the test set
results <- df_test %>% select(apply.OOS.to.public.state.school.) %>% 
    bind_cols(logreg_fit %>% predict(new_data = df_test))

## Compare predictions
results %>% 
    slice_head(n = 10)
accuracy(data = results, truth = apply.OOS.to.public.state.school., estimate = .pred_class)

## Confusion matrix for prediction results
conf_mat(data = results, truth = apply.OOS.to.public.state.school., estimate = .pred_class)

# Combine metrics and evaluate them all at once
eval_metrics <- metric_set(ppv, recall, accuracy, f_meas)
eval_metrics(data = results, truth = apply.OOS.to.public.state.school., estimate = .pred_class)

results <- results %>% 
    bind_cols(logreg_fit %>% 
        predict(new_data = df_test, type = "prob"))

## ROC curve
results %>% 
    roc_curve(truth = apply.OOS.to.public.state.school., .pred_no) %>% 
    autoplot()

## compute AUC
results %>% 
    roc_auc(apply.OOS.to.public.state.school., .pred_no)

## preprocess the data for modelling
OOS_classifier_recipe <- recipe(apply.OOS.to.public.state.school. ~ ., data = df_train) %>% 
    step_mutate(Public.Private = factor(Public.Private)) %>% 
    step_normalize(all_numeric_predictors()) %>% 
    step_dummy(Public.Private)

## redefine the model specification
logreg_spec <- logistic_reg() %>% 
  set_engine("glm") %>% 
  set_mode("classification")

## bundle the recipe and model specification
lr_wf <- workflow() %>% 
  add_recipe(OOS_classifier_recipe) %>% 
  add_model(logreg_spec)

## fit a workflow object
lr_wf_fit <- lr_wf %>% 
  fit(data = df_train)

# Make predictions on the test set
results <- df_test %>% select(apply.OOS.to.public.state.school.) %>% 
    bind_cols(lr_wf_fit %>% 
        predict(new_data = df_test)) %>% 
    bind_cols(lr_wf_fit %>% 
        predict(new_data = df_test, type = "prob"))

results %>% 
    conf_mat(truth = apply.OOS.to.public.state.school., estimate = .pred_class)

## Evaluate other desired metrics
eval_metrics(data = results, truth = apply.OOS.to.public.state.school., estimate = .pred_class)

## Save trained workflow
saveRDS(lr_wf_fit, "glm_OOS_classifier_model.rds")