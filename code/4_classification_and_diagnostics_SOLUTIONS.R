

# ------------------------------------------------
#  Exercises
# ------------------------------------------------
# 1. Generate predicted scores using the lasso model
#    for the test data frame (using lambda.min)

scores_train <- 
  tibble(true = as.factor(CR_train$poor_stat), 
         preds_lasso = predict(lasso_mod, newdata = CR_train, s = "lambda.min", type = "response")[,1], 
         preds_ridge = predict(ridge_mod, newdata = CR_train, s = "lambda.min", type = "response")[,1]
  )

scores_test <- 
  tibble(true = as.factor(CR_test$poor_stat), 
         preds_lasso = predict(lasso_mod, newdata = CR_test, s = "lambda.min", type = "response")[,1], 
         preds_ridge = predict(ridge_mod, newdata = CR_test, s = "lambda.min", type = "response")[,1]
  )



# 2. Generate class predictions using a variety of cutoffs

preds_train_0_3 <- scores_train %>%  
  mutate(class_lasso = 
           as.factor(if_else(preds_lasso > 0.3,1,0)),
         class_ridge = 
           as.factor(if_else(preds_lasso > 0.3,1,0)))


# 3. Compute confusion a confusion matrix for those various
#    cutoff thresholds

conf_mat(preds_train_0_3,
         truth = true,
         estimate = class_lasso)

caret::confusionMatrix(preds_train_0_3$class_lasso, preds_train_0_3$true)

# 4. Produce an ROC plot using the lasso model predictions
#    for the test set. 

library('plotROC')
p <- ggplot(scores_train %>% mutate(true = as.numeric(as.character(true))), 
            aes(m = preds_lasso, d = true)) + 
  geom_roc(labelsize = 3.5, 
           cutoffs.at = 
             c(0.99,0.9,0.7,0.5,0.3,0.1,0)) +
  theme_minimal(base_size = 16)
print(p)
calc_auc(p)

p <- ggplot(scores_test %>% mutate(true = as.numeric(as.character(true))), 
            aes(m = preds_lasso, d = true)) + 
  geom_roc(labelsize = 3.5, 
           cutoffs.at = 
             c(0.99,0.9,0.7,0.5,0.3,0.1,0)) +
  theme_minimal(base_size = 16)
print(p)
calc_auc(p)


# 5. Our model is overfit if the accuracy in the test is 
#    considerably worse than the accuracy in the training. 
#    Compare the AUC metric in the test versus train for the 
#    ridge model. Is our model overfit or underfit? 

# 6. Extra credit! Do the above using the ElasticNet model
#    Generate predictions using the optimal value of lambda