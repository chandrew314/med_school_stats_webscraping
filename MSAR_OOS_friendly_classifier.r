library(randomForest)
library(dplyr)
library(tidymodels)
library(parsnip)
library(vip)

MSAR_df <- read.csv('MSAR data.csv', header = TRUE) |>
    mutate(OOS_friendly = na_if(OOS_friendly, '')) |>
    mutate(OOS_friendly = as.factor(OOS_friendly)) |>
    mutate(Public_Private = as.factor(Public_Private)) |>
    mutate(State = as.factor(State)) |>
    mutate(IS_mat_perc = IS_mat / (IS_mat + OOS_mat)) |>
    mutate(OOS_mat_perc = OOS_mat / (IS_mat + OOS_mat)) |>
    mutate(IS_apps_perc = IS_apps / (IS_apps + OOS_apps)) |>
    mutate(OOS_apps_perc = OOS_apps / (IS_apps + OOS_apps)) |>
    mutate(IS_II_perc = IS_II / (IS_II + OOS_II)) |>
    mutate(OOS_II_perc = OOS_II / (IS_II + OOS_II)) |>
    mutate(across(-OOS_friendly, ~ replace_na(., 0))) |>
    select(-c(IS_apps, OOS_apps, IS_mat, OOS_mat, IS_II, OOS_II))

training_df <- MSAR_df[!is.na(MSAR_df$OOS_friendly), ]
df_split <- initial_split(training_df, prop = 0.65)
df_split_train <- training(df_split)
df_split_test <- testing(df_split)

OOS_classifier_recipe <- recipe(OOS_friendly ~ ., data = df_split_train) %>% 
    update_role(School, new_role = 'ID') %>%
    update_role(State, new_role = 'ID') %>% 
    update_role(longitude, new_role = 'ID') %>%
    update_role(latitude, new_role = 'ID') %>%
    step_normalize(all_numeric_predictors()) %>% 
    step_dummy(Public_Private)

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
    fit(data = df_split_train)

## Make predictions on test data
results <- df_split_test %>% select(OOS_friendly) %>% 
    bind_cols(rf_wf_fit %>% 
        predict(new_data = df_split_test)) %>% 
    bind_cols(rf_wf_fit %>% 
        predict(new_data = df_split_test, type = "prob"))

## Print out predictions
results %>% 
    slice_head(n = 10)

results %>% 
    conf_mat(truth = OOS_friendly, estimate = .pred_class) %>%
    autoplot()

## ROC curve
results %>% 
    roc_curve(truth = OOS_friendly, .pred_No) %>% 
    autoplot()

ROC_curve_plot <- autoplot(roc_curve(data = results, truth = OOS_friendly, .pred_No))
ggsave('ROC_curve_MSAR_rf.jpeg', ROC_curve_plot, width = 5, height = 5, dpi = 300)

## compute AUC
results %>% 
    roc_auc(OOS_friendly, .pred_No)

# Extract the fitted model from the workflow
rf_wf_fit %>% 
    extract_fit_parsnip() %>% 
# Make VIP plot
    vip()

ggsave('VIP_MSAR.jpeg', vip(extract_fit_parsnip(rf_wf_fit)), width = 5, height = 5, dpi = 300)

# Save trained workflow
saveRDS(rf_wf_fit, "rf_OOS_classifier_model_MSAR.rds")


############# Make predictions
## read in imputed data 
predict_df <- MSAR_df[is.na(MSAR_df$OOS_friendly), ]

# Load the model into the current R session
loaded_model <- readRDS("rf_OOS_classifier_model_MSAR.rds")

predictions <- predict_df %>% 
    bind_cols(loaded_model %>% predict(predict_df))

MSAR_predictions_df <- training_df |>
    mutate(.pred_class = OOS_friendly) |>
    rbind(predictions)

write.csv(MSAR_predictions_df, 'OOS_friendly_RF_model_prediction_MSAR.csv')
