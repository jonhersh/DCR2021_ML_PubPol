
#------------------------------------------------------------
# Regression Trees
#------------------------------------------------------------
library(partykit)
library(tidyverse)
library(rpart)       

set.seed(1818)

# Use the function ctree in rparty to estimate a 
# single regression tree classification model 
poor_tree <- ctree(poor_stat ~  urban + num_children + comp + no_toilet,
                   data = CR_train %>% 
                       mutate(poor_stat = as.factor(poor_stat)))

# print the fitted model object 
print(poor_tree)

# Viewing the fitted model is easier 
plot(poor_tree, gp)


names(CR_train)


#------------------------------------------------------------
# Cross-Validating to Select Optimal Tree Depth
#------------------------------------------------------------
# cross validate to get optimal tree depth
# must use rpart package here

# rpart function to select optimal depth of tree
# read the help() file for rpart.control to learn about 
#  the different function options
# max depth  ensures the final tree only has this 
#  many splits
# min split means minimum observations in a node before 
#  a split can be attempted
# cp is the complexity parameter, overall Rsq must 
#  increase by cp at each step
library('rpart')
poor_rpart <- rpart(poor_stat ~ ., 
                           data =  CR_train %>%  
                        select(-household_ID) %>% 
                        mutate(poor_stat = as.factor(poor_stat)),
                           method = "class",
                           control = list(cp = 0, 
                                          minsplit = 10,
                                          maxdepth = 10))
poor_rpart$cptable

# plot the relationship between tree complexity (depth and cp)
# and CV error
plotcp(poor_rpart)



#---------------------------------------------------------------
# Random Forest
#---------------------------------------------------------------
library('randomForest')

rf_fit <- randomForest(poor_stat ~ ., 
                       data = CR_train %>% 
                           select(-household_ID) %>% 
                           mutate(poor_stat = 
                                      as.factor(poor_stat)), 
                       type = classification,
                       mtry = 3,
                       na.action = na.roughfix,
                       ntree = 100, 
                       importance = TRUE)

print(rf_fit)

plot(rf_fit)

#---------------------------------------------------------------
# Variable Importance
#---------------------------------------------------------------

varImpPlot(rf_fit, type = 1)
importance(rf_fit)

#---------------------------------------------------------------
# Explain Forest
#---------------------------------------------------------------
# really cool package!
# https://cran.r-project.org/web/packages/randomForestExplainer/vignettes/randomForestExplainer.html
library('randomForestExplainer')

plot_min_depth_distribution(rf_fit, mean_sample = "top_trees")

plot_multi_way_importance(rf_fit, size_measure = "no_of_nodes")


plot_predict_interaction(rf_fit, CR_train, "mean_educ", "num_children")

# explain_forest(rf_fit, 
#               interactions = TRUE, 
#               data =  CR_train %>% select(-household_ID))


#---------------------------------------------------------------
# Cross-validate to select optimal mtry 
#---------------------------------------------------------------
library('caret')

rf_caret <-
    train(poor_stat ~ urban + num_children + comp + no_toilet
                      + dep_rate + mobile + mean_educ,
          CR_train %>%  
              select(-household_ID) %>% 
              mutate(poor_stat = 
                         as.factor(poor_stat)),
          method = "rf",
          metric = "Accuracy",
          tuneLength = 10,
          trControl = trainControl(method = "cv", 
                                   number = 5, 
                                   verbose = TRUE))

plot(rf_caret)


#---------------------------------------------------------------
# Exercises
#---------------------------------------------------------------
# 1. Estimate a random forest model using mtry = 4 on a different
#    formula

# 2. Generate predictions for the test set and plot the ROC curve

# 3. Extra credit! Use another model in caret (xgboost?) to estimate
#    another ML model against the data. Does it perform better or worse?
