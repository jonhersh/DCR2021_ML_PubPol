# ------------------------------------------------
# load packages
# ------------------------------------------------
library('tidyverse')
library('tidymodels')
# install.packages(packages)

# uncomment and run if the CR_dat dataset is not loaded
# source('code/1_data_prep.r')

# ------------------------------------------------
# testing/training split of your data
# ------------------------------------------------
# always set seed before doing anything that involves randomization
set.seed(1818)

# initial split is a helper function that will 
# take a dataset and create functions to split into
# testing and training sets
CR_split <- initial_split(CR_dat, p = 0.75)

# create training data
CR_train <- training(CR_split)

# create testing data
CR_test <- testing(CR_split)

# output nrow of each test and training set
lst(CR_train,CR_test) %>% purrr::map(nrow) 


# ------------------------------------------------
# Estimate Ridge Model from data
# ------------------------------------------------
library('glmnetUtils')
ridge_mod <- cv.glmnet(poor_stat ~ ., 
                       data = CR_train %>% select(-household_ID),
                       alpha = 0, 
                       family = "binomial")

# print coefficient matrix using the value of 
# lambda that minimizes cross-validated error
coef(ridge_mod, s = ridge_mod$lambda.min) %>% round(3)

# plot coefficient MSE plot
# x axis is lambda, y is cross-validated MSE
plot(ridge_mod)

# interact with coefficients! 
# Thank you Jared Lander :) 
library('coefplot')
coefpath(ridge_mod)


# ------------------------------------------------
# Estimate Lasso Model from data
# ------------------------------------------------
lasso_mod <- cv.glmnet(poor_stat ~ ., 
                       data = CR_train %>% select(-household_ID),
                       alpha = 1, 
                       family = "binomial")

# print coefficient matrix
coef(lasso_mod, s = lasso_mod$lambda.1se)

# plot coefficient MSE plot
plot(lasso_mod)


# ------------------------------------------------
# Estimate ElasticNet Model from data
# ------------------------------------------------
enet_mod <- cva.glmnet(poor_stat ~ ., 
                       data = CR_train %>% select(-household_ID),
                       alpha = seq(0,1, by = 0.1), 
                       family = "binomial")


# Use this function to find the best alpha
get_alpha <- function(fit) {
    alpha <- fit$alpha
    error <- sapply(fit$modlist, 
                    function(mod) {min(mod$cvm)})
    alpha[which.min(error)]
}

best_alpha <- get_alpha(enet_mod)

# extract the best model object
best_mod <- enet_mod$modlist[[which(enet_mod$alpha == best_alpha)]]

coef(best_mod)


# ------------------------------------------------
# Exercises
# ------------------------------------------------
# 1. Estimate a lasso model using a different formula 

# 2. Estimate an elasticnet model using a different formula




# ------------------------------------------------
# Estimate a ridge model using tidymodels framework
# ------------------------------------------------
library('tidymodels')
set.seed(1818)

# set the parameters for k-fold crossvalidation
folds <- vfold_cv(CR_train, 
                  v = 5)

pov_recipe <- recipe(poor_stat ~ .,
                     data = CR_train) %>% 
    update_role(household_ID, new_role = "ID") %>% 
    # zero variance filter!
    step_nzv(all_numeric()) %>% 
    # create dummy for all variables
    step_dummy(all_nominal(), -all_outcomes()) %>% 
    # convert 0/1 into a factor
    step_num2factor(all_outcomes(), levels = c("0","1"))

# note we just have the recipe 
# we haven't cooked it yet! 
print(pov_recipe)

# set Ridge as the engine (or oven?) that will cook out model
ridge_spec <- 
    logistic_reg(penalty = tune(), mixture = 0) %>% 
    set_engine("glmnet") 

# still nothing has been done! 
ridge_spec

# set workflow of modeling process
wf <- workflow() %>% 
    add_model(ridge_spec) %>% 
    add_recipe(pov_recipe)
    
# finally pass to the fit function to actually 
# run the model! 
# set grid for lambdas
lambda_grid <- grid_regular(penalty(), levels = 50)

ridge_fit <- wf %>% 
    tune_grid(data = CR_train,
              grid = lambda_grid,
              resamples = folds)

# print out coefficient vector
ridge_fit %>% 
    pull_workflow_fit() %>% 
    tidy()

select_best(ridge_fit, metric = "rmse")
