# ------------------------------------------------
# Setup
# ------------------------------------------------
# Please download and install:
#   - R 4.0.3
#   - R Studio 1.4.1056

# ------------------------------------------------
# Packages to Install
# ------------------------------------------------
packages <- c(
    'ggthemes', 
    'glmnet', 
    'here', 
    'leaflet', 
    'rmarkdown', 
    'rprojroot', 
    'threejs', 
    'tidymodels', 
    'tidyverse', 
    'usethis', 
    'UsingR', 
    'randomForests',
    'glmnetUtils',
    'GGally',
    'partykit',
    'rpart',
    'plotROC',
    'randomForestExplainer',
    'caret'
)

# install.packages(packages)


# ------------------------------------------------
# data prep
# ------------------------------------------------
library('tidyverse')
library('here')

# from https://www.kaggle.com/c/costa-rican-household-poverty-prediction/data?select=codebook.csv
train <- read.csv(here::here("datasets", "train.csv"))
test <- read.csv(here::here("datasets", "train.csv"))

CR_dat <- bind_rows(train, test)

CR_dat <- 
    CR_dat %>% 
    rename(household_ID = idhogar,
           poor_stat = Target,
           num_rooms = rooms,
           bathroom = v14a,
           refrig = refrig,
           no_elect = noelec,
           no_toilet = sanitario1,
           comp = computer,
           tv = television,
           mobile = mobilephone,
           num_hh = tamhog,
           urban = area1,
           mean_educ = meaneduc,
           num_children = hogar_nin,
           num_adults = hogar_adul,
           num_elderly = hogar_mayor,
           disabled = dis) %>% 
    mutate(poor_stat = if_else(poor_stat == 1 | poor_stat == 2, 1,0),
           dep_rate = (num_children + num_elderly) / num_adults,
           mar_stat = case_when(estadocivil3 == 1 ~ "married",
                                estadocivil4 == 1~ "divorced",
                                estadocivil6 == 1~ "widowed",
                                !estadocivil6 ==1 & 
                                    !estadocivil3 ==1 & 
                                    !estadocivil4== 1 ~ "other")) %>% 
    mutate(mar_stat = as.factor(mar_stat)) %>% 
    filter(parentesco1 == 1) %>% 
    select(household_ID,poor_stat,num_rooms,
           bathroom, refrig, no_elect, no_toilet, comp, dep_rate,
           tv, mobile, num_hh, urban, mean_educ, num_children, num_adults,
           num_elderly, disabled, mar_stat) %>% 
    drop_na()

rm(test)
rm(train)
