# ------------------------------------------------
# Load packages and data prep
# ------------------------------------------------
library('tidyverse')

source('code/1_data_prep.r')


# ------------------------------------------------
# GLIMPSE to summarize data
# ------------------------------------------------
# let's summarize the IDB poverty data using the glimpse function
# from https://www.kaggle.com/c/costa-rican-household-poverty-prediction/data?select=codebook.csv

glimpse(CR_dat)


# ------------------------------------------------
# Pipe Operator!  
# ------------------------------------------------
# The pipe operator "%>%" is super useful!
# It allows us to execute a series of functions on an object in stages
# The general recipe is Data_Frame %>% function1() %>% function2() etc
# Functions are applied right to left

CR_dat %>% glimpse()
glimpse(CR_dat)

# cmd shift 
CR_dat %>% glimpse() 
glimpse(CR_dat)


# ------------------------------------------------
# Slice function: to select ROWS 
# ------------------------------------------------
# SLICE: slice to view only the first 10 rows
CR_dat %>% slice(1:10)

# SLICE to view only rows 300 to 310 
CR_dat %>% slice(300:310)



# ------------------------------------------------
# Arrange function: to ORDER dataset
# ------------------------------------------------

# arrange the dataframe in descending order by mean_educ
CR_dat %>% 
    arrange(desc(mean_educ)) %>% 
    head()

# arrange the dataframe in ascending order by mean_educ
CR_dat %>%
    arrange(mean_educ) %>% 
    head()
    

# arrange via multiple columns, by budget and title year, then output rows 1 to 10
CR_dat %>% 
    arrange(desc(mean_educ), dep_rate) %>% 
    slice(1:10)


# ------------------------------------------------
# SELECT columns of the dataset using the 'select' function
# ------------------------------------------------
# select then pass to table function 
CR_dat %>% select(poor_stat) %>% table() 

# select only columns starting with particular characters 
CR_dat %>% 
    select(starts_with("num")) %>% 
    head()

# remove variables using - operator
CR_dat %>% 
    select(-num_rooms) %>% 
    head()

# ------------------------------------------------
# RENAME variables using the RENAME function
# ------------------------------------------------
# note we must pass the DF back to the original data
CR_dat <- CR_dat %>% 
    rename(HH_ID = household_ID) 

CR_dat %>% names()

# change it back!
CR_dat <- CR_dat %>% 
    rename(household_ID = HH_ID) 


# ------------------------------------------------
# FILTER and ONLY allow certain rows using the FILTER function
# ------------------------------------------------
# only select households with poverty status
# and see # of rows
CR_dat %>% 
    filter(poor_stat ==  1) %>% 
    head()

CR_dat %>% 
    filter(mar_stat == "divorced") %>% 
    count()

CR_dat %>% 
    filter(comp == 1 & num_hh > 3) %>% 
    count()



# ------------------------------------------------
# MUTATE to Transform variables in your dataset
# ------------------------------------------------
# adding new variables using mutate()
CR_dat <- CR_dat %>% 
    mutate(mean_educ_sq = mean_educ * mean_educ,
           mean_educ_log = log(mean_educ + 1))

# see average education and educ squared 
CR_dat %>% select(matches("educ")) %>% colMeans()

# Same thing, but using the package purrr to "map"
# the function mean to all the columns of the data frame
CR_dat %>% select(matches("educ")) %>% map_df(mean)


# ------------------------------------------------
# Create summary statistics by GROUP using group_by()
# ------------------------------------------------
CR_dat <- CR_dat %>% 
        # group by urban rural status
    group_by(urban) 

glimpse(CR_dat)


# calculate average and sd of poverty by group 
CR_urb <- CR_dat %>% 
    # calculate average poor status
    summarize(pov_avg = mean(poor_stat),
              pov_sd = sd(poor_stat)) %>% 
    print()

CR_dat %>% 
    group_by(poor_stat) %>% 
    select_if(is.numeric) %>%
    summarize(across(everything(), mean))

# ------------------------------------------------
# Exercises
# ------------------------------------------------
# 1. Use mutate to create a new variable num_children_sq
#    which is equal to num_children * num_children.

# 2. Use filter to determine the number of households 
#    in the dataset that have children 

# 3. Use group_by and summarize to calculate fraction of 
#    households without electricity in urban vs rural areas

# 4. (Time permitting) Use ggplot2 to explore some interesting
#    data visualizations with the data. 
#    Don't feel obligated to do so if you aren't a ggplot2 expert! 
